import epics
import time
import matplotlib.pyplot as plt

lgsFocus = epics.Motor('GNAO:CALIB:LGS:FOCUS')
shutter = epics.Motor('GNAO:SHUTTER:INPUT')
cameraIm = epics.PV("GNAO:NGS:SLOW_WFS:image1:ArrayData")


# Retreive position
print("LGS FOCUS POSITION : "+str(lgsFocus.VAL))
print("SHUTTER FOCUS      : "+str(shutter.VAL))

# Move Motors
lgsFocus.VAL=10
time.sleep(1)
while lgsFocus.DMOV == 0:
    print('LGS Focus Moving...')
    time.sleep(1)
print('Done Moving')

# Acquire an image and display it
im=cameraIm.get()

plt.ion()
plt.figure()
plt.imshow(im.reshape(512,512))
