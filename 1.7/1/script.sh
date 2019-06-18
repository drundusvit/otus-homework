#!/usr/bin/env bash

log_date=$(awk -v word="$1" '{if ($0 ~ word) a=$3} END {print a}' $2)
if [ -z "$log_date" ]; then exit 0; fi
last_change=$(date +%s -d "$log_date")
now=$(date +%s)
let deduct=now-30
if [ $deduct -lt $last_change ]
then
	echo "Someone messed with $1"
fi