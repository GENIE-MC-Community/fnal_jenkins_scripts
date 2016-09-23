#!/bin/bash

DATE=`date +%Y-%m-%d`

export GENIE=$PWD/$GENIE_VERSION
export XSECSPLINEDIR=$PWD/data

#export GUPSBASE=/grid/fermiapp 
#source $GUPSBASE/products/genie/externals/setup

# cvmfs is not visible?
#export GUPSBASE=/cvmfs/fermilab.opensciencegrid.org/
#source $GUPSBASE/products/genie/externals/setup

# use larsoft...
source /grid/fermiapp/products/genie/bootstrap_genie_ups.sh

setup root v5_34_25a -q debug:e7:nu
setup lhapdf v5_9_1b -q debug:e7
setup log4cpp v1_1_1b -q debug:e7

cd $GENIE_VERSION

./configure \
  --enable-test \
  --enable-numi \
  --enable-gsl \
  --enable-rwght \
  --enable-lhapdf \
  --with-optimiz-level=O3 \
  --with-pythia6-lib=$PYTHIA6_LIBRARY \
  --with-lhapdf-lib=$LHAPDF_FQ_DIR/lib \
  --with-lhapdf-inc=$LHAPDF_FQ_DIR/include \
  --with-log4cpp-lib=$LOG4CPP_FQ_DIR/lib \
  --with-log4cpp-inc=$LOG4CPP_FQ_DIR/include \
  --with-libxml2-lib=$LIBXML2_FQ_DIR/lib \
  --with-libxml2-inc=$LIBXML2_FQ_DIR/include/libxml2 1>configure.out 2>configure.err

make 1>make.out 2>make.err

# compile validation apps
pushd $GENIE/src
if [[ -d validation ]]; then
  rm -rf validation
fi
git clone https://github.com/GENIEMC/legacy_validation.git
mv legacy_validation validation
popd

dirs=( "EvScan" "Hadronization" "Intranuke" "MCx" "Merenyi" "NuXSec" "StructFunc" "eA" )

for dir in "${dirs[@]}"
do
  cd $GENIE'/src/validation/'$dir
  make
done

cd $GENIE

mkdir -p /scratch/workspace/jenkinsTest/genie_builds/

TAG=`basename $GENIE_VERSION`

tar -zcf /scratch/workspace/jenkinsTest/genie_builds/genie_$TAG'_buildmaster_'$DATE'.tgz' --exclude=".*" *
