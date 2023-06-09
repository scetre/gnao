#!motorSim

< envPaths

epicsEnvSet("EPICS_CA_SERVER_PORT", "5065")

## Register all support components
dbLoadDatabase "$(MOTOR)/dbd/motorSim.dbd"
motorSim_registerRecordDeviceDriver pdbbase

dbLoadTemplate("motor.substitutions")

# Create simulated motors: ( start card , start axis , low limit, high limit, home posn, # cards, # axes to setup)
motorSimCreate( 0, 0, -32000, 32000, 0, 1, 4 )
# Setup the Asyn layer (portname, low-level driver drvet name, card, number of axes on card)
drvAsynMotorConfigure("motorSim1", "motorSim", 0, 4)

motorSimCreateController("motorSim2", 8)
#asynSetTraceIOMask("motorSim2", 0, 4)
#asynSetTraceMask("motorSim2", 0, 255)

# motorSimConfigAxis(port, axis, lowLimit, highLimit, home, start)
motorSimConfigAxis("motorSim2", 0, 20000, -20000,  500, 0)
motorSimConfigAxis("motorSim2", 1, 20000, -20000, 1500, 0)
motorSimConfigAxis("motorSim2", 2, 20000, -20000, 2500, 0)
motorSimConfigAxis("motorSim2", 3, 20000, -20000, 3000, 0)

iocInit
