#!/bin/bash

filename=$1
IFS=";"

sudo groupadd visitor
sudo groupadd staff

sudo mkdir -p /sharedFolders
sudo mkdir -p /sharedFolders/staffdata
sudo mkdir -p /sharedFolders/visitordata

sed 1d $filename | while read email DoB Groups Sfolder
do
   echo "======================================"
   echo "email:" $email
   #creating username from email
   email=$(echo $email | cut -d '@' -f1)
   val=$(echo $email | cut -d '.' -f1)
   second=$(echo $email | cut -d '.' -f2)
   firstletter=${email:0:1}
   username=$(echo "$firstletter""$second")
   #creating password from Date of Birth
   passval=$(echo $DoB | cut -d '/' -f2)
   passval2=$(echo $DoB | cut -d '/' -f1)
   password=$(echo "$passval""$passval2")
   #creating users and groups
   echo "password:" "**"$passval2
   echo "Username:"  $username
   echo "DoB:" $DoB
   echo "Groups:" $Groups
   echo "Sfolder:" $Sfolder
   echo "======================================"

   sudo useradd -d /home/${username} -m -s /bin/bash $username

   sudo passwd $username

   echo $username:$password |sudo chpasswd



   sudo chage --lastday 0 ${username}

   if [ -z "$Groups" ];
   then
           echo "Empty"
   else
           sudo usermod -aG $Groups $username
   fi



done < $filename
