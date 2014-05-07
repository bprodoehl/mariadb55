#!/bin/sh

export MONIT_MYSQL_USER={{MONIT_MYSQL_USER}}
export MONIT_MYSQL_PASSWORD={{MONIT_MYSQL_PASSWORD}}
export MONIT_HOST=localhost
export MONIT_PORT=3306

export LUA_PATH=/usr/share/monit-mysql/lua/?.lua
