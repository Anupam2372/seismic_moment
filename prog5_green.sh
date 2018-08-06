#!/bin/bash

Mod="CUS.mod"
dt=0.25
npts=256
T0=-10    # origin time
VRED=0    # reduction velocity

test -d green || mkdir green
cd green
rm -f *

for zfile in ../sac_cor/*Z.SAC
do
  read Stn Dist hDep <<< `saclst kstnm dist evdp f ${zfile} | awk '{print $2,$3,$4}'`
  echo ${Dist} ${dt} ${npts} ${T0} ${VRED} > dfile

  hprep96 -M ../Model/${Mod} -d dfile -HS ${hDep} -HR 0 -EQEX     #input: model, dfile; output: hspec96.dat
  hspec96 > hspec96.out                                           #input: hspec96.dat; output: hspec96.grn, hspec96.out
  hpulse96 -V -t -l 2 > f96.dat                                   #input: hspec96.grn; output: f96.dat
  f96tosac -B -T f96.dat                                          #input: f96.dat; output: binary sac files
                                                                  
  for grn in ZDD ZDS ZSS ZEX RDD RDS RSS REX TDS TSS
  do
    mv ??????????.${grn} ${Stn}.${grn}
  done
  rm dfile f96.dat hspec96.dat hspec96.grn hspec96.out
  #break #zfile
done
