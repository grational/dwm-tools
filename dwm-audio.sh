#!/bin/bash
set -euo pipefail

# Script: dwm-audio.sh
# Author: Giuseppe Ricupero
# E-mail: <giuseppe.ricupero@polito.com>
# Description: questo script deve poter emulare le funzionalità di:
# - incremento del volume con amixer
# - decremento del volume con amixer
# - mute / unmute con amixer
# Dopo ognuna delle operazione sopra deve rilanciare il programma
# dwm-statusbar.sh
#
SCRIPT_NAME="${0##*/}"

usage() {
	echo "${SCRIPT_NAME} usage:"
	echo ' [-t | --mute]'
	echo ' [-i | --inc-volume]'
	echo ' [-d | --dec-volume]'
	echo ' [-h | --help]'
}
repeat() {
  printf "${1}%.0s" $(seq 1 ${2}); echo
}
slog() {
	if [[ 'x-hg' = "x${1}" ]]; then
		shift; TEXT="[${SCRIPT_NAME}] ${*}"
		repeat '=' "${#TEXT}"
		echo "${TEXT}"
		repeat '=' "${#TEXT}"
	else
		echo "[${SCRIPT_NAME}] ${@}"
	fi
}

if [[ $# -lt 1 ]]; then
	usage
	exit 4
fi

# Initialization
# -

# Handle Command line parameters
SHORT='tidh'
LONG='toggle-mute,inc-volume,dec-volume,help'
PARSED=$(getopt --options ${SHORT} --longoptions ${LONG} --name "$0" -- "$@")
if [[ $? != 0 ]]; then
		exit 2
fi
# Add -- at the end of line arguments
eval set -- "${PARSED}"

case "$1" in
  -h|--help)
    usage
    exit 5
    ;;
  -t|--toggle-mute)
    amixer -D pulse set Master 1+ toggle
    # update statusbar, dwm-statusbar.sh has to be in the PATH
    dwm-statusbar.sh
    shift
    ;;
  -i|--inc-volume)
    amixer -q sset Master 3%+
    dwm-statusbar.sh
    shift
    ;;
  -d|--dec-volume)
    amixer -q sset Master 3%-
    dwm-statusbar.sh
    shift
    ;;
  --)
    shift
    exit 5
    ;;
  *)
    slog "Parameters error"
    exit 3
    ;;
esac
