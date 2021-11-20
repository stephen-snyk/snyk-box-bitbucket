apt update -y && apt upgrade -y
apt install -y nginx jq apt-transport-https ca-certificates curl software-properties-common

# Obtain origin certificate
openssl req -new -newkey rsa:2048 -nodes -keyout ${web_zone}.key -out ${web_zone}.csr -subj "/C=US/ST=TX/L=CFTest/O=CFtest/CN=*.${web_zone}" 2>/dev/null
cfCSR=$(awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' ${web_zone}.csr)
certGenerate=$(curl -sX POST "https://api.cloudflare.com/client/v4/certificates" \
    -H "X-Auth-Email: ${cf_user}" \
    -H "X-Auth-Key: ${cf_api}" \
    --data '{"hostnames":["'"${web_zone}"'","*.'"${web_zone}"'"],"requested_validity":5475,"request_type":"origin-rsa","csr":"'"$cfCSR"'"}')
echo $certGenerate | jq -r .result.certificate > ${web_zone}.crt
mv ${web_zone}.key /etc/ssl/private/
mv ${web_zone}.crt /etc/ssl/certs/

# Docker install
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
apt update -y
apt install docker-ce docker-compose -y

# Update nginx configs
cat > /etc/nginx/sites-available/default << "EOF"
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    listen 443 ssl http2 default_server;
    listen [::]:443 ssl http2 default_server;
    ssl_certificate /etc/ssl/certs/${web_zone}.crt;
    ssl_certificate_key /etc/ssl/private/${web_zone}.key;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_prefer_server_ciphers on;
    ssl_ciphers 'EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH';
    
    server_name _;

    set_real_ip_from 103.21.244.0/22;
    set_real_ip_from 103.31.4.0/22;
    set_real_ip_from 103.22.200.0/22;
    set_real_ip_from 104.16.0.0/12;
    set_real_ip_from 108.162.192.0/18;
    set_real_ip_from 131.0.72.0/22;
    set_real_ip_from 141.101.64.0/18;
    set_real_ip_from 162.158.0.0/15;
    set_real_ip_from 172.64.0.0/13;
    set_real_ip_from 173.245.48.0/20;
    set_real_ip_from 188.114.96.0/20;
    set_real_ip_from 190.93.240.0/20;
    set_real_ip_from 197.234.240.0/22;
    set_real_ip_from 198.41.128.0/17;
    set_real_ip_from 2400:cb00::/32;
    set_real_ip_from 2606:4700::/32;
    set_real_ip_from 2803:f800::/32;
    set_real_ip_from 2405:b500::/32;
    set_real_ip_from 2405:8100::/32;
    set_real_ip_from 2c0f:f248::/32;
    set_real_ip_from 2a06:98c0::/29;
    real_ip_header CF-Connecting-IP;

    location / {
        proxy_set_header HOST $http_host;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass http://127.0.0.1:8080;
    }
}
EOF

touch /tmp/db.json
cat > /tmp/db.json << "EOF"
{
  "posts": [
    { "id": 1, "body": "foo" },
    { "id": 2, "body": "bar" }
  ],
  "comments": [
    { "id": 1, "body": "baz", "postId": 1 },
    { "id": 2, "body": "qux", "postId": 2 }
  ]
}
EOF

cat > /tmp/docker-compose.yml << "EOF"
version: '3'
services:
  echo:
    image: mendhak/http-https-echo
    restart: always
    container_name: echo
    ports:
      - 8080:443

  api:
    image: clue/json-server
    restart: always
    container_name: json
    ports:
      - 8081:80
    volumes:
      - ./db.json:/data/db.json

  httpbin:
    image: kennethreitz/httpbin
    restart: always
    container_name: httpbin
    ports:
      - 8082:80
EOF

mkdir /var/www/system2
mkdir /var/www/system2/html
wget -O /var/www/system2/html/index.html https://raw.githubusercontent.com/freshdemo/perciballi.ca/main/system2.html
wget -O /etc/nginx/sites-available/system2.${web_zone}.conf https://raw.githubusercontent.com/freshdemo/perciballi.ca/main/system2.perciballi.ca.conf
cp /etc/nginx/sites-available/default /etc/nginx/sites-available/api.${web_zone}.conf
sed -i -e 's/_;/api.${web_zone};/g' /etc/nginx/sites-available/api.${web_zone}.conf
cp /etc/nginx/sites-available/api.${web_zone}.conf /etc/nginx/sites-available/httpbin.${web_zone}.conf
sed -i -e 's/perciballi.ca/zerotrust.gq/g' /etc/nginx/sites-available/system2.${web_zone}.conf
sed -i -e 's/api/httpbin/g' /etc/nginx/sites-available/httpbin.${web_zone}.conf
sed -i -e 's/default_server//g' /etc/nginx/sites-available/*.conf
sed -i -e 's/8080/8081/g' /etc/nginx/sites-available/api.${web_zone}.conf
sed -i -e 's/8080/8082/g' /etc/nginx/sites-available/httpbin.${web_zone}.conf
#sed -i -e 's/8080/8083/g' /etc/nginx/sites-available/system2.${web_zone}.conf
sed -i -e 's/http:/https:/g' /etc/nginx/sites-available/default
sed -i '/        proxy_pass/a \\tproxy_ssl_server_name on;\n        proxy_ssl_name $ssl_server_name;' /etc/nginx/sites-available/default
ln -s /etc/nginx/sites-available/*.conf /etc/nginx/sites-enabled/
ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/

cd /tmp
docker-compose up -d && systemctl restart nginx


wget -O /root/cloudflared-linux-amd64.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i /root/cloudflared-linux-amd64.deb
mkdir ~/.cloudflared
touch ~/.cloudflared/cert.json
touch ~/.cloudflared/config.yml
cat > ~/.cloudflared/cert.json << "EOF"
{
    "AccountTag"   : "${account}",
    "TunnelID"     : "${tunnel_id}",
    "TunnelName"   : "${tunnel_name}",
    "TunnelSecret" : "${secret}"
}
EOF
cat > ~/.cloudflared/config.yml << "EOF"
tunnel: ${tunnel_id}
credentials-file: /etc/cloudflared/cert.json
logfile: /var/log/cloudflared.log
loglevel: info

ingress:
  - hostname: httpbin.${web_zone}
    service: http://localhost:8082
  - hostname: httpbin2.${web_zone}
    service: http://localhost:8082
  - hostname: ssh.${web_zone}
    service: ssh://localhost:22
  - hostname: ssh2.${web_zone}
    service: ssh://localhost:22
  - hostname: "*"
    service: hello-world
EOF

sudo cloudflared service install
sudo cp -via ~/.cloudflared/cert.json /etc/cloudflared/

cd /tmp
sudo service cloudflared start
