#!/usr/bin/python
# encoding: utf-8
"""
hal_store.py

Modified by Marius Alksnys on 2017-06-04
derived from hal_storage.py (2015-01-03) by Alexander Rössler.
"""

import time
import sys
import os
import argparse

import ConfigParser

import hal


class Pin:
    def __init__(self):
        self.halPin = 0
        self.halName = ''
        self.section = ''
        self.name = ''
        self.lastValue = 0.0
        
        
def savePins(cfg, filename, section, pins):
    for pin in pins:
        cfg.set(str(int(section)), pin.name, str(pin.halPin.value))
    with open(filename, 'w') as f:
        cfg.write(f)
        f.close()
        
        
def readPins(cfg, filename, section, pins):
    cfg.read(filename)
    for pin in pins:
        pin.lastValue = float(cfg.get(str(int(section)), pin.name))
        pin.halPin.value = pin.lastValue
        
parser = argparse.ArgumentParser(description='HAL component to store and load values')
parser.add_argument('-n', '--name', help='HAL component name', required=True)
parser.add_argument('-f', '--file', help='Filename to store values', required=True)
parser.add_argument('-i', '--interval', help='Update interval', default=1.00)

args = parser.parse_args()

updateInterval = float(args.interval)
filename = args.file
loaded = False

# Create pins
pins = []

if not os.path.isfile(filename):
    sys.stderr.write('Error: File does not exist.\n')
    sys.exit(1)

cfg = ConfigParser.ConfigParser()
cfg.read(filename)
h = hal.component(args.name)
program = cfg.get('program', 'last')
for item in cfg.items(program):
    pin = Pin()
    pin.section = program
    pin.name = item[0]
    pin.halName = item[0].lower()
    pin.halPin = h.newpin(pin.halName, hal.HAL_FLOAT, hal.HAL_IO)
    pins.append(pin)
halProgramPin = h.newpin("program", hal.HAL_U32, hal.HAL_IO)
halProgramPin.value = int(program)
halActualProgramPin = h.newpin("actual_program", hal.HAL_U32, hal.HAL_OUT)
readPins(cfg, filename, program, pins)
halActualProgramPin.value = int(program)
h.ready()

try:
    while (True):
        #readPins(cfg, filename, program, pins)
        #savePins(cfg, filename, program, pins)
        for pin in pins:
            if pin.halPin.value != pin.lastValue:
                pin.lastValue = pin.halPin.value
                savePins(cfg, filename, program, pins)
                
        if program != halProgramPin.value:
            program = halProgramPin.value
            cfg.set('program', 'last', program)
            with open(filename, 'w') as f:
                cfg.write(f)
                f.close()
            readPins(cfg, filename, program, pins)
            halActualProgramPin.value = int(program)
                    
        time.sleep(updateInterval)
except KeyboardInterrupt:
    #savePins(cfg, filename, program, pins)
    print(("exiting HAL component " + args.name))
    h.exit()