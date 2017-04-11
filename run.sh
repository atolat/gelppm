#!/bin/bash
HEROKU_PID=$(pidof -s heroku)

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
			chmod 755 ${varname}.sh
			./${varname}.sh
			echo "${varname}">>createdservers.txt
	done
fi
				
