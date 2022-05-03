#!/bin/bash

filename=$1

sharedFolders(){
	sudo groupadd visitor
	sudo groupadd staff

	sudo mkdir /sharedFolders
	sudo mkdir /sharedFolders/staffData
	sudo mkdir /sharedFolders/visitorData

	sudo chgrp staff /sharedFolders/staffData
	sudo chgrp visitor /sharedFolders/visitorData
	sudo chmod g-rwx /sharedFolders/staffData
	sudo chmod g-rwx /sharedFolders/visitorData
}

createUsers() {

	IFS=";"
	#removes headers before reading
	sed 1d $filename | while read col1 col2 col3 col4
	do
	   Email=$($col1)
	   DoB=$($col2)
	   Groups=$($col3)
	   Sfolder=$($col4)
	   echo "email:" $email
	   #create username from email
	   email=$(echo $Email | cut -d '@' -f1)
	   val=$(echo $email | cut -d '.' -f1)
	   second=$(echo $email | cut -d '.' -f2)
	   firstVal=${email:0:1}
	   username=$(echo "$firstVal""$second")
	   #create password from DoB
	   month=$(echo $DoB | cut -d '/' -f2)
	   year=$(echo $DoB | cut -d '/' -f1)
	   password=$(echo "$month""$year")
	   #create users and groups
	   echo "password:" $password
	   echo "Username:"  $username
	   echo "DoB:" $DoB
	   echo "Groups:" $Groups
	   echo "Sharedfolder:" $Sfolder
	   echo "----------------------------------------"

	   sudo useradd -d /home/${username} -m -s /bin/bash $username

	   echo $username:$password |sudo chpasswd

	   sudo chage --lastday 0 ${username}

	   if [ -z "$Groups" ];
	   then
			   echo "Groups is Empty"
	   else
			   sudo usermod -aG $Groups $username
	   fi

}

done < $filename
