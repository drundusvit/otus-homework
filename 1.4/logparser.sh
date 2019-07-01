#!/usr/bin/env bash

#принимает файл в качестве единственного параметра

stats() {
	if [ -f "$1" ]
	then
		sort -k 4 -o "$1" "$1"
		echo -e "Statistics for the period from $(get_date $(head -n1 $1)) to $(get_date $(tail -n1 $1)):\n \"
		Source ip stats:\n\
		$(awk '{print $1}' $1 | sort | uniq -c | sort -nr | head)\n\
		Responce stats:\n\
		$(awk '{print $9}' $1 | sort | uniq -c | sort -nr | head)\n\
		Destination URL:\n\
		$(awk '{print $7}' $1 | sort | uniq -c | sort -nr | head)" | mail -s 'nginx statistics' damdamka@gmail.com
	else
		echo "No requests received" | mail -s 'nginx statistics' damdamka@gmail.com
	fi
	echo "Stats were sent"
}

get_date() {
	local newline=("$@")
	local new="${newline[*]}"
    ch_date="$(echo "$new" | sed 's/.*\[\(.*\).*\].*/\1/ ; s/\//\ /g ; s/\:/\ /')"
    #date -d "$ch_date" "+%s"
    echo $ch_date

}

convert_date(){
	local newline=("$@")
	local new="${newline[*]}"
	date -d "$new" "+%s"
}



FILE=./analyzer.log
if [ -f "$FILE" ]; then
	last_date=$(tail -n1 "$FILE")
	echo "Analyzer file exists"
else
	last_date=$(date -R -d '-1hour')
	echo "Analyzer file doesn't exist"
fi
echo "Last execution of script was at $last_date"
norm=$(LANG=en_us_88591; date -d"$last_date" +%d\/%B); 
plusone=$(LANG=en_us_88591; date  -d"$last_date +1hour" +%d\/%B); 
grep -e "$norm" -e "$plusone" $1 > /tmp/pre_script
cur_date=$(date -R)
conv_cur_date=$(convert_date $cur_date)
last_date=$(convert_date $last_date)

if [ -f /tmp/pre_script ]
then

	IFS=$'\n'
	for line in $(cat /tmp/pre_script)

	do
		temp_date=$(get_date "$line")
		temp_conv=$(convert_date "$temp_date")
		if [ $conv_cur_date -gt $temp_conv ] && [ $last_date -lt $temp_conv ]
		then
			echo "$line" >> /tmp/script_temp
		fi
	done
	echo $cur_date >> ./analyzer.log
	stats /tmp/script_temp
	rm -rf /tmp/pre_script /tmp/script_temp

fi
