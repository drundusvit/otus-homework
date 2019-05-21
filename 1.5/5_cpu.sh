#!/usr/bin/env bash

echo "starting with 19 at $(date) "; time nice -19 dd if=/dev/urandom of=/dev/null bs=1024 count=4000001 &
echo "starting with -20 at $(date) "; time nice --20 dd if=/dev/urandom of=/dev/null bs=1024 count=4000000 &
wait $(jobs -p)
