#/bin/bash
filename=$1

IFS=";"
while read Email DoB Groups Sfolder
do echo "Email" $Email
   echo "DoB" $DoB
   echo "Groups" $Groups
   echo "Sfolder" $Sfolder

done < $filename
