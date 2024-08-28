# Sample IOCs

These IOCs provide a very simple punctual detector + motor logic, usable for quick testing.

The IOCs are made to be usable via LNLS's `iocs` script, and the binder micromamba environment is this repository should have all the python dependencies for the test detector to run.

### TEST-MOTOR-SIM

This IOC is a simple simulated motor IOC, with 10 simulated axes (m0...m9), each independent of the others. 

### TEST-DETECTOR

This IOC intends to emulate a simple punctual detector, like a photodiode. The value is updated upon triggering (`put TEST:DETECTOR:Trigger 1`), and
is equal to the current position of the sample (`get TEST:MOTORS:m2`), plus a random value, following a white gaussian noise of zero mean and standard
deviation of `1.0`. Its value is then stored in the RBV PV (`TEST:DETECTOR:Data_RBV`).
