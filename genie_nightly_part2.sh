#!/bin/bash
if [ -d lamp ]; then
  ls
  rm -rf lamp
fi
git clone https://github.com/GENIEMC/lamp.git
pushd lamp
OUT=$( ./rub_the_lamp.sh -s -t trunk --support-tag HEAD | tee lamp_log.txt ; exit ${PIPESTATUS[0]} );
if [[ $? == 0 ]]; then
  echo "Success"
else
  cat lamp_log.txt
  exit 1
fi
popd
