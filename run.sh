#!/bin/bash
HEROKU_PID=$(pidof -s heroku)
awk '$1=$1' FS=',' OFS='\n' ./ServerList.txt>>newlist.txt

#Check for new approval
grep -vxFf createdservers.txt newlist.txt>difference.txt

#Create array of new approvals
declare -a scripts=($(cat difference.txt))

if [ "${HEROKU_PID}" ]
then
	echo "Process Running..."
else
#Make executable, invoke new scripts, update created servers list
	for varname in "${scripts[@]}"
	do
            heroku create ${varname}>./${varname}log.txt
            #git remote <name><url>
            #git push heroku master
            echo "heroku create ${varname}">${varname}.sh
            chmod 755 ${varname}.sh
			./${varname}.sh
			echo "${varname}">>createdservers.txt
	done
fi
				
