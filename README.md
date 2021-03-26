[![Build Status](https://travis-ci.org/appkr/lamp-base.svg?branch=master)](https://travis-ci.org/appkr/lamp-base) [![Docker build](https://img.shields.io/docker/build/appkr/lamp-base.svg)](https://hub.docker.com/r/appkr/lamp-base) [![Docker downloads](https://img.shields.io/docker/pulls/appkr/lamp-base.svg)](https://hub.docker.com/r/appkr/lamp-base)

## PHP-Apache Base Docker Image

```bash
$ docker-compose up -d

$ docker container ls 
# CONTAINER ID   IMAGE        COMMAND                  CREATED              STATUS                        PORTS                               NAMES
# 4962ab5dab14   web:latest   "docker-php-entrypoi…"   About a minute ago   Up About a minute (healthy)   0.0.0.0:8000->80/tcp                web
# be335e43eacc   mysql:5.7    "docker-entrypoint.s…"   About a minute ago   Up About a minute (healthy)   0.0.0.0:3306->3306/tcp, 33060/tcp   mysql
# 3330cb28278d   redis:6.2    "docker-entrypoint.s…"   About a minute ago   Up About a minute (healthy)   0.0.0.0:6379->6379/tcp              redis
```


