#!/bin/bash

RemInst() {
sfile=$1
fmin=$2
SouDir=$3    #SouDir="sac"
Resp=$4      #Resp="resp"
DesDir=$5    #DesDir="sac_cor"

test -d ${DesDir} || mkdir ${DesDir}

Net=`saclst knetwk f ${SouDir}/${sfile} | awk '{print $2}'`
Stn=`saclst kstnm f ${SouDir}/${sfile} | awk '{print $2}'`
Loc=`saclst khole f ${SouDir}/${sfile} | awk '{print $2}'`
Chn=`saclst kcmpnm f ${SouDir}/${sfile} | awk '{print $2}'`

rfile=RESP.${Net}.${Stn}.${Loc}.${Chn}  # response file format

#DELTA=`saclhdr -DELTA $i`

#f4=`echo $DELTA | awk '{print 1.0/($1 * 4.0)}'`
#f3=`echo $DELTA | awk '{print 1.0/($1 * 8.0)}'`
#f2=0.01
#f1=0.005

dt=`saclst delta f ${SouDir}/${sfile} | awk '{print $2}'`
sr=`echo ${dt} | awk '{print 1/$1}'`

f4=`echo ${sr} | awk '{print $1*0.45}'`
f3=`echo ${f4} | awk '{print $1*0.5}'`
f2=${fmin}
f1=`echo ${f2} | awk '{print $1*0.5}'`

sac 1>/dev/null << EOF
r ${SouDir}/${sfile}
rmean
rtr
taper

transfer from evalresp fname ${Resp}/${rfile} to vel freqlimit ${f1} ${f2} ${f3} ${f4}
div 1000000000


rmean
rtr
taper

w ${DesDir}/${Net}.${Stn}.${Loc}.${Chn}.SAC
q
EOF

}

#div 1.0E+9

####################################################################################################

SouDir="sac"       # Source Directory
Resp="resp"        # Response file Directory
DesDir="sac_cor"   # Destination Directory

fmin=0.2

for l in `cat ./list.txt`
do 
cd $l
for sfile in ${SouDir}/*SAC
do
  sfile=`basename ${sfile}`
  RemInst ${sfile} ${fmin} ${SouDir} ${Resp} ${DesDir}
done
cd ..
done
