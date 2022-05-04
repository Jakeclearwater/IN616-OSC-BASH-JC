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
        while read Email DoB Groups Sfolder
	do
	   echo "email:" $Email
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

	   sudo useradd -d /home/${username} -m -s /bin/bash $username

	   echo $username:$password |sudo chpasswd

	   sudo chage --lastday 0 ${username}

	   if [ -z "$Groups" ];
	   then
			   echo "User Has no Assigned Group/s"
	   else
			   sudo usermod -aG $Groups $username
	   fi
	   echo "----------------------------------------"

done < $filename
sudo userdel -r ee-mail
}

sharedFolders
createUsers

deleteFolders() {
	sudo rm -r /sharedFolders/staffData
	sudo rm -r /sharedFolders/visitorData
}

deleteUsers() {
	sudo userdel -r edijkstra
        sudo userdel -r jmccarthy
	sudo userdel -r atanenbaum
	sudo userdel -r aturing
	sudo userdel -r ltorvalds
	sudo userdel -r bstroustroup
	sudo userdel -r kthompson
	sudo userdel -r jgosling
	sudo userdel -r tberners-lee

}	

deleteAll() {
	deleteFolders
	deleteUsers
}
#deleteAll
