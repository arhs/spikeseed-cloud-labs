#!/bin/bash -e

lambdaName=$1

distFolder=$lambdaName/.dist
versionFile=$lambdaName/version
codeFolder=$distFolder/python/$lambdaName
mkdir -p $codeFolder

rm -rf $codeFolder/*

version=$(cat $versionFile)
filename=$lambdaName-${version}.zip

if [ ! -f $distFolder/$filename ]; then
  echo -n $filename > $distFolder/meta

  cp $lambdaName/src/* $distFolder/python/$lambdaName
  cd $lambdaName/.dist
  zip -r -q $filename python
else
  echo 'lambda $filename already packaged - skipping'
fi