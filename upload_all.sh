#!/bin/bash

#UTF-8 is required by Fastlane
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
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

function upload_application() {
  export LANE_NAME="uploadToTestflight"

  export LOGS_DIR="build_logs"
  export LANE_LOGS="${LOGS_DIR}/${TEAM_NAME}/${LANE_NAME}"
  mkdir -p "${LANE_LOGS}"

  while IFS=$'\n' read -r IPA_PATH; do
    export IPA_FILENAME=$(echo $IPA_PATH | rev | cut -d "/" -f 1 | rev)
    export APP_NAME=${IPA_FILENAME%.*}
    echo -e "${YELLOW}Uploading ${CYAN}${APP_NAME}${YELLOW} app${NO_COL}"
    echo -e "${YELLOW}IPA path: ${CYAN}${IPA_PATH}${NO_COL}"
    bundle exec fastlane ios go_testflight username:"${APPLE_USERNAME}" ipapath:"${IPA_PATH}" --verbose > "./${LANE_LOGS}/$APP_NAME.txt"
    export EXIT_STATUS=$?
    if [ $EXIT_STATUS -eq 0 ]
    then
      echo -e "${GREEN}Successfully uploaded ${NO_COL}${APP_NAME}"
      echo "${IPA_FILENAME}" >> "./${LOGS_DIR}/${TEAM_NAME}/successfull_uploads.txt"
    else
      echo -e "${RED}Build failed for ${NO_COL}$APP_NAME: ${RED}Exit code: ${NO_COL}$EXIT_STATUS"
      echo "${IPA_FILENAME}" >> "./${LOGS_DIR}/${TEAM_NAME}/failed_uploads.txt"
    fi
  done < "./${LOGS_DIR}/${TEAM_NAME}/successfull_builds.txt"
}

export APPLE_USERNAME="${1}"
export FASTLANE_USER="${APPLE_USERNAME}"
read -s -p "Enter your iTunes Connect password: " FASTLANE_PASSWORD && echo


#First team info
export TEAM_NAME="Teamy McTeamFace"
export FASTLANE_ITC_TEAM_ID="123456"
export FASTLANE_ITC_TEAM_NAME="${TEAM_NAME}"

echo -e "${YELLOW}Beginning with ${CYAN}${TEAM_NAME}${YELLOW} team apps upload${NO_COL}"

upload_application

#second team info
export TEAM_NAME="Other team"
export FASTLANE_ITC_TEAM_ID="654321"
export FASTLANE_ITC_TEAM_NAME="${TEAM_NAME}"

echo -e "${YELLOW}Beginning with ${CYAN}${TEAM_NAME}${YELLOW} team apps upload${NO_COL}"

upload_application
