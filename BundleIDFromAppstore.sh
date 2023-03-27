#!/usr/bin/env bash
export TERM=linux
##cosmetic functions and Variables
##Colors
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'

##Break function for readabillity
BR()
{
  echo "  "
}

##DoubleBreak function for readabillity
DBR()
{
  echo " "
  echo " "
}

##Variables
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"        # Homedir
baseUrl="https://itunes.apple.com/lookup?id="
downloadPath="$DIR/download.txt"
bundleLinePath="$DIR/bl.txt"

exitProcedure()
{
  exit 1
}

helpFunction()
{
   echo ""
   echo "Usage: -u put here the apple appStore Url"
   echo -e "\t-u apple appStore Url -- REQUIRED"
    exitProcedure # Exit script after printing help
}

while getopts "u:" opt
do
   case "$opt" in
      u ) urlArg="$OPTARG" ;;           # HPMC version argument
      ? ) helpFunction ;;                   # Print helpFunction in case parameter is non-existent
      h ) helpFunction ;;                   # Print helpFunction in case parameter is non-existent
   esac
done

if [[ -z $urlArg ]]
  then
  helpFunction
fi

extractBunldeID()
{
  idFromUrl=$(sed 's/^.*\(id.*\).*$/\1/' <<< $urlArg)
  ID="${idFromUrl:2}"
  fullUrl=$baseUrl$ID


  curl $fullUrl > $downloadPath
  # grep --color "bundleId" $downloadPath
  bundleLine=$(grep "bundleId" $downloadPath)
  echo $bundleLine > $bundleLinePath
  sed 's/^.*\(bundleId.*version\).*$/\1/' $bundleLinePath


  rm $downloadPath
  rm $bundleLinePath
}

extractBunldeID
