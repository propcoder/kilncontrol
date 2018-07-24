#!/usr/bin/env python
import omegacn7500
import pixsysatr620
from time import sleep

def pixsys(instrument):
    print(instrument)
    print('\n')
    #print('SP1:              {0}'.format(  instrument.get_sp_loop1()             ))
    #print('SP2:              {0}'.format(  instrument.get_sp_loop2()             ))
    print('Serial SP1:       {0}'.format(  instrument.get_ser_sp_loop1()         ))
    print('Serial SP2:       {0}'.format(  instrument.get_ser_sp_loop2()         ))
    print('OP1:              {0}%'.format( instrument.get_op_loop1()             ))
    print('OP2:              {0}%'.format( instrument.get_op_loop2()             ))
    #print('Manual mode Loop1 {0}'.format(  instrument.is_manual_loop1()          ))
    print('PV1:              {0}'.format(  instrument.get_pv_loop1()             ))
    print('PV2:              {0}'.format(  instrument.get_pv_loop2()             ))
    print('Ambient temp.:    {0}'.format(  instrument.get_ambient_temperature()  ))
    print('Is running:       {0}'.format(  instrument.is_running()               ))
    
#def print_pixsys_parameter(k2, param):
    #try:
        #except
    
PORTNAME = '/dev/ttyUSB0'
#print('\nOmega CN7500 process controller')
#ADDRESS = 3

#print('Port: ' +  str(PORTNAME) + ', Address: ' + str(ADDRESS) )

#k3 = omegacn7500.OmegaCN7500(PORTNAME, ADDRESS)
#k3.debug = False

#try:
    #print('Control:                {0}'.format(  k3.get_control_mode()    ))
    #print('SP:                     {0}'.format(  k3.get_setpoint() ))
    #print('PV:                     {0}'.format(  k3.get_pv()       ))
    #print('OP1:                    {0}'.format(  k3.get_output1()  ))   
    #print('Is running:             {0}'.format(  k3.is_running()   ))
    #print('Start pattern:          {0}'.format(  k3.get_start_pattern_no()  ))
#except IOError:
    #print("Failed to read from instrument")


try:
    print('\nPixsys ATR620 process controller')
    ADDRESS = 4
    print('Port: ' +  str(PORTNAME) + ', Address: ' + str(ADDRESS) )

    k2 = pixsysatr620.PixsysATR620(PORTNAME, ADDRESS)
    
    #k2.serial.port = str(PORTNAME) # this is the serial port name
    #k2.serial.baudrate = 19200   # Baud
    #k2.serial.bytesize = 8
    #k2.serial.parity   = serial.PARITY_NONE
    #k2.serial.stopbits = 1
    k2.serial.timeout  = 0.1 # 0.05   # seconds

    #k2.address     # this is the slave address number
    #k2.mode = minimalmodbus.MODE_RTU   # rtu or ascii mode
    
    k2.debug = True
    
    pixsys(k2)
    
    #k2.stop()

except IOError:
    print("Failed to read from instrument")

temp1 = 37.0
temp2 = 0.0

print("Setting serial control..")
try:
    k2.setup_serial_control()
    print('Now in serial control')
    sleep(10)
    print("Running the process..")
    k2.run_sp(temp1, temp2)
    print('running OK')
    sleep(10)
    pixsys(k2)
    print('Stopping the process..')
    k2.stop()
    print('stopped OK')
    print('Setting manual control..')
    k2.setup_manual_control()
    print('Now in manual control')
    sleep(10)
except IOError:
    print("ioerr")
except KeyboardInterrupt:
    print('Received KeyboardInterrupt, stopping and setting manual control')
    try:
        k2.stop()
        k2.setup_manual_control()
    except:
        exit()
    print("Setting manual control..")