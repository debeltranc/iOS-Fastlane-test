#!/bin/bash

#UTF-8 is required by Fastlane
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

#Disable colors so it's easier to process strings! (if needed)
export FASTLANE_DISABLE_COLORS=1

#Output colors
export NO_COL='\033[0m'
export BLACK='\033[0;30m'
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export ORANGE='\033[0;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export LIGHT_GRAY='\033[0;37m'
export DARK_GRAY='\033[1;30m'
export LIGHT_RED='\033[1;31m'
export LIGHT_GREEN='\033[1;32m'
export YELLOW='\033[1;31m'
export LIGHT_BLUE='\033[1;31m'
export LIGHT_PURPLE='\033[1;31m'
export LIGHT_CYAN='\033[1;31m'
export WHITE='\033[1;31m'

#This variables can be shared across projects regardless of signing team
#This, of course, if your developer portal account belongs to all teams
export GIT_USERNAME="${1}"
export APPLE_USERNAME="${2}"
export FASTLANE_USER="${APPLE_USERNAME}"
read -s -p "Enter your iTunes Connect password: " FASTLANE_PASSWORD && echo
export GIT_URL="${3}"
read -s -p "Enter your Keychain password: " MATCH_KEYCHAIN_PASSWORD && echo
export MATCH_GIT_FULL_NAME="${4}"
export MATCH_GIT_USER_EMAIL="${5}"
read -s -p "Enter your Keychain password: " MATCH_PASSWORD && echo

#This function will run a lane called signAndArchive located in ./fastlane/Fastfile
function archive_application() {

  export LANE_NAME="signAndArchive"

  #Dirs
  export LOGS_DIR="build_logs"
  export IPAS_DIR="ipas/${TEAM_NAME}"
  export LANE_LOGS="${LOGS_DIR}/${TEAM_NAME}/${LANE_NAME}"

  mkdir -p "${LANE_LOGS}"
  mkdir -p "${IPAS_DIR}"

  for (( i=0; i<${#APPS[@]}; i++ ))
  do
    export APP="${APPS[$i]}"
    export IDENTIFIER="${IDENTIFIERS[$i]}"
    echo -e "${YELLOW}Running ${CYAN}${LANE_NAME}${YELLOW} lane for ${CYAN}$APP"
    bundle exec fastlane ios "${LANE_NAME}" giturl:"${GIT_URL}" gitbranch:"${GIT_BRANCH}" identifier:"${IDENTIFIER}" appleusername:"${APPLE_USERNAME}" teamid:"${APPLE_TEAM_ID}" signidentity:"${SIGNING_IDENTITY}" appscheme:"${APP}" ipasdir:"${IPAS_DIR}" --verbose > "./${LANE_LOGS}"
    export EXIT_STATUS=$?
    if [ $EXIT_STATUS -eq 0 ]
    then
      echo -e "${GREEN}Successfully built ${NO_COL}$APP ${GREEN}in ${LIGHT_GREEN}./${IPAS_DIR}/${APP}.ipa"
      echo "$(pwd)/${IPAS_DIR}/${APP}.ipa" >> "./${LOGS_DIR}/${TEAM_NAME}/successfull_builds.txt"
    else
      echo -e "${RED}Build failed for ${NO_COL}${APP}: ${RED}Exit code: ${NO_COL}${EXIT_STATUS}"
      echo "${APP}" >> "./${LOGS_DIR}/${TEAM_NAME}/failed_builds.txt"
    fi
  done
}

#All scheme names to be compiled with the first signing team
export APPS=(
deployment-tests
)
#Corresponding bundle identifiers
export IDENTIFIERS=(
com.debeltranc.deployment-tests
)
#First team info
export TEAM_NAME="Teamy McTeamFace"
export APPLE_TEAM_ID="T34MYID3NT"
export FASTLANE_TEAM_ID=${APPLE_TEAM_ID}
export SIGNING_IDENTITY="iPhone Distribution: ${TEAM_NAME} (${APPLE_TEAM_ID})"
export GIT_BRANCH="teamybranch" #other than master is preferred

echo -e "${YELLOW}Beginning with ${CYAN}${TEAM_NAME}${YELLOW} team apps build${NO_COL}"

archive_application

#All scheme names to be compiled with the first signing team
APPS=(
another-scheme
)
#Corresponding bundle identifiers
IDENTIFIERS=(
com.debeltranc.another-scheme
)
#Second team info
export TEAM_NAME="Other team"
export APPLE_TEAM_ID="4N0TH3RID3"
export FASTLANE_TEAM_ID="${APPLE_TEAM_ID}"
export SIGNING_IDENTITY="iPhone Distribution: ${TEAM_NAME} (${APPLE_TEAM_ID})"
export GIT_BRANCH="otherbranch" #other than master is preferred

echo -e "${YELLOW}Beginning with ${CYAN}${TEAM_NAME}${YELLOW} team apps build${NO_COL}"

archive_application
