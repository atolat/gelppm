#!/bin/bash
#heroku apps>applist.txt
declare -a serverlist=($(cat applist.txt))
for app in "${serverlist[@]}"
do
	heroku logs --app ${app}>>${app}log.txt
done
