FROM jenkins/jenkins:latest

USER root

#WORKDIR /usr/app/
COPY . /usr/app/

#RUN mkdir -p /var/jenkins_home/casc_configs
#COPY src/jenkins.yaml /var/jenkins_home/casc_configs/jenkins.yaml

#COPY pipeline.groovy /var/jenkins_home/casc_configs/pipeline.groovy

RUN sed -i 's/\r$//' /usr/app/config/start-jenkins.sh && \
    chmod +x /usr/app/config/start-jenkins.sh

ENTRYPOINT ["/usr/app/config/start-jenkins.sh"]
