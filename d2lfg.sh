#!/bin/bash
#=====================================================
# Name:         init_d2lfg
# Version:      1.3.0
# Author:       Mario Rybar
# E-Mail:       majlo.rybar@gmail.com
# Date:         15.09.2019
#=====================================================
# CHANGE LOG
# 15.09.2019 - Initial version
#=====================================================
# USAGE:
#   ./d2lfg.sh <REFRESH INTERVAL> <GAME TYPE> <FILTER>
#
# SHOW HELP:
#   ./d2lfg.sh --help
#
# PARAMETERS:
#   REFRESH INTERVAL: number in seconds
#          GAME TYPE: raid, crucible, nightfall, gambit, blindwell, escalationprotocol, reckoning, menagerie
#   *optional FILTER: key1,key2,prestige,catalyst
#
# EXAMPLE:
#   ./d2lfg.sh 30 crucible pvp,luna,comp
#
#=========================================================================================================
# set -x      # Debug

# INPUT VARIABLES
REFRESH="$1"
TYPE="$2"
FILTER="$3"
# temporary file to pass inputs
P="/tmp/d2lfg.pref.txt"

# RUNTIME VAR
SCRIPT_DIR=$(dirname "$0")
SCRIPT_NAME=$(basename "$0")
MAIN_NAME="d2lfg-main-v1.1.0.sh"
SCRIPT_MAIN="${SCRIPT_DIR}/${MAIN_NAME}"
# get number or false
HELP=$(echo "$REFRESH" | grep -E ^\-?[0-9]?\.?[0-9]+$)

#=========================================================================================================
# GET HELP FUNCTION
show_help(){
  echo "USAGE:"
  echo "  sh d2lfg.sh [REFRESH_RATE]... [GAME_TYPE]... [FILTER]..."
  echo ""
  echo "INPUT PARAMETERS:"
  echo " Mandatory:"
  echo "   -REFRESH_RATE     number of seconds for results refresh"
  echo ""
  echo " Optional:"
  echo "   -GAME_TYPE        name of activity in lower case without spaces"
  echo "                     get all activities if parameter does not match activity name"
  echo "                      - raid/crucible/nightfall/gambit/blindwell/escalationprotocol/reckoning/menagerie"
  echo "   -FILTER           leave empty for disabled filter"
  echo "                     search in results for keyword from parameter"
  echo "                     for multiple keywords specify single words without spaces separated by comma"
  echo "                      - key1,key2,prestige,catalyst,..."
  echo "   -h, --help        display this help"
  echo ""
  echo "EXAMPLE:"
  echo "  ./d2lfg.sh 30 crucible pvp,luna,comp"
  echo ""
  echo "ALTERNATIVE USAGE:"
  echo "    add following line to ~/.bashrc file:"
  echo "      alias lfg='sh /path/d2lfg/d2lfg.sh'"
  echo "    and call script with simple:~$ lfg [refresh] [game type] [filter]"
  exit 0
}
#=========================================================================================================
# FUNCTIONS
# Create tmp pref file
gen_pref(){

  if [ $FILTER ]; then
    # replace , with | and put into ()
    PARAMETERS=$(echo "($FILTER)" | sed 's/,/|/g')
  fi
  # write runtime var into tmp pref file
  echo "$TYPE" > ${P}
  echo "$PARAMETERS" >> ${P}
  echo "$REFRESH" >> ${P}
}

# check if main script file is executable
check_executable(){
  # does file exist?
  ls "$SCRIPT_DIR" | grep -i d2lfg-main 1&>2
  if [ "$?" = 0 ]; then
    if [ -x "$SCRIPT_MAIN" ]; then
      echo -en " * d2lfg-main executable \t[OK]\n"
    else
      echo -en " * d2lfg.sh is not executable\t[FAILED]\n"
      echo ""
      echo -en " ! Solution: $ sudo chmod 774 '$SCRIPT_MAIN'\n"
      echo " Stopping script now.\n"
      exit 0
    fi
  else
    echo -en " * $MAIN_NAME not found \t[FAILED]\n"
    echo -en " ! Solution: Put '$MAIN_NAME' and '$SCRIPT_NAME' into the same directory\n"
    echo ""
  fi
}

# check dependencies
check_dep(){
  # if command exist
  if command -v $1 >/dev/null 2>&1 ; then
    echo -en " * $1 found\t\t\t[OK]\n"
  else
    echo -en " * $1 not found\t\t[FAILED]\n"
    echo -en " ! Install $1:\t $ sudo apt-get install $1\n"
    echo -en "\t\t\t $ sudo yum install $1\n"
    echo " Stopping script now."
    exit 0
  fi
}

# regular old cleanup
clean_up(){
  rm -rf ${P}
}

#=========================================================================================================
# LETS GET STARTED ===========================================================================================
#=========================================================================================================
# SHOW HELP OR PROCEED
if [ -x $HELP ]; then
  # not number
  if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    show_help
    exit 0
  else
    echo " No refresh interval specified. Using default 30 seconds."
  fi
else
  # SAY HELLO
    echo -en "--------------------------------------------------------------------------\n"
    echo -en " Starting initial checks \n"
  # CALL FUNCTIONS
  gen_pref
    echo -en "1. File '$SCRIPT_MAIN':\n"
  check_executable
    echo ""
    echo -en "2. Commands dependencies:\n"
  check_dep column
  check_dep tput
  check_dep curl
  # MAIN MAGIC
    echo ""
    echo " Starting... "
  watch -n ${REFRESH} -ct "$SCRIPT_MAIN"
    echo "all done!"
  # THANKS NOOPNOOP
  clean_up
fi

exit 0
