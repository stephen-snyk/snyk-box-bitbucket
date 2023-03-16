apt update -y && apt upgrade -y
apt install -y ca-certificates curl software-properties-common

# Docker install
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
apt update -y
apt install docker-ce -y

docker run  --name="bitbucket" -d -p 7990:7990 -p 7999:7999 atlassian/bitbucket
EOF
