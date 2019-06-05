#!/bin/sh
set -eu

die() {
	echo 1>&2 "[ERROR] ${*}"
	exit 1
}


[ ${#@} -lt 1 ] && die "${0##*/} <inc|dec|max|min>"
blpath=/sys/class/backlight/intel_backlight
bl_max="${blpath}/max_brightness"
bl_cur="${blpath}/actual_brightness"
bl_ctl="${blpath}/brightness"

[ -d ${blpath} ] || die "backlight path '${blpath}' not found!"
[ -r ${bl_max} ] || die "cannot read brightness max value from ${bl_max}"
[ -r ${bl_cur} ] || die "cannot read brightness current value from ${bl_cur}"
[ -w ${bl_ctl} ] || die "cannot write the new brightness value on ${bl_ctl}"

min_br=1
max_br="$(cat ${bl_max})"
cur_br="$(cat ${bl_cur})"
step=$(( $max_br / 25 ))

if [ ${1} = 'inc' ]; then
	new_br=$(( $cur_br + $step ))
	[ $new_br -gt $max_br ] && new_br=${max_br}
elif [ ${1} = 'dec' ]; then
	new_br=$(( $cur_br - $step ))
	[ $new_br -lt $min_br ] && new_br=${min_br}
elif [ ${1} = 'max' ]; then
	new_br=$max_br
elif [ ${1} = 'min' ]; then
	new_br=$min_br
else
	die "${0##*/} <inc|dec>"
fi

echo $new_br > $bl_ctl
