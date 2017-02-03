# LAMP Base Docker Image

## What Is This?

LAMP in one container.

## Quick Start

To download the already built image from docker hub and run it (You have to provide `<your-container-name>`, `<your-html-dir>`, `<your-mysql-data-dir>`):

```sh
~ $ docker run \
    --name <your-container-name> \
    -v `pwd`/<your-html-dir>:/var/www/html \
    -v `pwd`/<your-mysql-data-dir>:/var/lib/mysql \
    -p 8000:80 \
    -p 33060:3306 \
    -p 9001:9001 \
    appkr/lamp-base
```

If `80` and `3306` ports are available on your host machine, you can map it like `-p 80:80 -p 3306:3306`.

## Test

- `http://localhost:8000` to open a index page in document root of apache2.
- `$ mysql --h127.0.0.1 -uroot -P33060 -p` (Default password: `root`).
- `http://localhost:9001` to open the supervisor dashboard (Default account: `homestead`/`secret`).

## Build

To build your own image:

```sh
~/ $ git clone git@github.com:appkr/lamp-base.git
~/ $ cd lamp-base
~/lamp-base $ docker build \
    --tag <name-your-image>:<tag> \
    .
```

To run your own build:

```sh
~/lamp-base $ docker run \
    --name <name-your-container> \
    -v `pwd`/html:/var/www/html \
    -v `pwd`/data:/var/lib/mysql \
    -p 8000:80 \
    -p 33060:3306 \
    -p 9001:9001 \
    <name-your-image>:<tag>
```

docker run -d \
    --name lamp-base \
    -v `pwd`/html:/var/www/html \
    -v `pwd`/data:/var/lib/mysql \
    -p 8000:80 \
    -p 33060:3306 \
    -p 9001:9001 \
    appkr/lamp-base:latest

## Troubleshooting

While building the Dockerfile, most of the errors were aroused from MySQL.

- The first thing you have to look into is the logs. MySQL log lives in `/var/log/mysql/error.log`
- "No directory, logging in with HOME=/" This happens when mysql user's home directory is not designated. Run `usermod -d /var/lib/mysql/ mysql` in the docker machine.
- "Fatal error: Can't open and lock privileges table: Table 'mysql.user' does'nt exists" This happens when there is not `mysql.user` table. Stop the running container, remove all the content of local mounted volume for `/var/lib/mysql`(e.g. `data`), and then restart the container.
