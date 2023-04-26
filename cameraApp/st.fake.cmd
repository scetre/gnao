< envPaths
errlogInit(20000)

dbLoadDatabase("$(TOP)/dbd/ADAravisApp.dbd")
ADAravisApp_registerRecordDeviceDriver(pdbbase)


epicsEnvSet("CAMERA_NAME", "Aravis-Fake-GV01")
# Prefix for all records
epicsEnvSet("PREFIX", "GNAO:LGS:WFS:")

# The port name for the detector
epicsEnvSet("PORT",   "ARV1")
# Really large queue so we can stream to disk at full camera speed
epicsEnvSet("QSIZE",  "2000")   
# The maximum number of time series points in the NDPluginStats plugin
epicsEnvSet("NCHANS", "2048")
# The maximum number of frames buffered in the NDPluginCircularBuff plugin
epicsEnvSet("CBUFFS", "500")
# The search path for database files
epicsEnvSet("EPICS_DB_INCLUDE_PATH", "$(ADCORE)/db:$(ADGENICAM)/db:$(ADARAVIS)/db")
# Define NELEMENTS to be enough for a 512x512 mono16 image
epicsEnvSet("NELEMENTS", "524288")
epicsEnvSet("XSIZE",  "512")
epicsEnvSet("YSIZE",  "512")

# aravisConfig(const char *portName, const char *cameraName, int enableCaching, size_t maxMemory, int priority, int stackSize)
aravisConfig("$(PORT)", "$(CAMERA_NAME)", 0, 0, 0, 0)
asynSetTraceIOMask($(PORT), 0, 2)
#asynSetTraceMask($(PORT), 0, TRACE_ERROR|TRACEIO_DRIVER|TRACE_FLOW)
#asynSetTraceFile($(PORT), 0, "aravisDebug.txt")

# Main database
dbLoadRecords("$(ADARAVIS)/db/aravisCamera.template", "P=$(PREFIX),R=CAM:,PORT=$(PORT)")

epicsEnvSet("GENICAM_DB_FILE", "$(ADGENICAM)/db")
# Load the autogenerated file of GenICam features
dbLoadRecords("$(GENICAM_DB_FILE)", "P=$(PREFIX),R=CAM:,PORT=$(PORT)")

# Create a standard arrays plugin
NDStdArraysConfigure("Image1", 5, 0, "$(PORT)", 0, 0)
# Use this line for 8-bit data only
#dbLoadRecords("$(ADCORE)/db/NDStdArrays.template", "P=$(PREFIX),R=image1:,PORT=Image1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),TYPE=Int8,FTVL=CHAR,NELEMENTS=$(NELEMENTS)")
# Use this line for 8-bit or 16-bit data
dbLoadRecords("$(ADCORE)/db/NDStdArrays.template", "P=$(PREFIX),R=image1:,PORT=Image1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),TYPE=Int16,FTVL=SHORT,NELEMENTS=$(NELEMENTS)")

# Load all other plugins using commonPlugins.cmd
< $(ADCORE)/iocBoot/commonPlugins.cmd
set_requestfile_path("$(ADGENICAM)/GenICamApp/Db")
set_requestfile_path("$(ADARAVIS)/aravisApp/Db")

iocInit()

# save things every thirty seconds
#create_monitor_set("auto_settings.req", 30,"P=$(PREFIX)")
#create_manual_set("ADAutoSaveMenu.req", "P=$(PREFIX), CONFIG=ADAutoSave, CONFIGMENU=1")

