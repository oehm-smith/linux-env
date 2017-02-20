#!/usr/bin/env bash

# From https://medium.com/@rdsubhas/docker-for-development-common-problems-and-solutions-95b25cae41eb#.iznvwzfaq
# Here is a docker-clean command that removes all untagged images and stopped containers. Periodically run this to keep the VM clean.

docker ps -aqf status=exited | xargs docker rm
docker images -qf dangling=true | xargs docker rmi
