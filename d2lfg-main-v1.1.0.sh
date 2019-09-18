#!/bin/bash
#=====================================================
# Name:         lfg-v1.0.0
# Version:      1.0.0
# Author:       Mario Rybar
# E-Mail:       majlo.rybar@gmail.com
# Date:         08.09.2019
#=====================================================
# CHANGE LOG
# 08.09.2019 - Initial version
#=====================================================
# TO DO:
#
#=========================================================================================================
# Script is called by init_d2lfg.sh due to watch command limitations
# USAGE:
# watch -n <refresh interval> -ct './lfg.sh <GAME TYPE> <FILTER>'
# EXAMPLE:
# watch -n 30 -ct './lfg.sh reckoning "(tier3|t3)"'
# PARAMETERS:
# REFRESH INTERVAL: number in seconds
# GAME TYPES: raid, crucible, nightfall, gambit, blindwell, escalationprotocol, reckoning, menagerie
# FILTER: optional, "(eow|eater|prestige|catalyst)"
#=========================================================================================================
# NAMING CONVENTION
# lfg-v1.0.0.sh
# scriptname-v[Major change].[Minor change].[revision].sh
#=========================================================================================================
# NOTES:
# RAID      - https://www.bungie.net/en/ClanV2/FireteamSearch?latform=1&activityType=1&lang=&groupid=&
# NF        - https://www.bungie.net/en/ClanV2/FireteamSearch?platform=1&activityType=4&lang=&groupid=&
# GAMBIT    - https://www.bungie.net/en/ClanV2/FireteamSearch?platform=1&activityType=6&lang=&groupid=&
# BLINDWELL - https://www.bungie.net/en/ClanV2/FireteamSearch?platform=1&activityType=7&lang=&groupid=&
# EP        - https://www.bungie.net/en/ClanV2/FireteamSearch?platform=1&activityType=8&lang=&groupid=&
# RECKONING - https://www.bungie.net/en/ClanV2/FireteamSearch?platform=1&activityType=10&lang=&groupid=&
# MENAGERIE - https://www.bungie.net/en/ClanV2/FireteamSearch?platform=1&activityType=11&lang=&groupid=&
#==========================================================================================================
# enable debug
# set -x
#==========================================================================================================
# VARIABLES

#REFRESH="$3"
activityType=""
activityName=""
URL=""

# COLOR MNGMNT
yellow=$(tput setaf 3)
redBold=$(tput setaf 1; tput bold)
white=$(tput setaf 7)
bold=$(tput bold)
reset=$(tput sgr0)
resetFont=`tput sgr0 | sed 's/(B//g'`

# WORK FILES
M=$(mktemp /tmp/d2flg.m1.XXXXXX)
U=$(mktemp /tmp/d2flg.u1.XXXXXX)
T=$(mktemp /tmp/d2flg.t1.XXXXXX)
R=$(mktemp /tmp/d2flg.r1.XXXXXX)
A=$(mktemp /tmp/d2flg.a1.XXXXXX)
Z=$(mktemp /tmp/d2flg.z1.XXXXXX)
F=$(mktemp /tmp/d2flg.f1.XXXXXX)
P="/tmp/d2lfg.pref.txt"

TYPE=$(head -n1 ${P})
OPTIONS=$(sed -n 2p ${P})
REFRESH=$(sed -n 3p ${P})

#==========================================================================================================
# FUNCTIONS

