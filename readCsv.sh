#!/bin/bash
filename=$1

IFS=";"

sed '1d' $filename | while read Email DoB Groups Sfolder
do echo "Email" $Email
	email=$(echo $Email | cut -d '@' -f1)
	echo $email
	firstval=$(echo $email | cut -d '.' -f1)
	firstletter=${firstval:0:1}
	secondval=$(echo $email | cut -d '.' -f2)
	username=$(echo "$firstletter""$secondval")
	echo "Username" $username
   echo "DoB" $DoB
   	year=$(echo $DoB | cut -d '/' -f1)
	month=$(echo $DoB | cut -d '/' -f2)
	password=$(echo "$month""$year")
	echo $password
   echo "Groups" $Groups
   echo "Sfolder" $Sfolder

   if [ $Groups = "staff" ]
   then
	 sudo useradd -g staff $username
	 sudo passwd $username
	 echo $password
	elif [ $Groups = "sudo" ]
	then
		sudo useradd -g sudo $username
		sudo passwd $username
		echo $password
	elif [ $Groups = "visitor" ]
	then
		sudo useradd -g visitor $username
		sudo passwd $username
		echo $password
	elif [ $Groups = "sudo, visitor" ]
	then
		sudo useradd -G sudo,visitor $username
		sudo passwd $username
		echo $password
	elif [ $Groups = "sudo, staff" ]
	then
		sudo useradd -G sudo,staff $username
		sudo passwd $username
		echo $password
	elif [ $Groups =" " ]
	then
		sudo useradd $username
		sudo passwd $username
		echo $password


fi
 
done < $filename
