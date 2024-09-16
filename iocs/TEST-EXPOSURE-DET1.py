#!/usr/bin/env python

import functools
import time

import numpy as np

from ophyd import Device, Component as Cpt, EpicsMotor

from softioc import softioc, builder, asyncio_dispatcher
import asyncio


dispatcher = asyncio_dispatcher.AsyncioDispatcher()
builder.SetDeviceName("TEST:DET1")

def on_trigger(rbv, data, exposure_time_rbv, val):
    if val != 1 or rbv.get() == 1:
        return
    rbv.set(1)


    exposure_time = exposure_time_rbv.get()
    dead_time = 0
    time.sleep(exposure_time + dead_time)
    data.set(np.random.normal())

    rbv.set(0)


data_rbv = builder.aIn('Data_RBV', initial_value=0, PREC=3)
data = builder.aOut('Data', initial_value=0, PREC=3)

exposure_time_rbv = builder.aIn('ExposureTime_RBV', initial_value=0.1, PREC=2, EGU='s', LOPR=0.1, HOPR=10)
exposure_time = builder.aOut('ExposureTime', initial_value=0.1, PREC=2, EGU='s', DRVL=0.1, DRVH=10, on_update=lambda val: exposure_time_rbv.set(val))

trigger_rbv = builder.boolIn('Trigger_RBV', initial_value=0)
trigger = builder.boolOut('Trigger', initial_value=0, always_update=True,
                    on_update=functools.partial(on_trigger, trigger_rbv, data_rbv, exposure_time_rbv))


builder.LoadDatabase()
softioc.iocInit(dispatcher)

softioc.interactive_ioc(globals())