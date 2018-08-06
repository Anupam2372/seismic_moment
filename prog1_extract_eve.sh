#!/bin/bash

cd ./2013_seed
for i in `ls -l | awk '{print $9}'`          
do
echo "$i">> ../list.txt
done


for seedfile in `cat ../list.txt`
do

cd /home/anupam/Desktop/2013

mkdir `echo ${seedfile}`
cd `echo ${seedfile}`


fseed="/home/anupam/Desktop/2013/2013_seed/${seedfile}"

test -d resp || mkdir resp
test -d sac || mkdir sac
rm -f resp/*
rm -f sac/*

rdseed -f ${fseed} -R -q resp 1>/dev/null 2>/dev/null
rdseed -f ${fseed} -d -o 1 -q sac 1>/dev/null 2>/dev/null

done
