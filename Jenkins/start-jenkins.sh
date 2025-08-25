#!/bin/bash

java -jar /usr/share/jenkins/jenkins.war &

path_of_initialAdminPassword="/var/jenkins_home/secrets/initialAdminPassword"

echo "Ожидание генерации пароля Jenkins..."
while [ ! -f $path_of_initialAdminPassword ]; do
    sleep 5
done

initialAdminPassword=$(cat $path_of_initialAdminPassword)

echo "Пароль Jenkins появился!"
echo $initialAdminPassword
echo $(java -jar jenkins-cli.jar -s http://localhost:8080/ -auth admin:$initialAdminPassword help)

wait