#!/opt/motor-sim-epics-ioc/bin/linux-x86_64/motorsim
# -*- container-image: gitregistry.cnpem.br/sol/epicsapps/motor-sim-epics-ioc

cd /opt/motor-sim-epics-ioc/iocBoot/iocmotorsim

< envPaths

epicsEnvSet("IOCNAME", "motorsim")
epicsEnvSet("PREFIX", "TEST:MOTORS:")

dbLoadDatabase("$(TOP)/dbd/motorsim.dbd")
motorsim_registerRecordDeviceDriver(pdbbase)

dbLoadTemplate("motorsim.substitutions", "PREFIX=${PREFIX},VELOCITY=100,BASE_VELOCITY=50")

motorSimCreateController("motorsim1", 20)

#                   port,        axis, lowLimit, highLimit, home, start
motorSimConfigAxis( "motorsim1", 0,    20000,    -20000,     0,    0)
motorSimConfigAxis( "motorsim1", 1,    20000,    -20000,     0,    0)
motorSimConfigAxis( "motorsim1", 2,    20000,    -20000,     0,    0)
motorSimConfigAxis( "motorsim1", 3,    20000,    -20000,     0,    0)
motorSimConfigAxis( "motorsim1", 4,    20000,    -20000,     0,    0)
motorSimConfigAxis( "motorsim1", 5,    20000,    -20000,     0,    0)
motorSimConfigAxis( "motorsim1", 6,    20000,    -20000,     0,    0)
motorSimConfigAxis( "motorsim1", 7,    20000,    -20000,     0,    0)
motorSimConfigAxis( "motorsim1", 8,    20000,    -20000,     0,    0)
motorSimConfigAxis( "motorsim1", 9,    20000,    -20000,     0,    0)
motorSimConfigAxis( "motorsim1", 10,   20000,    -20000,     0,    0)
motorSimConfigAxis( "motorsim1", 11,   20000,    -20000,     0,    0)
motorSimConfigAxis( "motorsim1", 12,   20000,    -20000,     0,    0)
motorSimConfigAxis( "motorsim1", 13,   20000,    -20000,     0,    0)
motorSimConfigAxis( "motorsim1", 14,   20000,    -20000,     0,    0)
motorSimConfigAxis( "motorsim1", 15,   20000,    -20000,     0,    0)
motorSimConfigAxis( "motorsim1", 16,   20000,    -20000,     0,    0)
motorSimConfigAxis( "motorsim1", 17,   20000,    -20000,     0,    0)
motorSimConfigAxis( "motorsim1", 18,   20000,    -20000,     0,    0)
motorSimConfigAxis( "motorsim1", 19,   20000,    -20000,     0,    0)

iocInit

motorUtilInit("${PREFIX}")
