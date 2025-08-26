FROM jenkins/jenkins:latest

USER root

WORKDIR /usr/src/
COPY jenkins-cli.jar .
COPY start-jenkins.sh .
COPY plugins.txt .

#RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt
#RUN mkdir -p /var/jenkins_home/casc_configs

#RUN mkdir -p /var/jenkins_home/casc_configs
#COPY jenkins.yaml /var/jenkins_home/casc_configs/jenkins.yaml

#COPY pipeline.groovy /var/jenkins_home/casc_configs/pipeline.groovy

ENTRYPOINT ["/usr/src/start-jenkins.sh"]
