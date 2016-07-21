#!/bin/sh

# env_file ($1) is so that you can source this file in current shell.  I've an alias to call this and source the environment:
# alias docker_start='docker_start.sh /tmp/docker.env && source /tmp/docker.env'

if [ -n $1 ]; then
	env_file=$1
else
	env_file=/tmp/docker.env
fi

echo env_file: $env_file

'/Applications/Docker/Docker Quickstart Terminal.app/Contents/Resources/Scripts/start.sh'
docker-machine env default > $env_file

