#!/bin/bash
HEROKU_PID=$(pidof -s heroku)
awk '$1=$1' FS=',' OFS='\n' ./ServerList.txt>>calritystate.txt

#Check for new approval
grep -vxFf shellstate.txt gelstate.txt>difference.txt

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
            #git remote add <name> <url>
            #git push heroku master
            echo "heroku create ${varname}">${varname}.sh
            chmod 755 ${varname}.sh
			echo "${varname}">>shellstate.txt
            heroku info --shell ${varname}>${varname}info.txt
            awk '$1=$1' FS='=' OFS='\n' ${varname}info.txt>${varname}info.txt
            paste -d, -s ${varname}info.txt>${varname}info.csv
	done
fi

awk '$1=$1' FS=',' OFS='\n' ./shellstate.txt>>.txt
