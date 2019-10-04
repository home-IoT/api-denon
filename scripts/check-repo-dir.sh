#!/usr/bin/env bash

#
# Script to check if a repo directory exists and is a valid Git directory. 
# To be used by other scripts.
#
# Usage: check-repo-dir [repo_dir]
#
# Returns the repo directory if it passes all the checks.
#
# Copyright (c) 2016-2018 Roozbeh Farahbod
# Distributed under the MIT License.
#

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPT_NAME="check-repo-dir.sh"

source ${SCRIPT_DIR}/common.sh

REPO_DIR="$1"
if [ -z "${REPO_DIR}" ]
then
  REPO_DIR=$(git rev-parse --show-toplevel)
fi

if [ ! -d "${REPO_DIR}" ]
then
  printError "The given path is not a directory or is not accessible."
  exit 1
fi

if [ ! -d "${REPO_DIR}/.git" ]
then
  printError "The given path is not a git repository."
  exit 1
fi

echo "${REPO_DIR}"
exit 0
