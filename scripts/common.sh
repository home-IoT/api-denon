#
# Common utility functions for other scripts
#
# Copyright (c) 2016-2018 Roozbeh Farahbod
# Distributed under the MIT License.
#

CHILD_SCRIPT=""
CUR_DIR="$PWD"

# print an error message to stderr
printError() {
  (>&2 echo "ERROR: $*")
}

# show usage of the tool
showUsage() {
  MSG=$(grep -e '^# Usage' "$1" | sed 's/^#\ //')
  (>&2 echo "$MSG")
}

# ensure that we are on a develop branch and that there is no uncommitted changes
ensureCleanDevelopBranch() {
  REPO_DIR="$1"
  ensureCleanDevelopBranch_CUR_DIR="$PWD"

  cd "${REPO_DIR}"

  git checkout -q develop
  if [ "$?" != 0 ]
  then
    printError "Cannot swtich to branch 'develop'. You are most likely not on branch 'develop' and have uncommitted files."
    exit 1
  fi

  CHANGED_FILES=$(git status --porcelain)

  if [ ! -z "${CHANGED_FILES}" ]
  then
    printError "There are still files to be committed."
    exit 1
  fi

  cd "${ensureCleanDevelopBranch_CUR_DIR}"
}

# finds and/or validates the repository directory
getRepoDir() {
  grd_SCRIPT="$1"
  REPO_DIR="$2"
  grd_SCRIPT_DIR="$( cd "$( dirname "${grd_SCRIPT}" )" && pwd )"
  REPO_DIR=$("${grd_SCRIPT_DIR}/check-repo-dir.sh" "${REPO_DIR}")
  grd_CHECK_DIR="$?"
  if [ "$grd_CHECK_DIR" != "0" ]
  then
    showUsage ${grd_SCRIPT}
    exit 1
  fi
}

# make sure that the OS is either Linux or MacOS
checkOSFamily() {
  # Get OS family
  unamestr=$(uname)

  if [ "$unamestr" != "Darwin" ] && [ "$unamestr" != "Linux" ]
  then
    printError "This script can only run on Linux or MacOS."
    exit 1
  fi
}
