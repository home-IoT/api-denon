#!/usr/bin/env bash

#
# Increment the version number in a service REPO
#
# Usage: inc-service-version [repo_dir] <--major|--minor|--patch>
#
# Copyright (c) 2016-2018 Roozbeh Farahbod
# Distributed under the MIT License.
#

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPT_NAME="inc-service-version.sh"

source ${SCRIPT_DIR}/common.sh

# Get OS family
checkOSFamily

if [ $# == 0 ]
then 
  showUsage "${BASH_SOURCE[0]}"
  exit 1
fi

if [ $# == 1 ] 
then 
  REPO_DIR=""
  INC_VERSION="$1"
else 
  REPO_DIR="$1"
  INC_VERSION="$2"
fi

# sets the REPO_DIR
getRepoDir "${BASH_SOURCE[0]}" "${REPO_DIR}"

VERSION=$("${SCRIPT_DIR}/get-service-version.sh" "${REPO_DIR}")
CHECK_VERSION="$?"
if [ "$CHECK_VERSION" != "0" ]
then
  showUsage "${BASH_SOURCE[0]}"
  exit 1
fi

MAN_FILE=$("${SCRIPT_DIR}/get-manifest.sh" "${REPO_DIR}")
CHECK_MANIFEST="$?"
if [ "$CHECK_MANIFEST" != "0" ]
then
  showUsage "${BASH_SOURCE[0]}"
  exit 1
fi

# --- all good, so let's start.

ensureCleanDevelopBranch "${REPO_DIR}"

IFS='.' read -ra VERSION_ITEMS <<< "$VERSION"
MAJOR_VERSION=${VERSION_ITEMS[0]#v}
MINOR_VERSION=${VERSION_ITEMS[1]}
PATCH_VERSION=${VERSION_ITEMS[2]}

# increase given part of version
case "x${INC_VERSION}" in
        "x--patch")
          ((PATCH_VERSION=PATCH_VERSION+1))
          NEW_VERSION="v${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}"
            ;;

        "x--minor")
          ((MINOR_VERSION=MINOR_VERSION+1))
          NEW_VERSION="v${MAJOR_VERSION}.${MINOR_VERSION}.0"
            ;;
        "x--major")
          ((MAJOR_VERSION=MAJOR_VERSION+1))
          NEW_VERSION="v${MAJOR_VERSION}.0.0"
            ;;
        *)
            echo "Only --patch/minor/major allowed"
            exit 1
esac

# add optional postfix
if [ -n "${VERSION_POSTFIX}" ]
then
  if [[ ${NEW_VERSION} != *${VERSION_POSTFIX} ]]
  then
    NEW_VERSION="${NEW_VERSION}-${VERSION_POSTFIX}"
  fi
else
  NEW_VERSION=${NEW_VERSION%-*}
fi

# update MANIFEST files
case "$unamestr" in 
  "Darwin")
    sed -i "" "s/${VERSION}/${NEW_VERSION}/g" "${MAN_FILE}"
    ;;

  "Linux")
    sed --in-place="" "s/${VERSION}/${NEW_VERSION}/g" "${MAN_FILE}"
    ;;
esac

# check the new version
VERSION=""
CHECK_VERSION=""
VERSION=$("${SCRIPT_DIR}/get-service-version.sh" "${REPO_DIR}")
CHECK_VERSION="$?"
if [ "$CHECK_VERSION" != "0" ]
then
  printError "Could not update all version files. Please check the repo structure. :-("
  exit 1
fi

if [ "${VERSION}" != "${NEW_VERSION}" ]
then
  printError "Could not increment service version. Please check the repo structure. :-("
  printError "(NEW_VERSION=${NEW_VERSION} VERSION=${VERSION})"
  exit 1
fi

cd "${REPO_DIR}"
 
git add . \
  && git commit -m "update version to ${NEW_VERSION}. [automated version updated]" \
  && exit 0
