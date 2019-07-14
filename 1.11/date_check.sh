#!/usr/bin/env bash

day=$(LANG=en_us_88591; /bin/date +%A)
group_list="$(/usr/bin/groups $PAM_USER)"
cur_date="$(/bin/date +%m/%d)"

if [ "$day" == "Sunday" ] || [ "$day" == "Saturday" ]
then
	if [[ ! "$group_list" =~ (.*[[:space:]]|^)"admin"([[:space:]].*|$) ]]
	then
		exit 1	
	fi
fi

for pr in '01/01' '06/12'
do
	if [ "$pr" ==  "$cur_date" ]
	then
		if [[ ! "$group_list" =~ (.*[[:space:]]|^)"admin"([[:space:]].*|$) ]]
		then
			exit 1	
		fi
	else
		continue
	fi
done

exit 0
