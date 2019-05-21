#!/usr/bin/env bash
#написать свою реализацию ps ax используя анализ /proc
# ps ax
#   PID TTY      STAT   TIME COMMAND
file=$(find /proc -maxdepth 1 -type d -regex "/proc/[0-9]*" -exec basename \{} \;)
echo "PID\tTTY\tSTAT\tTIME\tCOMMAND"
for i in $file
do

	if [ ! -d /proc/$i/fd ];then echo "doesnt fd"; continue;fi
	if [ ! -f /proc/$i/stat ];then echo "doesnt stat"; continue;fi
	if [ ! -f /proc/$i/cmdline ];then echo "doesnt cmd"; continue;fi
	if [ ! -f /proc/$i/comm ];then echo "doesnt comm"; continue;fi
	tty_dec=$(awk '{print $7}' /proc/$i/stat)
	if (( tty_dec == 0 ))
	then
		tty="?"
	else
		binary=$(echo "obase=2;$tty_dec" | bc)
		while (( ${#binary} < 16 ))
		do
			binary="0"$binary
		done
		
		start=$(cut -c-8 <<< $binary)
		end=$(cut -c 9- <<< $binary)
		major=$(echo "$((2#$start))")
		if (( major == 4 ))
		then
			major="tty"
		elif (( major == 136 ))
		then
			major="pts/"
		fi
		minor=$(echo "$((2#$end))")
		tty="terminal $major$minor"

	fi

	state=$(awk '{print $3}' /proc/$i/stat)

	times=$(awk '{print $14+$15}' /proc/$i/stat)
	times_ch=$(( times / 100 ))
	if (( times < 100 ))
	then
		time_val="0:00"
	else
		sec=$(( times_ch % 60 ))
		if (( $sec < 10 ))
		then
			sec="0$sec"
		fi
		min=$(( times_ch / 60 ))
		time_val="$min:$sec"
	fi


	pid=$i
	cmdline=$(cat "/proc/$i/cmdline")
	if [[ -z $cmdline ]]
	then
		cmdline="["$(cat "/proc/$i/comm")"]"
	fi

	echo -e "$pid\t$major$minor\t$state\t$time_val\t$cmdline"
done
