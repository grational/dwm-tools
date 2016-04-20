#!/bin/bash
# @usage: configure your login manager to execute this script on logout
# i.e.,
# /etc/lightdm/lightdm.conf
# [SeatDefaults]
# session-cleanup-script=/usr/local/bin/dwm-logout.sh

Pgrep ()
{
    grep_string=\[${1:0:1}\]${1:1};
    ps wwaux | grep --color=auto "${grep_string}"
}

Pgrep lightdm-session | awk '{print $2}' | xargs kill
