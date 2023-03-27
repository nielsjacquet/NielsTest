#!/usr/bin/env bash

##cosmetic functions and Variables

##Colors
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'

##Break function for readabillity
function BR {
  echo "  "
}

##DoubleBreak function for readabillity
function DBR {
  echo " "
  echo " "
}

helpFunction()
{
  echo ""
  echo "Usage: $0 -s studyName -f format -d yes -a yes -p yes"
  echo -e "\t-s studyName -- REQUIRED "
  echo -e "\t-f format -- study or test -- REQUIRED "
  echo -e "\t-d DEV -- yes  "
  echo -e "\t-a ACC -- yes  "
  echo -e "\t-p PRD -- yes  "
  exitProcedure # Exit script after printing help
}

exitProcedure()
{
  exit 1
}

while getopts "s:?:h:f:d:a:p:" opt
do
   case "$opt" in
      s ) studyName="$OPTARG" ;;         # Studyname argument
      f ) formatArg="$OPTARG" ;;            # format file
      d ) devArg="$OPTARG" ;;               # DEV needed arg
      a ) accArg="$OPTARG" ;;               # ACC needed arg
      p ) prdArg="$OPTARG" ;;               # PRD needed arg
      ? ) helpFunction ;;                   # Print helpFunction in case parameter is non-existent
      h ) helpFunction ;;                   # Print helpFunction in case parameter is non-existent
   esac
done

##Variables
homeDir="/Users/nielsjacquet/Documents/UCB/Studies"
originalsFolder="$homeDir/_Originals"
ogPSDName="OriginalBackGrounds.psd"
ogPSD="$originalsFolder/$ogPSDName"
newPSDName="$studyName""_BackGrounds.psd"
ogVectorName="Vector.ai"
ogVector="$originalsFolder/$ogVectorName"
newVectorName="$studyName""_Vector.ai"

if [[ -z $studyName ]]
 then
  helpFunction
fi

if [[ -z $formatArg ]]
 then
  helpFunction
fi

case $formatArg in
  study )
    createFoldersIn="$homeDir/Studies"
    echo $createFoldersIn
    ;;
  test )
    createFoldersIn="$homeDir/TestProfiles"
    echo $createFoldersIn
    ;;
esac

#concat the Variables
studyFolder="$createFoldersIn/$studyName"

makeDirsfuction()
{
  cd "$createFoldersIn"
  mkdir "$studyName"

  cd "$createFoldersIn/$studyName"
  mkdir "$studyName""_AppConfigurationPolicies"
  mkdir "$studyName""_DeviceConfigurationProfiles"
  mkdir "$studyName""_BackGrounds"

  ACPFolder="$studyFolder/$studyName""_AppConfigurationPolicies"
  DCPFolder="$studyFolder/$studyName""_DeviceConfigurationProfiles"
  backgroundFolder="$studyFolder/$studyName""_BackGrounds"
  namingConvention="$studyFolder/"$studyName"_naming.txt"

  cp -v -p -R "$ogPSD" "$backgroundFolder/$newPSDName"
  cp -v -p -R "$ogVector" "$backgroundFolder/$newVectorName"

##DEV
  if [[ $devArg = yes ]]
    then
      ##DCP
        cd "$DCPFolder"
        DCPDEVFolder="$studyName""_DCP_DEV"
        mkdir $DCPDEVFolder
        DCPDEVName="$studyName"_DEV_SecurityRestrictions.csv
        cp -v "$originalsFolder/DCPOriginals/SecurityRestrictionsProfile_DEV.csv" "$DCPDEVFolder/$DCPDEVName"
      #ACP
        cp -v "$originalsFolder/4meAppconfigs/DEV_4meAppconfig.xml" "$ACPFolder/"$studyName"_DEV_4meAppconfig.xml"
  fi

##ACC
  if [[ $accArg = yes ]]
    then
      ##DCP
        cd "$DCPFolder"
        DCPACCFolder="$studyName""_DCP_ACC"
        mkdir $DCPACCFolder
        DCPACCName="$studyName"_ACC_SecurityRestrictions.csv
        cp -v "$originalsFolder/DCPOriginals/SecurityRestrictionsProfile_ACC.csv" "$DCPACCFolder/$DCPACCName"
      #ACP
        cp -v "$originalsFolder/4meAppconfigs/ACC_4meAppconfig.xml" "$ACPFolder/"$studyName"_ACC_4meAppconfig.xml"
  fi

##PRD
  if [[ $prdArg = yes ]]
    then
      ##DCP
        cd "$DCPFolder"
        DCPPRDFolder="$studyName""_DCP_PRD"
        mkdir $DCPPRDFolder
        DCPPRDName="$studyName"_PRD_SecurityRestrictions.csv
        cp -v "$originalsFolder/DCPOriginals/SecurityRestrictionsProfile_PRD.csv" "$DCPPRDFolder/$DCPPRDName"
      #ACP
        cp -v "$originalsFolder/4meAppconfigs/ACC_4meAppconfig.xml" "$ACPFolder/"$studyName"_PRD_4meAppconfig.xml"
          if [[ $formatArg = study ]]
          then
            ##URS and Devicesfolder
            cd "$createFoldersIn/$studyName"
            mkdir "$studyName""_Devices"
            mkdir "$studyName""_URS"
            ursFolder="$studyFolder/$studyName""_URS"
            cp -v "$originalsFolder/IPAT_StudySpecific_URS-Template.docx" "$ursFolder/"$studyName"_StudySpecific_URS.docx"
          fi
  fi
}

