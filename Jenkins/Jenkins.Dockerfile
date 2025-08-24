FROM jenkins/jenkins:latest
USER root

#WORKDIR /usr/src/
#COPY jenkins-cli.jar .

RUN apt-get update && apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord"]

#RUN <<EOF
#CMD cat /var/lib/jenkins/secrets/initialAdminPassword
#EOF

#/var/jenkins_home/secrets/initialAdminPassword
    # pwd
    # ls

# java -jar jenkins-cli.jar -s http://localhost:8080/ -auth admin:18f1d66675154135b43138851b23d84f help
