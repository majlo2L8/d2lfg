#!/bin/bash
#=====================================================
# Name:         init_d2lfg
# Version:      1.0.0
# Author:       Mario Rybar
# E-Mail:       majlo.rybar@gmail.com
# Date:         15.09.2019
#=====================================================
# CHANGE LOG
# 15.09.2019 - Initial version
#=====================================================
# TO DO:
#
#=========================================================================================================
# USAGE:
# ./init_d2lfg.sh <REFRESH INTERVAL> <GAME TYPE> <FILTER>
#
# PARAMETERS:
# REFRESH INTERVAL: number in seconds
# GAME TYPE: raid, crucible, nightfall, gambit, blindwell, escalationprotocol, reckoning, menagerie
# *optional FILTER: key1,key2,prestige,catalyst
#
# EXAMPLE:
# ./init_d2lfg.sh 30 crucible pvp,luna,comp
#=========================================================================================================
# Debug
# set -x

# INPUT VARIABLES
REFRESH="$1"
TYPE="$2"
OPTIONS="$3"

# RUNTIME VAR
SCRIPT_DIR=$(dirname "$0")

#=========================================================================================================
# FUNCTIONS

# Create tmp pref file
gen_pref(){
  # temporary file to pass inputs
  P="/tmp/d2lfg.pref.txt"

  if [ $OPTIONS ]; then
    # replace , with | and put into ()
    PARAMETERS=$(echo "($OPTIONS)" | sed 's/,/|/g')
  fi
  # write runtime var into tmp pref file
  echo "$TYPE" > ${P}
  echo "$PARAMETERS" >> ${P}
  echo "$REFRESH" >> ${P}
}

# check if main script file is executable
check_executable(){
  if [ -x "$SCRIPT_DIR/d2lfg.sh" ]; then
    echo " * d2lfg.sh executable \t\t[OK]"
  else
    echo " * d2lfg.sh is not executable or found.\t[FAILED]"
    echo ""
    echo " ! Solution: $ sudo chmod 774 $SCRIPT_DIR/d2lfg.sh"
    echo ""
    echo " Stopping script now."
    exit 0
  fi
}

# check dependencies
check_dep(){
  # if command exist
  if command -v $1 >/dev/null 2>&1 ; then
    echo " * $1 found\t\t\t[OK]"
  else
    echo -n " * $1 not found\t\t[FAILED]\n"
    echo -n " ! Install $1:\t $ sudo apt-get install $1\n"
    echo -n "\t\t\t $ sudo yum install $1\n"
    echo " Stopping script now."
    exit 0
  fi
}

# regular old cleanup
clean_up(){
  rm -rf ${P}
}

#=========================================================================================================
# SAY HELLO
#=========================================================================================================
echo -n "--------------------------------------------------------------------------\n"
echo -n " Starting checks for d2lfg-v1.1.0.sh...\n\n"

  # CALL FUNCTIONS
  gen_pref
  echo "1. File '$SCRIPT_DIR/d2lfg.sh':"
  check_executable
  echo ""
  echo "2. Commands dependencies:"
  check_dep column
  check_dep tput
  check_dep curl

# MAIN MAGIC
echo ""
echo " Starting d2lfg..."
watch -n ${REFRESH} -ct '/home/majlo/Documents/Script/bungie_lfg/d2lfg.sh'

# THANKS NOOPNOOP
clean_up

# END
exit 0
