[![Build Status](https://travis-ci.org/appkr/lamp-base.svg?branch=master)](https://travis-ci.org/appkr/lamp-base)

# LAMP Base Docker Image

## 1. What Is This?

LAMP in one container.

The `master` branch is linked to `latest` tag. But ironically, `latest` tag is linked to `16.04` tag for users who depends on `appkr/lamp-base:latest`.

tag|Ubuntu|PHP|MySQL
---|---|---|---
`appkr/lamp-base:16.04`|16.04|7.0|5.7
`appkr/lamp-base:18.04`|18.04|7.2|5.7

## 2. Quick Start

To download the already built image from docker hub and run it:

```sh
~ $ docker run -d \
    --name lamp \
    -v `pwd`/html:/var/www/html \
    -v `pwd`/data:/var/lib/mysql \
    -p 80:80 \
    -p 3306:3306 \
    -p 9001:9001 \
    appkr/lamp-base:16.04
```

## 3. Test

- `http://localhost` to open a index page in document root of apache2.
- `$ docker exec -it lamp mysql`
- `http://localhost:9001` to open the supervisor dashboard (Default account: `homestead`/`secret`).

## 4. Your Own Build

To build your own image:

```sh
~/ $ git clone git@github.com:appkr/lamp-base.git
~/ $ cd lamp-base
~/lamp-base(master) $
~/lamp-base(master) $ docker build  --tag mylamp:16.04 .
```

To run your own build:

```sh
~/lamp-base $ docker run -d \
    --name mylamp \
    -v `pwd`/html:/var/www/html \
    -v `pwd`/data:/var/lib/mysql \
    -p 80:80 \
    -p 3306:3306 \
    -p 9001:9001 \
    mylamp:16.04
```

## 5. Troubleshooting

While building the Dockerfile, most of the errors were aroused from MySQL.

-   The first thing you have to look into is the logs. MySQL log lives in `/var/log/mysql/error.log`

-   "No directory, logging in with HOME=/" This happens when mysql user's home directory is not designated. Run `usermod -d /var/lib/mysql/ mysql` in the docker machine.

-   "Fatal error: Can't open and lock privileges table: Table 'mysql.user' does'nt exists" This happens when there is not `mysql.user` table. Stop the running container, remove all the content of local mounted volume for `/var/lib/mysql`(e.g. `data`), and then restart the container.

-   If `root@%` user was not correctly created:

    ```bash
    ~/any $ docker exec -it lamp \
        mysql -v -e "CREATE USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}'; GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'; FLUSH PRIVILEGES;"
    ```

-   If MySql socket was not correctly created("spawn error" or "socket ..."):

    ```bash
    ~/any $ docker exec -it lamp bash /refresh_mysql_pid.sh
    ```

-   In most cases, starting from scratch is much easier. To do that run the following commands and re-iterate from the beginning:

    ```bash
    # Clean up the MySql data directory
    ~/lamp-base $ ls -d data/* | grep -v .gitignore | xargs rm -rf

    # Stop running container and remove it
    ~/any $ docker container stop lamp && docker container rm lamp

    # Remove image
    ~/any $ docker image --force appkr/lamp-base:16.04
    ```
