#!/bin/bash

if [ -d GENIESupport ]; then
  ls
  rm -rf GENIESupport
fi
git clone https://github.com/GENIEMC/GENIESupport.git
pushd GENIESupport
OUT=$( ./test_builds.sh | tee support_log.txt ; exit ${PIPESTATUS[0]} );
if [[ $? == 0 ]]; then
  echo "Success"
else
  cat support_log.txt
  exit 1
fi
popd
