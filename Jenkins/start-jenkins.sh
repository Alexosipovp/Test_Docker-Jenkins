#!/bin/bash

# Запуск Jenkins
java -jar /usr/share/jenkins/jenkins.war &

# Адрес пароля админа
path_of_initialAdminPassword="/var/jenkins_home/secrets/initialAdminPassword"

# Функция-тормоз для ожидания пароля
Waiting_for_Jenkins_password_generation () {
    echo "Ожидание генерации пароля Jenkins..."
    while [ ! -f $path_of_initialAdminPassword ]; do
        sleep 2
    done
    initialAdminPassword=$(cat $path_of_initialAdminPassword)
    echo "Пароль Jenkins появился!"
}

# Функция-тормоз для ожидания полной загрузки
Waiting_for_Jenkins_to_be_ready () {
    echo "Ждем готовности веб-интерфейса..."
    until curl -s -f http://localhost:8080/login > /dev/null; do
        sleep 2
    done
}

# Шаблон обращения к jenkins-cli.jar
jenkins_cli () {
    java -jar jenkins-cli.jar -s http://localhost:8080/ -auth admin:$initialAdminPassword $@
}

Waiting_for_Jenkins_password_generation
Waiting_for_Jenkins_to_be_ready

echo "Начало скачки плагинов"

#jenkins_cli install-plugin git
#jenkins_cli install-plugin configuration-as-code

while IFS= read -r plugin || [[ -n "$plugin" ]]; do
    clean_plugin=$(echo -e "$plugin" | tr -d '\000-\031')
    echo "Установка: '$clean_plugin'"
    jenkins_cli install-plugin $clean_plugin
done < "plugins.txt"

echo "Конец скачки плагинов"

# Перезагрузка после установки плагинов
echo "Перезагрузка"
jenkins_cli restart

# Обновление пароля и ожидание полной загрузки
Waiting_for_Jenkins_to_be_ready 
Waiting_for_Jenkins_password_generation


echo "Всё готово!"

wait