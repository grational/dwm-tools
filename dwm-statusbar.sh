#!/bin/bash

WLAN="$(iwconfig wlan0 | grep -oP '(?<=ESSID:")[^"]*')"
# Add ssh-agent to commit in github without asking for a password
DBOX="$(dropbox status | head -n1)"
VOL="$(amixer get Master | grep -oP 'off(?=\])|\d+%(?=.*\[on\])')"
#VOL="$(amixer get Master | egrep -o '[0-9]+%')"
#VOL="$(amixer get Master | awk '/[0-9]+%/ { gsub(/[][]/,""); printf("%s",$4)  }')"
TEMP="$(grep -o '^[0-9][0-9]' /sys/class/thermal/thermal_zone0/temp)"
DATE="$(date '+%A, %d.%m.%Y %H:%M')"
LOAD=`echo $(cut -d' ' -f1 /proc/loadavg)*100 | bc | sed 's/\.[0-9]*//'`
FREE_DATA=`free -m | grep Mem`
CURRENT=`echo $FREE_DATA | cut -f3 -d' '`
TOTAL=`echo $FREE_DATA | cut -f2 -d' '`
MEM="$(echo "scale=1; ${CURRENT}/${TOTAL}*100" | bc)"
CPU="$(ps -A -o pcpu | tail -n+2 | paste -sd+ | bc)"
HDD="$(df -lh | awk '{if ($6 == "/") { print $5 }}')"
if acpi -a | grep off-line > /dev/null; then
	BAT="$(acpi -b | cut -d' ' -f4 | tr -d '%,')"
	xsetroot -name "DBOX: ${DBOX} | CPU: ${CPU}% | MEM: ${MEM}% | LOAD: ${LOAD}% | HDD: ${HDD} | T: ${TEMP}C | BAT: ${BAT}% | VOL: ${VOL} | ${DATE}"
  # Ask to suspend if lower than 10%
  if [[ $BAT -lt 10 ]]; then
    if zenity --question --timeout 8 --text="Low battery ($BAT%). Suspend?"; then
      sudo pm-suspend
    fi
  fi
else
	xsetroot -name "DBOX: ${DBOX} | CPU: ${CPU}% | MEM: ${MEM}% | LOAD: ${LOAD}% | HDD: ${HDD} | T: ${TEMP}C | VOL: ${VOL} | ${DATE}"
fi
