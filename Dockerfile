FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
ENV MYSQL_DATA_DIR=/var/lib/mysql
ENV MYSQL_PID_DIR=/var/run/mysqld
ENV MYSQL_ROOT_PASSWORD=secret
ENV APACHE_ENVVARS=/etc/apache2/envvars

#-------------------------------------------------------------------------------
# Install Packages
#-------------------------------------------------------------------------------

RUN { \
    echo mysql-community-server mysql-community-server/data-dir select ''; \
    echo mysql-community-server mysql-community-server/root-pass password ''; \
    echo mysql-community-server mysql-community-server/re-root-pass password ''; \
    echo mysql-community-server mysql-community-server/remove-test-db select false; \
} | debconf-set-selections

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        wget \
        ca-certificates \
        locales \
        supervisor \
        apache2 \
        php \
        php-cli \
        php-curl \
        php-gd \
        php-mbstring \
        php-mysql \
        php-sqlite3 \
        php-xdebug \
        php-xml \
        libapache2-mod-php \
        mysql-server \
        mysql-client \
        vim \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#-------------------------------------------------------------------------------
# Install utf8 locales
#-------------------------------------------------------------------------------

RUN locale-gen en_US.UTF-8

#-------------------------------------------------------------------------------
# Copy Settings
#-------------------------------------------------------------------------------

COPY files /

#-------------------------------------------------------------------------------
# Configure MySQL
#-------------------------------------------------------------------------------

RUN sed -i "s/user[\t ]*=.*/user=root/g" /etc/mysql/debian.cnf \
    && sed -i "s/password[\t ]*=.*/password=/g" /etc/mysql/debian.cnf

#-------------------------------------------------------------------------------
# Configure Apache
#-------------------------------------------------------------------------------

# @see https://github.com/docker-library/php/blob/e573f8f7fda5d7378bae9c6a936a298b850c4076/7.0/apache/Dockerfile#L38
RUN sed -ri 's/^export ([^=]+)=(.*)$/: ${\1:=\2}\nexport \1/' "$APACHE_ENVVARS" \
    && . "$APACHE_ENVVARS" \
    && for dir in \
        "$APACHE_LOCK_DIR" \
        "$APACHE_RUN_DIR" \
        "$APACHE_LOG_DIR" \
        /var/www/html \
    ; do \
        rm -rvf "$dir" \
            && mkdir -p "$dir" \
            && chown -R "$APACHE_RUN_USER:$APACHE_RUN_GROUP" "$dir"; \
    done

RUN a2dissite 000-default \
    && a2ensite default \
    && a2enmod rewrite deflate headers

#-------------------------------------------------------------------------------
# Run Environment
#-------------------------------------------------------------------------------

VOLUME ["/var/www/html", "/var/lib/mysql"]
EXPOSE 80 9001 3306 10001
WORKDIR /var/www/html
RUN chmod 755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]