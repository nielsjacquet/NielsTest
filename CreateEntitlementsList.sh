#!/usr/bin/env bash

##cosmetic functions and Variables

##Colors
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m'
BLUE='\033[0;34m'

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


entitlementsFolder="/Users/UCB/Downloads/EntitlementsExport"
testentitlement="/Users/UCB/Downloads/EntitlementsExport"
exportfile="/Users/UCB/Downloads/EntitlementsExport/export/export.txt"
# cd "$testentitlement"
# ls

for entitlements in "$entitlementsFolder"/*
do
  echo $entitlements
  keychain=$(grep com.ucbpharma.access $entitlements)
  printf "${GREEN}$keychain${NC}\n"
  echo $keychain >> "$exportfile"
done
