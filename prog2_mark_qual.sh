#!/bin/bash

for sfile in `cat ./list.txt`
do

saclst kstnm f ./${sfile}/sac/*Z.?.SAC | awk '{print $2}' | sort -u > station.txt


test -d ./${sfile}/sac/trash || mkdir ./${sfile}/sac/trash

for Stn in `cat station.txt`
do
  gsac 1>/dev/null 2>/dev/null << EOF
  r ./${sfile}/sac/*${Stn}*SAC
  ppk absolute markall
  wh
  q
EOF

  echo "Data qual [1 for good: 0 for bad]"
  read flag

  test ${flag} -eq 0 && mv ./${sfile}/sac/*${Stn}*SAC ./${sfile}/sac/trash

  #break #Stn
done
done
