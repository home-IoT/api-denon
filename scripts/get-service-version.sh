#!/usr/bin/env bash

#
# Get the version number from a repository with a MANIFEST file. 
#
# Usage: get-service-version [repo_dir]
#
# Copyright (c) 2016-2018 Roozbeh Farahbod
# Distributed under the MIT License.
#

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPT_NAME="get-service-version.sh"

source ${SCRIPT_DIR}/common.sh

# sets the REPO_DIR
getRepoDir "${BASH_SOURCE[0]}" "$1"

MANIFEST_FILE=$("${SCRIPT_DIR}/get-manifest.sh" "${REPO_DIR}")
CHECK_MANIFEST="$?"
if [ "$CHECK_MANIFEST" != "0" ]
then
  showUsage "${BASH_SOURCE[0]}"
  exit 1
fi

VERSION=$(grep '\<VERSION\>' ${MANIFEST_FILE} | cut -d '=' -f2)

if [ -z "${VERSION}" ]
then
  printError "MANIFEST file is not valid. Could not read version information."
  exit 1
fi

echo $VERSION
exit 0
