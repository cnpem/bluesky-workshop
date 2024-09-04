#!/usr/bin/env python

import functools
import time

import numpy as np

from ophyd import Device, Component as Cpt, EpicsMotor

from softioc import softioc, builder, asyncio_dispatcher
import asyncio


class SoftIOCMotor(Device):
    y = Cpt(EpicsMotor, "m2")


dispatcher = asyncio_dispatcher.AsyncioDispatcher()
builder.SetDeviceName("TEST:DETECTOR")

soft_ioc_motor = SoftIOCMotor("TEST:MOTORS:", name="Soft IOC Motor")


def on_trigger(rbv, data, acq_num, val):
    if val != 1:
        return

    rbv.set(1)
    soft_ioc_motor.wait_for_connection(timeout=5.0)
    time.sleep(0.2)  # Pretend we're doing something funky
    data.set(soft_ioc_motor.y.user_readback.get() + np.random.normal())
    acq_num.set(acq_num.get() + 1)
    rbv.set(0)


acquisition_number_rbv = builder.longIn('AcquisitionNumber_RBV', initial_value=0)
acquisition_number = builder.longOut('AcquisitionNumber', initial_value=0,
                    on_update=lambda val: acquisition_number_rbv.set(val))

data_rbv = builder.aIn('Data_RBV', initial_value=0)
data = builder.aOut('Data', initial_value=0)

trigger_rbv = builder.boolIn('Trigger_RBV', initial_value=0)
trigger = builder.boolOut('Trigger', initial_value=0, always_update=True,
                    on_update=functools.partial(on_trigger, trigger_rbv, data_rbv, acquisition_number_rbv))

builder.LoadDatabase()
softioc.iocInit(dispatcher)

softioc.interactive_ioc(globals())
