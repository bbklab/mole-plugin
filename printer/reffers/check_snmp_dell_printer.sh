#!/bin/bash

# check_snmp_dell_printer
# Description : Check the status of Dell Printers
# Version : 1.0
# Author : Chris Yeowell
# Kudos :  This script is based on check_snmp_dell_equallogic.sh by Yoann LAMY
# Licence : GPLv2

# Commands
CMD_BASENAME="/bin/basename"
CMD_SNMPGET="/usr/bin/snmpget"
CMD_SNMPWALK="/usr/bin/snmpwalk"
CMD_AWK="/bin/awk"
CMD_GREP="/bin/grep"
CMD_BC="/usr/bin/bc"
CMD_EXPR="/usr/bin/expr"

# Script name
SCRIPTNAME=`$CMD_BASENAME $0`

# Version
VERSION="0.1"

# Plugin return codes
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3


# 'Model'
OID_MODEL=".1.3.6.1.2.1.43.5.1.1.16.1"

# 'Name'
OID_PRINTER_NAME=".1.3.6.1.2.1.1.5.0"


# 'SerialNumber'
OID_SERIALNUMBER=".1.3.6.1.2.1.43.5.1.1.17.1"

# 'DetailsImpressionsName'
OID_IMPRESSIONS_NAME=".1.3.6.1.4.1.253.8.53.13.2.1.8.1.20"

# 'DetailsImpressionsValue'
OID_IMPRESSIONS_VALUE=".1.3.6.1.4.1.253.8.53.13.2.1.6.1.20"

# 'ConsumableName'
OID_CONSUMABLE_NAME=".1.3.6.1.2.1.43.11.1.1.6.1"

# 'ConsumableRemaining'
OID_CONSUMABLE_REMAINING_VALUE=".1.3.6.1.2.1.43.11.1.1.9.1"

# 'ConsumableCapacity'
OID_CONSUMABLE_CAPACITY_VALUE=".1.3.6.1.2.1.43.11.1.1.8.1"

# 'WarningName'
OID_WARNINGS_NAME=".1.3.6.1.2.1.43.18.1.1.8.1"

# 'WarningsType'
OID_WARNINGS_VALUE=".1.3.6.1.2.1.43.18.1.1.2.1"


# Default variables
DESCRIPTION="Unknown"
STATE=$STATE_UNKNOWN
CODE=0

# Default options
COMMUNITY="public"
HOSTNAME="127.0.0.1"
TYPE="info"
WARNING=0
CRITICAL=0

# Option processing
print_usage() {
  echo "Usage: ./check_snmp_dell_printer -H 127.0.0.1 -C public -t pages"
  echo "  $SCRIPTNAME -H ADDRESS"
  echo "  $SCRIPTNAME -C STRING"
  echo "  $SCRIPTNAME -t STRING"
  echo "  $SCRIPTNAME -w INTEGER" 
  echo "  $SCRIPTNAME -c INTEGER" 
  echo "  $SCRIPTNAME -h"
  echo "  $SCRIPTNAME -V"
}

print_version() {
  echo $SCRIPTNAME version $VERSION
  echo ""
  echo "This nagios plugins comes with ABSOLUTELY NO WARRANTY."
  echo "You may redistribute copies of the plugins under the terms of the GNU General Public License v2." 
}

print_help() {
  print_version
  echo ""
  print_usage
  echo ""
  echo "Check the status of Dell Printer Usage"
  echo ""
  echo "-H ADDRESS"
  echo "   Name or IP address of host (default: 127.0.0.1)"
  echo "-C STRING"
  echo "   Community name for the host's SNMP agent (default: public)"
  echo "-t STRING"
  echo "   Check type (ifo, pages, consumables) (default: info)"
  echo "-w INTEGER"
  echo "   Warning level for size in percent (default: 0)"
  echo "-c INTEGER"
  echo "   Critical level for size in percent (default: 0)"  
  echo "-h"
  echo "   Print this help screen"
  echo "-V"
  echo "   Print version and license information"
  echo ""
  echo ""
  echo "This plugin uses 'snmpget' and 'snmpwalk' commands included with the NET-SNMP package."
  echo "This plugin support performance data output (pages, consumables)."
}

while getopts H:C:t:w:c:hV OPT
do
  case $OPT in
    H) HOSTNAME="$OPTARG" ;;
    C) COMMUNITY="$OPTARG" ;;
    t) TYPE="$OPTARG" ;;
    w) WARNING=$OPTARG ;;
    c) CRITICAL=$OPTARG ;; 
    h) 
      print_help
      exit $STATE_UNKNOWN
      ;;
    V)
      print_version
      exit $STATE_UNKNOWN
      ;;
   esac
done


