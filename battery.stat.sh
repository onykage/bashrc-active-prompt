#!/bin/bash
#
# battery status script
#
# source = basicallytech.com/blog/archive/110/Colour-coded-battery-charge-level-and-status-in-your-bash-prompt

## old way
##BATTERY=/proc/acpi/battery/BAT0


#REM_CAP=`grep "^remaining capacity" $BATTERY/state | awk '{ print $3 }'`
#FULL_CAP=`grep "^last full capacity" $BATTERY/info | awk '{ print $4 }'`
#BATSTATE=`grep "^charging state" $BATTERY/state | awk '{ print $3 }'`


#CHARGE=`echo $(( $REM_CAP * 100 / $FULL_CAP ))`

##new way

BATTERY=/sys/class/power_supply/BAT1
if [ -f "$BATTERY" ]; then

	BATSTATE=`cat $BATTERY/status`

	CHARGE=`cat $BATTERY/capacity`
else

	BATSTATE="full"
	CHARGE="-1"
fi

NON='\033[00m'
BLD='\033[01m'
RED='\033[01;31m'
GRN='\033[01;32m'
YEL='\033[01;33m'

COLOUR="$RED"

#case "${BATSTATE}" in
#	'charged')
#	BATSTT="$BLD=$NON"
#	;;
#	'charging')
#	BATSTT="$BLD+$NON"
#	;;
#	'discharging')
#	BATSTT="$BLD-$NON"
#	;;
#esac

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

if [ "$CHARGE" -gt "99" ]
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
if [ "$CHARGE" -eq "-1" ]
then
	COLOUR="$NON"
	CHARGE="NOBATT"
	echo -e "${COLOUR}${CHARGE}${NON}${BATSTT}"
else
	echo -e "${COLOUR}${CHARGE}%${NON} ${BATSTT}"
fi




#end of file
