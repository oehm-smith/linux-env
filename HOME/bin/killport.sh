#!/bin/sh
# Kill the process running on the given port
echo kill process running on port: $1
sudo lsof -i tcp:$1

