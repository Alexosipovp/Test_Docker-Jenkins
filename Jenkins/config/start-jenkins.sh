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
    java -jar /usr/app/config/jenkins-cli.jar -s http://localhost:8080/ -auth admin:$initialAdminPassword $@
}

Waiting_for_Jenkins_password_generation
Waiting_for_Jenkins_to_be_ready

echo "Начало скачки плагинов"
mapfile -t plugins < "/usr/app/config/plugins.txt"  # Читаем ВСЕ строки сразу чтобы избежать конкуренции за stdin
for plugin in "${plugins[@]}"; do
    clean_plugin=$(echo -e "$plugin" | sed 's/ .*$//; s/#.*$//' | tr -d '\000-\031') # Удаление лишних символов и комментариев
    [[ -z "$clean_plugin" ]] && continue # Пропуск пустых строк
    echo "Установка: '$clean_plugin'"
    jenkins_cli install-plugin "$clean_plugin"
done
echo "Конец скачки плагинов"

'''
echo "Установка конфигурации из файла"
export CASC_JENKINS_CONFIG=/src/jenkins.yaml
jenkins_cli reload-configuration
echo "Конец установки конфигурации"
'''

# Перезагрузка после установки плагинов
echo "Перезагрузка"
jenkins_cli restart

# Обновление пароля и ожидание полной загрузки
Waiting_for_Jenkins_to_be_ready 
Waiting_for_Jenkins_password_generation


jenkins_cli create-job helmy-pipeline-job < /usr/app/src/config.xml

echo "Всё готово!"

wait