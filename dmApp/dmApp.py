import time
import threading
from softioc import softioc, builder
import cothread
import numpy as np
import sys
import os

# Needed for au completion...
import rlcompleter, readline
readline.parse_and_bind('tab:complete')

os.environ["EPICS_CA_SERVER_PORT"] = "5066"

class DM(object):
    def __init__(self, nAct):
        self.nAct = nAct
        self.cmdCa = builder.WaveformOut('GNAO:DM:cmd',\
                                    datatype = float,\
                                    initial_value=np.zeros(self.nAct),\
                                    on_update = self.send,\
                                    always_update=True)
        self.posCa = builder.Waveform('GNAO:DM:pos',\
                                    datatype = float,\
                                    initial_value=np.zeros(self.nAct))
    def send(self, val):
        self.posCa.set(val) 


if __name__ == "__main__":
    nAct = 292
    dm=DM(nAct)

    # Create some records
    ai = builder.aIn('AI', initial_value=5)
    ao = builder.aOut('AO', initial_value=12.45, on_update=lambda v: ai.set(v))

    # BUILD IOC
    builder.LoadDatabase()
    softioc.iocInit()
    softioc.interactive_ioc(globals())
