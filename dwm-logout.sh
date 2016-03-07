#!/bin/bash

Pgrep ()
{
    grep_string=\[${1:0:1}\]${1:1};
    ps wwaux | grep --color=auto "${grep_string}"
}

Pgrep lightdm-session | awk '{print $2}' | xargs echo kill > /tmp/dwm-logout.log
Pgrep lightdm-session | awk '{print $2}' | xargs kill
