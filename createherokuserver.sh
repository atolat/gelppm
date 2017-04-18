#!/bin/bash
HEROKU_PID=$(pidof -s heroku)
awk '$1=$1' FS=',' OFS='\n' ServerList.txt>claritystate.txt

#Check for new approval
grep -vxFf shellstate.txt claritystate.txt>difference.txt

#Create array of new approvals
declare -a scripts=($(cat difference.txt))

if [ "${HEROKU_PID}" ]
then
	echo "Process Running..."
else
#Make executable, invoke new scripts, update created servers list
	for varname in "${scripts[@]}"
	do
            touch ${varname}.txt
            chmod 777 ${varname}.txt
            echo ${varname}>${varname}.txt
            SERVER_NAME=$(cut -d"|" -f1 ${varname}.txt)
            REGION_NAME=$(cut -d"|" -f2 ${varname}.txt)
            heroku create ${SERVER_NAME}>./${SERVER_NAME}log.txt 2>&1
            echo "creating server ${SERVER_NAME} hosted in ${REGION_NAME}..."
            #git remote add <name> <url>
            #git push heroku master
            echo "heroku create ${SERVER_NAME}">${SERVER_NAME}.sh
            chmod 755 ${SERVER_NAME}.sh
			echo "${SERVER_NAME}|${REGION_NAME}">>shellstate.txt
            heroku info --shell --app ${SERVER_NAME}>${SERVER_NAME}info.txt
            awk '$1=$1' FS='=' OFS='\n' ${SERVER_NAME}info.txt>${SERVER_NAME}newlineinfo.txt
            paste -d, -s ${SERVER_NAME}newlineinfo.txt>${SERVER_NAME}commainfo.csv
	done
fi

#awk '$1=$1' FS=',' OFS='\n' ./shellstate.txt>>shellstate.txt