printNamingConvention()
{
  echo Enrollment profile name: >> $namingConvention
  echo $studyName >> $namingConvention
  echo ------------------------------ >> $namingConvention
  echo DeviceName: >>$namingConvention
    if [[ $devArg = yes ]]; then
      echo $studyName"_DEV"-{{SERIAL}} >>$namingConvention
    fi
    if [[ $accArg = yes ]]; then
      echo $studyName"_ACC"-{{SERIAL}} >>$namingConvention
    fi
  echo ------------------------------ >> $namingConvention
  echo Department: UCB IT >> $namingConvention
  echo Department Phone:+3222007560 >> $namingConvention
  echo ------------------------------ >> $namingConvention
  echo Group name: >> $namingConvention
    if [[ $devArg = yes ]]; then
      echo Intune-UCB-IPAT-DEV-$studyName >> $namingConvention
    fi
    if [[ $accArg = yes ]]; then
      echo Intune-UCB-IPAT-ACC-$studyName >> $namingConvention
    fi
    if [[ $prdArg = yes ]]; then
      echo Intune-UCB-IPAT-PRD-$studyName >> $namingConvention
    fi
  echo ------------------------------ >> $namingConvention
  echo Lockscreen message: >> $namingConvention
    if [[ $devArg = yes ]]; then
      echo Serial Number: {{serialnumber}}, Study: $studyName"_DEV" >> $namingConvention
    fi
    if [[ $accArg = yes ]]; then
        echo Serial Number: {{serialnumber}}, Study: $studyName"_ACC" >> $namingConvention
    fi
    if [[ $prdArg = yes ]]; then
      echo Serial Number: {{serialnumber}}, Study: $studyName >> $namingConvention
    fi
  echo ------------------------------ >> $namingConvention
  echo ------------------------------ >> $namingConvention
  echo Source documents: >> $namingConvention
  echo Binder: >> $namingConvention
  echo URS: >> $namingConvention
  echo SecurityRestrictions: >> $namingConvention
  echo PasscodeRestrictions: >> $namingConvention
  echo Lockscreen image: >> $namingConvention
  echo Backgound image: >> $namingConvention
  echo SafariWhitelistProfile: >> $namingConvention
  echo AppConfigurationPolicies: >> $namingConvention
}

checkStudy() {
  if [[ -d "$studyFolder" ]]
   then
    printf "${RED}Studyname is already taken!\n"
    printf "Exiting the script.\n${NC}"
    helpFunction
  else
    printf "${GREEN}This is a new study!\n"
    printf "Let me create and copy the needed files and folders.\n${NC}"
    makeDirsfuction
    printNamingConvention
  fi
}
checkStudy
