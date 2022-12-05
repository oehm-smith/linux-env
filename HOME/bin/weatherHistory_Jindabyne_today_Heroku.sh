#!/bin/sh
LOC=Jindabyne,NSW
if [ -z $1 ]; then
	curl https://weatherhistory-heroku-try2.herokuapp.com/weather?format=cfl\&location=$LOC
else
	# Eg. 'date=2021-05-08'`:
	curl https://weatherhistory-heroku-try2.herokuapp.com/weather?format=cfl\&location=$LOC\&$1
fi
# curl http://localhost:8090/weather?format=cfl\&location=Canberra,ACT