if  [ $TYPE = "info" ]; then
      # Information (Usage : ./check_snmp_dell_printer -H 127.0.0.1 -C public -t info)
      MODEL=`$CMD_SNMPGET -t 2 -r 2 -v 1 -c $COMMUNITY -Ovq $HOSTNAME ${OID_MODEL} | $CMD_AWK -F '"' '{print $2}'`
      SERIALNUMBER=`$CMD_SNMPGET -t 2 -r 2 -v 1 -c $COMMUNITY -Ovq $HOSTNAME ${OID_SERIALNUMBER} | $CMD_AWK -F '"' '{print $2}'`
      DESCRIPTION="Info : Dell Printer '${MODEL}' (${SERIALNUMBER}) "
      STATE=$STATE_OK
    elif [ $TYPE = "pages" ]; then
      # Check impressions (Usage : ./check_snmp_dell_printer -H 127.0.0.1 -C public -t pages)
      DESCRIPTION="Impressions Made:"
      for IMPRESSIONS_ID in `$CMD_SNMPWALK -t 2 -r 2 -v 1 -c $COMMUNITY $HOSTNAME ${OID_IMPRESSIONS_NAME} | $CMD_AWK '{ print $1}' | $CMD_AWK -F "." '{print $NF}'`; do
        IMPRESSIONS_NAME=`$CMD_SNMPGET -t 2 -r 2 -v 1 -c $COMMUNITY -Ovq $HOSTNAME ${OID_IMPRESSIONS_NAME}.${IMPRESSIONS_ID} | $CMD_AWK -F '"' '{print $2}'`
        IMPRESSIONS_VALUE=`$CMD_SNMPGET -t 2 -r 2 -v 1 -c $COMMUNITY -Ovq $HOSTNAME ${OID_IMPRESSIONS_VALUE}.${IMPRESSIONS_ID}`
        DESCRIPTION="$DESCRIPTION '${IMPRESSIONS_NAME}' : ${IMPRESSIONS_VALUE} Pages, "
        PERFORMANCE_DATA="$PERFORMANCE_DATA '${IMPRESSIONS_NAME}'=${IMPRESSIONS_VALUE}"
      done
      DESCRIPTION="$DESCRIPTION | $PERFORMANCE_DATA"
      STATE=$STATE_OK
    elif [ $TYPE = "consumables" ]; then
      # Check consumables (Usage : ./check_snmp_dell_printer -H 127.0.0.1 -C public -t consumables)
      DESCRIPTION="Consumables status:"
      for CONSUMABLE_ID in `$CMD_SNMPWALK -t 2 -r 2 -v 1 -c $COMMUNITY $HOSTNAME ${OID_CONSUMABLE_NAME} | $CMD_AWK '{ print $1}' | $CMD_AWK -F "." '{print $NF}'`; do
        CONSUMABLE_NAME=`$CMD_SNMPGET -t 2 -r 2 -v 1 -c $COMMUNITY -Ovq $HOSTNAME ${OID_CONSUMABLE_NAME}.${CONSUMABLE_ID} | $CMD_AWK -F '"' '{print $2}'`
        CONSUMABLE_REMAINING_VALUE=`$CMD_SNMPGET -t 2 -r 2 -v 1 -c $COMMUNITY -Ovq $HOSTNAME ${OID_CONSUMABLE_REMAINING_VALUE}.${CONSUMABLE_ID}`
        CONSUMABLE_CAPACITY_VALUE=`$CMD_SNMPGET -t 2 -r 2 -v 1 -c $COMMUNITY -Ovq $HOSTNAME ${OID_CONSUMABLE_CAPACITY_VALUE}.${CONSUMABLE_ID}`
		CONSUMABLE_PERCENT_USED=`$CMD_EXPR \( \( $CONSUMABLE_CAPACITY_VALUE - $CONSUMABLE_REMAINING_VALUE  \) \* 100 / $CONSUMABLE_CAPACITY_VALUE \)`
        DESCRIPTION="$DESCRIPTION '${CONSUMABLE_NAME}' : ${CONSUMABLE_PERCENT_USED}%, "
        PERFORMANCE_DATA="$PERFORMANCE_DATA '${CONSUMABLE_NAME}'=${CONSUMABLE_PERCENT_USED}"
        PERFDATA_WARNING=0
        PERFDATA_CRITICAL=0
		if [ $STATE = $STATE_UNKNOWN ] || [ $STATE = $STATE_OK ]; then
		if [ $WARNING != 0 ] || [ $CRITICAL != 0 ]; then
          PERFDATA_WARNING=`$CMD_EXPR \( $CONSUMABLE_PERCENT_USED \* $WARNING \) / 100`
          PERFDATA_CRITICAL=`$CMD_EXPR \( $CONSUMABLE_PERCENT_USED \* $CRITICAL \) / 100`
          if [ $CONSUMABLE_PERCENT_USED -gt $CRITICAL ] && [ $CRITICAL != 0 ]; then
            STATE=$STATE_CRITICAL
          elif [ $CONSUMABLE_PERCENT_USED -gt $WARNING ] && [ $WARNING != 0 ]; then
            STATE=$STATE_WARNING
          else
            STATE=$STATE_OK
          fi
        else
          STATE=$STATE_OK
        fi
	fi

	done
	DESCRIPTION="$DESCRIPTION | $PERFORMANCE_DATA"

    fi    

echo $DESCRIPTION
exit $STATE