# GET GAME TYPE FROM INPUT
get_type() {
  # set according to input parameter
  case "$TYPE" in
     "raid")
        activityType="1"
        activityName="RAID"
        HEADER1="${redBold}╦═╗╔═╗╦╔╦╗ ${resetFont}"
        HEADER2="${redBold}╠╦╝╠═╣║ ║║ ${resetFont}"
        HEADER3="${redBold}╩╚═╩ ╩╩═╩╝ ${resetFont}"
     ;;
     "pvp" | "crucible")
        activityType="2"
        activityName="CRUCIBLE"
        HEADER1="${redBold}╔═╗╦═╗╦ ╦╔═╗╦╔╗ ╦  ╔═╗${resetFont}"
        HEADER2="${redBold}║  ╠╦╝║ ║║  ║╠╩╗║  ║╣ ${resetFont}"
        HEADER3="${redBold}╚═╝╩╚═╚═╝╚═╝╩╚═╝╩═╝╚═╝${resetFont}"
     ;;
     "nf" | "nightfall")
        activityType="4"
        activityName="NIGHTFALL"
        HEADER1="${redBold}╔╗╔╦╔═╗╦ ╦╔╦╗╔═╗╔═╗╦  ╦  ${resetFont}"
        HEADER2="${redBold}║║║║║ ╦╠═╣ ║ ╠╣ ╠═╣║  ║  ${resetFont}"
        HEADER3="${redBold}╝╚╝╩╚═╝╩ ╩ ╩ ╚  ╩ ╩╩═╝╩═╝${resetFont}"
     ;;
     "gambit")
        activityType="6"
        activityName="GAMBIT"
        HEADER1="${redBold}╔═╗╔═╗╔╦╗╔╗ ╦╔╦╗${resetFont}"
        HEADER2="${redBold}║ ╦╠═╣║║║╠╩╗║ ║ ${resetFont}"
        HEADER3="${redBold}╚═╝╩ ╩╩ ╩╚═╝╩ ╩ ${resetFont}"
     ;;
     "bw" | "blindwell")
        activityType="7"
        activityName="BLIND WELL"
        HEADER1="${redBold}╔╗ ╦  ╦╔╗╔╔╦╗  ╦ ╦╔═╗╦  ╦  ${resetFont}"
        HEADER2="${redBold}╠╩╗║  ║║║║ ║║  ║║║║╣ ║  ║  ${resetFont}"
        HEADER3="${redBold}╚═╝╩═╝╩╝╚╝═╩╝  ╚╩╝╚═╝╩═╝╩═╝${resetFont}"
     ;;
     "ep" | "escalationprotocol")
        activityType="8"
        activityName="ESCALATION PROTOCOL"
        HEADER1="${redBold}╔═╗╔═╗╔═╗╔═╗╦  ╔═╗╔╦╗╦╔═╗╔╗╔  ╔═╗╦═╗╔═╗╔╦╗╔═╗╔═╗╔═╗╦  ${resetFont}"
        HEADER2="${redBold}║╣ ╚═╗║  ╠═╣║  ╠═╣ ║ ║║ ║║║║  ╠═╝╠╦╝║ ║ ║ ║ ║║  ║ ║║  ${resetFont}"
        HEADER3="${redBold}╚═╝╚═╝╚═╝╩ ╩╩═╝╩ ╩ ╩ ╩╚═╝╝╚╝  ╩  ╩╚═╚═╝ ╩ ╚═╝╚═╝╚═╝╩═╝${resetFont}"
     ;;
     "reckoning")
        activityType="10"
        activityName="RECKONING"
        HEADER1="${redBold}╦═╗╔═╗╔═╗╦╔═╔═╗╔╗╔╦╔╗╔╔═╗${resetFont}"
        HEADER2="${redBold}╠╦╝║╣ ║  ╠╩╗║ ║║║║║║║║║ ╦${resetFont}"
        HEADER3="${redBold}╩╚═╚═╝╚═╝╩ ╩╚═╝╝╚╝╩╝╚╝╚═╝${resetFont}"
     ;;
     "meng" | "menagerie")
        activityType="11"
        activityName="MENAGERIE"
        HEADER1="${redBold}╔╦╗╔═╗╔╗╔╔═╗╔═╗╔═╗╦═╗╦╔═╗${resetFont}"
        HEADER2="${redBold}║║║║╣ ║║║╠═╣║ ╦║╣ ╠╦╝║║╣ ${resetFont}"
        HEADER3="${redBold}╩ ╩╚═╝╝╚╝╩ ╩╚═╝╚═╝╩╚═╩╚═╝${resetFont}"
     ;;
  esac

  # SET URL
  URL="https://www.bungie.net/en/ClanV2/FireteamSearch?platform=1&activityType=${activityType}"
}


#==========================================================================================================
# here comes the magic
curl_lfg() {
  # does page continue on next? 0=no; 1=yes
  PAGES=$(curl -s "${URL}" | grep -c "js-next-fireteams clickable")
  # MATCH game type
#  curl -s "${URL}" | grep -iP -B6 "${OPTIONS}" > ${M}
  curl -s "${URL}" | grep -iP -C8 "${OPTIONS}" > ${M}

  # If there is another page
  if [ "${PAGES}" = "1" ]; then
    # write second page to file
#    curl -s "${URL}&page=1" | grep -iP -B6 "${OPTIONS}" >> ${M}
    curl -s "${URL}&page=1" | grep -iP -C8 "${OPTIONS}" >> ${M}
  fi
}

