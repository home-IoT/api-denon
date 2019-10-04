#!/usr/bin/env bash
#
# Extracts the MANIFEST file(s) from a service REPO
#
# Usage: get-manifest [repo_dir]
#
# Copyright (c) 2016-2018 Roozbeh Farahbod
# Distributed under the MIT License.
#

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPT_NAME="get-manifest.sh"

source ${SCRIPT_DIR}/common.sh

# sets the REPO_DIR
getRepoDir "${BASH_SOURCE[0]}" "$1"

MAN_FILE=${REPO_DIR}/MANIFEST

if [ ! -e "${MAN_FILE}" ]
then
  printError "No MANIFEST file could be found."
  exit 1
fi

printf '%s\n' "${MAN_FILE}"
exit 0
