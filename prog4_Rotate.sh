#!/bin/bash

for t in `cat ./list.txt`
do 
cd $t

for zfile in sac_cor/*Z.SAC
do
  nfile=sac_cor/`basename ${zfile} Z.SAC`N.SAC
  efile=sac_cor/`basename ${zfile} Z.SAC`E.SAC

  rfile=sac_cor/`basename ${zfile} Z.SAC`R.SAC
  tfile=sac_cor/`basename ${zfile} Z.SAC`T.SAC

  test -f ${zfile} && test -f ${nfile} && test -f ${efile} || continue

  sac 1>/dev/null << EOF
  cut a -20 a 300
  r ${zfile} ${nfile} ${efile}
  w over
  cut off

  r ${zfile} ${nfile} ${efile}
  sync
  w over

  r ${nfile} ${efile}
  rotate to gcp
  w ${rfile} ${tfile}
  q
EOF

  #break #zfile
done
cd ..
done 
