FROM atlassian/bitbucket

COPY ssl-keystore $BITBUCKET_HOME/shared/config/ssl-keystore
#RUN /opt/java/openjdk/bin/keytool -genkey -noprompt -alias tomcat -dname "CN=bitbucket, OU=bitbucket, O=bitbucket, L=nope, S=nope, C=CA" -keystore $BITBUCKET_HOME/shared/config/ssl-keystore -keyalg RSA -sigalg SHA256withRSA -storepass changeit -keypass changeit
COPY bitbucket.properties /var/atlassian/application-data/bitbucket/shared/
RUN chown -R bitbucket /var/atlassian/
RUN chgrp -R bitbucket /var/atlassian/


EXPOSE 443
