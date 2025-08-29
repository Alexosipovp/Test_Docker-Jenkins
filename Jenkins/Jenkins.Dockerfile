FROM jenkins/jenkins:latest

USER root

WORKDIR /usr/app/
COPY . .

#RUN mkdir -p /var/jenkins_home/casc_configs
#COPY src/jenkins.yaml /var/jenkins_home/casc_configs/jenkins.yaml

#COPY pipeline.groovy /var/jenkins_home/casc_configs/pipeline.groovy

ENTRYPOINT ["/usr/app/config/start-jenkins.sh"]
