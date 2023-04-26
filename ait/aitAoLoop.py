import epics
import time
import sys
import matplotlib.pyplot as plt

cameraIm = epics.PV("GNAO:LGS:WFS:image1:ArrayData")
dmCmd = epics.PV("GNAO:DM:cmd")

nAct = dmCmd.get().shape[0]
cnt=0
while 1:
    sys.stdout.write('\rLoop Cnt '+str(cnt))
    sys.stdout.flush()
    im=cameraIm.get()
    dmCmd.set()
    time.sleep(0.01)
    cnt = cnt+1

