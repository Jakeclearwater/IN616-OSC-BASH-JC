#!/bin/bash

filename=$1
if [[$filename == http* ]]; #checks for http file
then
	wget -gO users.csv $filename
fi
sudo touch logfile.log
#logging is not quite working properly

sharedFolders(){ #creates shared folders
	sudo groupadd visitor
	sudo groupadd staff

	sudo mkdir /home/sharedFolders
	sudo mkdir /home/sharedFolders/staffData >> logfile.log
	sudo mkdir /home/sharedFolders/visitorData >> logfile.log

	sudo chgrp staff /home/sharedFolders/staffData
	sudo chgrp visitor /home/sharedFolders/visitorData
	sudo chmod g-rwx /home/sharedFolders/staffData
	sudo chmod g-rwx /home/sharedFolders/visitorData
}

createUsers() { #creates Users

	IFS=";"
        index=0
	#removes headers before reading
        while read Email DoB Groups Sfolder
	do
	if [ $index -gt  0 ] #Skips first line of csv file
	then
	echo "User successfully created" >> logfile.log
	   echo "email:" $Email  >> logfile.log
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
	   echo "password:" $password  >> logfile.log
	   echo "Username:"  $username  >> logfile.log
	   echo "DoB:" $DoB  >> logfile.log
	   echo "Groups:" $Groups  >> logfile.log
	   echo "Sharedfolder:" $Sfolder  >> logfile.log
#creates users
	   sudo useradd -d /home/${username} -m -s /bin/bash $username >> logfile.log
#sets password
	   echo $username:$password |sudo chpasswd
#sets passwords to change on first login
	   sudo chage --lastday 0 ${username}

	   if [ -z "$Groups" ];
	   then
			   echo "User Has no Assigned Group/s" >> logfile.log
	   else
			   sudo usermod -aG $Groups $username
	   fi
	#creates aliases and then saves to file
	   if grep -q "sudo" <<< "$Groups";
	   then
		   alias myls="ls -la"
		   sudo touch ~/.bash_aliases
		   echo alias myls="ls -la" >> ~/.bash_aliases
	   fi
#creates soft links for groups
	   if grep -q "staffData" <<< "$Sfolder";
	   then
		   sudo ln -s /home/$username/sharedFolders/staffData /home/$username/shared
	   elif grep -q "visitorData" <<< "$Sfolder";
	   then
		   sudo ln -s /home/$username/sharedFolders/visitordata /home/$username/shared
	   fi
	   echo "----------------------------------------"

	fi
	(( index++ ))

done < $filename
echo "Total Users: $index" >> logfile.log
}

sharedFolders
createUsers
#delete stuff for testing purposes
deleteFolders() {
	sudo rm -r /home/sharedFolders/staffData
	sudo rm -r /home/sharedFolders/visitorData
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
