FROM jenkins/jenkins:latest
USER root

WORKDIR /usr/src/
COPY jenkins-cli.jar .
COPY start-jenkins.sh .

ENTRYPOINT ["/usr/src/start-jenkins.sh"]
