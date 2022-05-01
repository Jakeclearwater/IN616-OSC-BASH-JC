#/bin/bash
file=$1

IFS=","

while read col1
do
	echo "Col 1 val: $col1"
done < $file

