#!/usr/bin/env bash

function start_mysql() {
    status="$(service mysql status)"
    if [[ $status =~ .*stopped ]]; then
        service mysql start
    fi
}

function stop_mysql() {
    status="$(service mysql status)"
    if [[ $status =~ .*running ]]; then
        service mysql stop
        mysqld stop
    fi
}

if [ ! -d $MYSQL_DATA_DIR/mysql ]; then rm -rf $MYSQL_DATA_DIR/* \
    && mkdir -p $MYSQL_PID_DIR \
    && chmod 777 $MYSQL_PID_DIR \
    && usermod -d $MYSQL_DATA_DIR mysql \
    && chown -R mysql:mysql $MYSQL_DATA_DIR $MYSQL_PID_DIR \
    && mysqld --user=mysql --initialize-insecure \
    && start_mysql \
    && mysql -v -e "CREATE USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}'; GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'; FLUSH PRIVILEGES;" \
    && sleep 1 \
    && stop_mysql \
    && sleep 1 \
    && mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql mysql
fi;

exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
