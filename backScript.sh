#!/bin/bash

filename=$1
#enter in infomation for backup
echo "Enter complete route of file/dir you want to backup:"
read filename
echo "Enter name for backup:"
read backupName
clear

echo "Enter Username:"
read username
echo "Enter target address:"
read tAddress
echo "Enter target dir, For example = /home/bitstudent/:"
read tDir
echo "Enter Port Number:"
read portNumber
clear
#displays infomation to users
echo "You have entered the infomation below:"
echo $username
echo $tAddress
echo $tDir
echo $portnumber
echo $filename
echo $backupName
echo "Is this correct (y) or (n)? (case sensitive)"
read confirm
#begins backup
if grep -q "y" <<< "$confirm";
then
	clear
	echo "Beginning Backup..."
#creates backup file
	tar -cvf /tmp/$backupName.tar.gz -C $filename . 2> /dev/null

	if [[ $? == 0 ]]
	then
		echo ">> Backup archive file was successfully created"
	else
		echo ">> Backup file failed. exiting..."
		exit 1
	fi
#sends backup to folder added
        scp -P $portNumber /tmp/$filename.tar.gz $username"@"$tAddress":"$tDir
	if [[ $? == 0 ]]
	then
		echo ">> Backup successfully inserted into $tDir"
	else
		echo ">> Backup failed to insert into $tDir"
		exit 1
	fi
else
	echo "Confirmed as not correct, exiting program"
	exit 1
fi

echo "Backup completed successfully"
