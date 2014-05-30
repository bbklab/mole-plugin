# eyou printer  172.16.100.12
snmpwalk -v 1 -c public 172.16.100.12  > snmp.lst

#HOST-RESOURCES-MIB::hrDeviceType.1 = OID: HOST-RESOURCES-TYPES::hrDevicePrinter
#HOST-RESOURCES-MIB::hrDeviceDescr.1 = STRING: Generic 42BW-4SeriesPCL
#HOST-RESOURCES-MIB::hrDeviceStatus.1 = INTEGER: running(2)
#HOST-RESOURCES-MIB::hrDeviceErrors.1 = Counter32: 0
#HOST-RESOURCES-MIB::hrPrinterStatus.1 = INTEGER: other(1)
#HOST-RESOURCES-MIB::hrPrinterDetectedErrorState.1 = Hex-STRING: 00
