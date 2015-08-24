#!/bin/bash
#
# battery status script
#
# source = basicallytech.com/blog/archive/110/Colour-coded-battery-charge-level-and-status-in-your-bash-prompt

#BATTERY=/proc/acpi/battery/BAT0
#BATTERY=/sys/class/power_supply/BAT0
#BATTERY=`acpi -a -b | grep Battery`

BATTERY=`acpi -b | cut -d',' -f 2 | egrep -o '[0-9]{2}'`
CHARGE=${BATTERY//[[:blank:]]/}
STATE=`acpi -b | cut -d',' -f 1 | cut -d':' -f 2`
BATSTATE=${STATE//[[:blank:]]/}

#REM_CAP=`grep "^remaining capacity" $BATTERY/state | awk '{ print $3 }'`
#FULL_CAP=`grep "^last full capacity" $BATTERY/info | awk '{ print $4 }'`
#BATSTATE=`grep "^charging state" $BATTERY/state | awk '{ print $3 }'`

#CHARGE=`echo $(( $REM_CAP * 100 / $FULL_CAP ))`

NON='\033[00m'
BLD='\033[01m'
RED='\033[01;31m'
GRN='\033[01;32m'
YEL='\033[01;33m\a'

COLOUR="$RED"

case "${BATSTATE}" in
	'Full')
	BATSTT="$BLD=$NON"
	;;
	'Charging')
	BATSTT="$BLD+$NON"
	;;
	'Discharging')
	BATSTT="$BLD-$NON"
	;;
esac

#prevent a charge of more then 100% displaying

if [ "$CHARGE" == "00" ]
then
	CHARGE=100
fi

if [ "$CHARGE" -gt "15" ]
then
	COLOUR="$YEL"
fi

if [ "$CHARGE" -gt "30" ]
then
	COLOUR="$GRN"
fi


echo -e "${COLOUR}${CHARGE}%${NON} ${BATSTT}\a"

#end of file
