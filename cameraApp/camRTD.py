#!/usr/bin/env python3

from epics import *
import numpy as np
import sys
import time
import matplotlib.pyplot as plt

if __name__ == '__main__':
    imCa = PV('GNAO:NGS:SLOW_WFS:image1:ArrayData')
    im = np.array(imCa.get())
    # assume square image
    imageSizeX = int(np.sqrt(im.shape[0]))
    imageSizeY = int(np.sqrt(im.shape[0]))

    plt.ion()
    fig = plt.figure()
    ax = fig.add_subplot(111)
    a=plt.imshow(im.reshape(imageSizeX,imageSizeY))
    plt.colorbar()
    plt.show()
    while True:
        im = np.array(imCa.get()).reshape(imageSizeX,imageSizeY)
        dmax=im.max()
        a.set_data(im)
        #a.set_clim(0,dmax)
        fig.canvas.draw()
        fig.canvas.flush_events()
        time.sleep(0.05)
