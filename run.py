#!/usr/bin/python

import sys
import os
import subprocess
import argparse
import time
from machinekit import launcher
from machinekit import config

os.chdir(os.path.dirname(os.path.realpath(__file__)))

#parser = argparse.ArgumentParser(description='This is the motorctrl demo run script '
                                 #'it demonstrates how a run script could look like '
                                 #'and of course starts the motorctrl demo')
#parser.add_argument('-nc', '--no_config', help='Disables the config server', action='store_true')
#parser.add_argument('-l', '--local', help='Enable local mode only', action='store_true')
#parser.add_argument('-g', '--gladevcp', help='Starts the GladeVCP user interface', action='store_true')
#parser.add_argument('-s', '--halscope', help='Starts the halscope', action='store_true')
#parser.add_argument('-m', '--halmeter', help='Starts the halmeter', action='store_true')
#parser.add_argument('-d', '--debug', help='Enable debug mode', action='store_true')

#args = parser.parse_args()

#if args.debug:
#launcher.set_debug_level(5)

if 'MACHINEKIT_INI' not in os.environ:  # export for package installs

    mkconfig = config.Config()
    os.environ['MACHINEKIT_INI'] = mkconfig.MACHINEKIT_INI

try:
    launcher.check_installation()
    launcher.cleanup_session()  # kill any running Machinekit instances
    launcher.start_realtime()  # start Machinekit realtime environment
    launcher.install_comp('dxlincurve.comp')
    launcher.install_comp('progtime.icomp')
    launcher.load_hal_file('main.hal')  # load the main HAL file
    launcher.register_exit_handler()  # enable on ctrl-C, needs to executed after HAL files
    launcher.ensure_mklauncher()  # ensure mklauncher is started
    launcher.start_process("configserver -n kilncontrol ./ui_mon ./ui_prog ./ui_run")
    while True:
        launcher.check_processes()
        time.sleep(1)
except subprocess.CalledProcessError:
    launcher.end_session()
    sys.exit(1)

sys.exit(0)
