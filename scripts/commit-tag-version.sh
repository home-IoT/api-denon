#!/usr/bin/env bash

#
# Tags the latest commit with the current version
#
# Usage: commit-tag-version [repo_dir]
#
# Copyright (c) 2016-2018 Roozbeh Farahbod
# Distributed under the MIT License.
#

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPT_NAME="commit-tag-version.sh"

source ${SCRIPT_DIR}/common.sh

checkOSFamily

REPO_DIR="$1"

# sets the REPO_DIR
getRepoDir "${BASH_SOURCE[0]}" "${REPO_DIR}"

VERSION=$("${SCRIPT_DIR}/get-service-version.sh" "${REPO_DIR}")
CHECK_VERSION="$?"
if [ "$CHECK_VERSION" != "0" ]
then
  showUsage "${BASH_SOURCE[0]}"
  exit 1
fi

ensureCleanDevelopBranch "${REPO_DIR}"

cd "${REPO_DIR}"

# check if the tag is new
git tag --list | grep -q "${VERSION}" 
if [ "$?" == "0" ]
then 
  printError "The current version tag already exists."
  exit 1
fi

# push the history, tag the current commit and push the tag to remote
git push \
  && git tag -a "${VERSION}" -m "Version ${VERSION}" \
  && git push origin --tags \
  && exit 0
