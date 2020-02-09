#!/bin/bash -e

lambdaName=$1

distFolder=$lambdaName/.dist
versionFile=$lambdaName/version
mkdir -p $distFolder

rm -rf $distFolder/*

version=$(cat $versionFile)
filename=$lambdaName-${version}.zip

if [ ! -f $distFolder/$filename ]; then
  echo -n $filename > $distFolder/meta

  cd $lambdaName/src
  zip -r -q ../.dist/$filename .
else
  echo 'lambda $filename already packaged - skipping'
fi