#==========================================================================================================
# FIRETEAMS URL
parse_data() {
  # PARSE LFG POST names
  cat ${M} | grep -iPo "(?<=\<p\sclass\=.title.\>).*(?=\<\/p\>)" > ${F}

  # https://www.bungie.net/en/ClanV2/PublicFireteam?groupId=0&fireteamId=17236718
  cat ${M} | grep -iPo "(?<=\<a\shref\=.).*(?=.\sclass\=.item-fireteam-card.\>)" > ${U}

  # GET TIME:$ cat /tmp/m | grep -A2 "meta creation-date" | sed -n '3~2p' | sed -n '1~2p' | sed 's/\s//g'
  # !!!  cat ${M} | grep -A2 "meta creation-date" | sed -n '3~2p' | sed -n '1~2p' | sed 's/\s//g' > ${T}
  cat ${M} | grep -P "\d[A-Za-z]" | sed 's/\s//g' | grep -P "^\d" > ${T}

  # get number of taken / total slots
  cat ${M} | grep player-slot | sed "s/.*player-slots.*/@/g" | sed -e "s/.*used.*/x/g" -e "s/.*slot.*/a/g" | paste -sd - | sed -e 's/-@-/\n@/g' -e 's/[-|@]//g' | paste -sd , | sed 's/,/ /g' > ${R}

  # set array and
  touch "${Z}"
  IFS=', ' read -r -a array <<< $(cat "${R}")

  for fireteam in "${array[@]}"
  do
    # get number of taken slots
    TAKEN=$(echo "$fireteam" | grep -o "x" | wc -l)
    TFROM=$(($(echo "$fireteam" | wc -c) - 1))
    #TAKEN=$(echo "$fireteam")
    # get slots
    echo "$TAKEN/$TFROM" >> ${Z}
    # echo "${#array[fireteam]}" >> ${Z}
  done

  # Add https://www.bungie.net to begining of each line
  sed -i 's/^/https\:\/\/www\.bungie\.net/g' ${U}
  # remove apm; from URLs
  sed -i -r 's/amp\;//g' ${U}
  sed -i -r 's/&#8217;//g' ${F}


  # insert columns names
  sed -i '1 i\⌬ LFG POST' ${F}
  sed -i '1 i\⥱ URL' ${U}
  sed -i '1 i\ ⟳' ${T}
  sed -i '1 i\ ✔' ${Z}


  # Join results into columns to one file
  paste -d'@' ${Z} ${T} ${F} ${U} | column -s "@" -t | sed 's/^/ /g' > ${A}


}

#==========================================================================================================
set_header() {
  #set -x
  TIME=$(date +"%T")
  finalL=""

  # HEADER LINE
  H0="${yellow}+----------------------------------------------------------------------------"
  H1="${yellow}|  ${HEADER1}\t\t  Refreshed: ${TIME}   Every: ${REFRESH}s"
  H2="${yellow}|  ${HEADER2}\t\t     Search: ${OPTIONS}"
  H3="${yellow}|  ${HEADER3}"
  H4="${yellow}| ${URL}"

  if [ $(echo "${H2}" | wc -m) -gt $(echo "${H4}" | wc -m) ]; then
    finalL=$(($(echo "${H2}" | wc -m)-1))
  else
    finalL=$(($(echo "${H4}" | wc -m)-1))
  fi

  H0=$(echo "${H0}" | { N=$(($finalL-$(echo "${H0}" | wc -m))); perl -pe "s/$/'-'x$N/e" ; })

}

#==========================================================================================================
# LOG output
log_output() {

  # start header
  echo "$H0"
  echo -e "$H1"
  echo -e "$H2"
  echo "$H3"
  echo "$H4"
  echo "$H0"

  # set font yellow, bold
  echo -ne "${yellow}${bold}"
  # read column names in color
  sed -n '1p' ${A} | sed 's/^\s//g'

  # reset font modifications
  echo -en "${resetFont}"

  # read results
  tail -n +2 ${A}

}


#==========================================================================================================
# CLEAN UP
clean_up() {
  # remove work data
  rm -rf ${M} ${F} ${U} ${A} ${T} ${Z} ${R}

}

#==========================================================================================================
# MAIN
# CALL FUNCTIONS
get_type
curl_lfg
parse_data
set_header
log_output
clean_up

# end
