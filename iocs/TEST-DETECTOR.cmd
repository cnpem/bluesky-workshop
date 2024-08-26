#!/usr/bin/env python

import functools

import numpy as np

from ophyd import Device, Component as Cpt, EpicsMotor

from softioc import softioc, builder, asyncio_dispatcher
import asyncio


class SoftIOCMotor(Device):
    y = Cpt(EpicsMotor, "m2")


dispatcher = asyncio_dispatcher.AsyncioDispatcher()
builder.SetDeviceName("TEST:DETECTOR")

soft_ioc_motor = SoftIOCMotor("TEST:MOTORS:", name="Soft IOC Motor")


def on_trigger(rbv, data, val):
    soft_ioc_motor.wait_for_connection()
    if val == 1:
        data.set(soft_ioc_motor.y.user_readback.get() + np.random.normal())
    rbv.set(val)


data_rbv = builder.aIn('Data_RBV', initial_value=0)
data = builder.aOut('Data', initial_value=0)

trigger_rbv = builder.boolIn('Trigger_RBV', initial_value=0)
trigger = builder.boolOut('Trigger', initial_value=0, always_update=True,
                  on_update=functools.partial(on_trigger, trigger_rbv, data_rbv))

builder.LoadDatabase()
softioc.iocInit(dispatcher)


async def update():
    while True:
        trigger.set(0)
        await asyncio.sleep(1)

dispatcher(update)

softioc.interactive_ioc(globals())
