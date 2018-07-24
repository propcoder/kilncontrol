#!/usr/bin/env python
#
#   Copyright 2012 Jonas Berg, 2017 Marius Alksnys
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#

"""

.. moduleauthor:: Marius Alksnys <marius.alksnys@gmail.com>

Driver for the PixsysATR620 process controller, for communication via the Modbus RTU protocol.

"""

import minimalmodbus

__author__  = "Jonas Berg, Marius Alksnys"
__email__   = "marius.alksnys@gmail.com"
__license__ = "Apache License, Version 2.0"


class PixsysATR620( minimalmodbus.Instrument ):
    """Instrument class for Pixsys ATR620 process controller. 
    
    Communicates via Modbus RTU protocol (via RS232 or RS485), using the *MinimalModbus* Python module.    

    Args:
        * portname (str): port name
        * slaveaddress (int): slave address in the range 1 to 247

    Implemented with these function codes (in decimal):
        
    ==================  ====================
    Description         Modbus function code
    ==================  ====================
    Read registers      3
    Write registers     16
    ==================  ====================

    """
    
    def __init__(self, portname, slaveaddress):
        minimalmodbus.Instrument.__init__(self, portname, slaveaddress)
        self.pv1 = 0.0
        self.pv2  = 0.0
        self.ambient = 0.0
        self.op1 = 0.0
        self.op2 = 0.0
        self.sp1 = 0.0
        self.sp2 = 0.0
        
    ## Process value
    def get_pv_loop1(self):
        """Return the process value (PV) for loop1."""
        tmp = self.read_register(1, 1, 3, signed=True)
        _checkValue(tmp, -60.0, 1500.0, 'pv1')
        return tmp
    
    def get_pv_loop2(self):
        """Return the process value (PV) for loop2."""
        tmp = self.read_register(2, 1, 3, signed=True)
        _checkValue(tmp, -60.0, 1500.0, 'pv2')
        return tmp
    
    def get_ambient_temperature(self):
        """Return the ambient temperature."""
        tmp = self.read_register(3, 1, 3, signed=True)
        _checkValue(tmp, -60.0, 150.0, 'amb')
        return tmp
    
    ## Output signal
    def get_op_loop1(self):
        """Return the output value (OP) for loop1 (in %)."""
        tmp = self.read_register(4, 2)
        _checkValue(tmp, 0.0, 100.0, 'op1')
        return tmp
   
    def get_op_loop2(self):
        """Return the output value (OP) for loop2 (in %)."""
        tmp = self.read_register(5, 2)
        _checkValue(tmp, 0.0, 100.0, 'op2')
        return tmp
    
    ## Setpoint
    def get_sp_loop1(self):
        """Return setpoint (SP) for loop1."""
        tmp = self.read_register(6, 0, 3, signed=True)
        _checkValue(tmp, -60.0, 1500.0, 'sp1')
        return tmp
    
    def get_sp_loop2(self):
        """Return setpoint (SP) for loop2."""
        tmp = self.read_register(7, 0, 3, signed=True)
        _checkValue(tmp, -60.0, 1500.0, 'sp1')
        return tmp

    def get_rem_sp(self):
        """Return remote setpoint."""
        tmp = self.read_register(8, 0, 3, signed=True)
        _checkValue(tmp, -60.0, 1500.0, 'rem_sp')
        return tmp
    
    def get_ser_sp_loop1(self):
        """Return the serial setpoint (SP) for loop1."""
        tmp = self.read_register(9, 0, 3, signed=True)
        _checkValue(tmp, -60.0, 1500.0, 'ser_sp1')
        return tmp
    
    def get_ser_sp_loop2(self):
        """Return the serial setpoint (SP) for loop2."""
        tmp = self.read_register(10, 0, 3, signed=True)
        _checkValue(tmp, -60.0, 1500.0, 'ser_sp2')
        return tmp
    
    def set_ser_sp_loop1(self, value):
        """Set the SP1 for loop1.
        Args:
            value (float): Setpoint (in degrees)
        """
        value = round(value)
        _checkValue(value, -60.0, 1500.0, 'set_ser_sp1')
        self.write_register(9, value, 0, 16, signed=True)
        
    def set_ser_sp_loop2(self, value):
        """Set the SP2 for loop1.
        Args:
            value (float): Setpoint (in degrees)
        """
        value = round(value)
        _checkValue(value, -60.0, 1500.0, 'set_ser_sp2')
        self.write_register(10, value, 0, 16, signed=True)
        
        
    def get_main_values(self):
        """Get main values."""
        tmp = self.read_registers(1, 7)
        self.pv1 = itc(tmp[0]) / 10.0
        self.pv2 = itc(tmp[1]) / 10.0
        self.ambient = itc(tmp[2]) / 10.0
        self.op1 = tmp[3] / 100.0
        self.op2 = tmp[4] / 100.0
        self.sp1 = itc(tmp[5])
        self.sp2 = itc(tmp[6])
        _checkValue(self.pv1, -60.0, 1500.0, 'pv1')
        _checkValue(self.pv2, -60.0, 1500.0, 'pv2')
        _checkValue(self.ambient, -60.0, 150.0, 'amb')
        _checkValue(self.op1, 0.0, 100.0, 'op1')
        _checkValue(self.op2, 0.0, 100.0, 'op2')
        _checkValue(self.sp1, -60.0, 1500.0, 'sp1')
        _checkValue(self.sp2, -60.0, 1500.0, 'sp2')
        
    ## Read/write a parameter
    def get_parameter(self, param):
        """Read parameter value."""
        _checkParameterNumber(param)
        return self.read_register(param + 20, 0)
    
    def set_parameter(self, param, value):
        """Write parameter value."""
        _checkParameterNumber(param)
        self.write_register(param + 20, int(value))
    
    ### Auto/manual mode
    #def is_manual_loop1(self):
        #"""Return True if loop1 is in manual mode."""
        #return self.read_register(??, ?) > 0
        
    def set_serial_control(self):
        """Enable serial remote control, disable all cycles for the operator."""
        tmp = self.read_register(21)
        self.write_register(21, int(tmp / 10) * 10)
        tmp = self.read_register(25)
        self.write_register(25, int(tmp / 10) * 10 + 1)
        
    def set_manual_control(self):
        """Enable all cycles for the operator, disable serial remote control."""
        tmp = self.read_register(21)
        self.write_register(21, int(tmp / 10) * 10 + 9)
        #tmp = self.read_register(25)
        #self.write_register(25, int(tmp / 10) * 10)
        
    def get_is_control_manual(self):
        return self.read_register(21) % 10
    
    ## Run and stop the controller
    def run(self):
        """Start via serial communication, must be repeated at least every 8 seconds."""
        self.write_register(15, 1)

    def run_sp(self, sp_loop1, sp_loop2):
        """Send periodic run signal and set the SP1, SP2 for loops.
        Args:
            sp_loop1, sp_loop2 (float): Setpoints (in degrees)
        """
        sp_loop1 = round(sp_loop1)
        sp_loop2 = round(sp_loop2)
        _checkValue(sp_loop1, -60.0, 1500.0, 'run_sp1')
        _checkValue(sp_loop2, -60.0, 1500.0, 'run_sp2')
        self.write_registers(9, [tc(sp_loop1), tc(sp_loop2), 0, 0, 0, 0, 1])
    
    def stop(self):
        """Stop running process via serial communication."""
        self.write_register(15, 0)

    def is_running(self):
        """Return True if the controller is running."""
        return self.read_register(15) == 1

def tc(x):
    '''Calculates a two's complement integer'''
    x = int(x)
    if x >= 0:
        return x
    return x + 2 ** 16

def itc(x):
    '''Calculates an inverse two's complement integer'''
    x = int(x)
    if x <= 32767:
        return x
    return x - 2 ** 16

#def twos_complement(input_value, num_bits):
    #'''Calculates a two's complement integer from the given input value's bits'''
    #mask = 2**(num_bits - 1)
    #return -(input_value & mask) + (input_value & ~mask)

def _checkSetpointValue( setpointvalue, maxvalue ):   
    """Check that the given setpointvalue is valid.
    
    Args:
        * setpointvalue (numerical): The setpoint value to be checked. Must be positive.
        * maxvalue (numerical): Upper limit for setpoint value. Must be positive.
        
    Raises:
        TypeError, ValueError
    
    """
    if maxvalue is None:
        raise TypeError('The maxvalue (for the setpoint) must not be None!')
    minimalmodbus._checkNumerical(setpointvalue, minvalue=0, maxvalue=maxvalue, description='setpoint value')
    
def _checkValue( value, minvalue, maxvalue, description ):   
    """Check that the given value is valid.
    
    Args:
        * value (numerical): The value value to be checked. Must be positive.
        * maxvalue (numerical): Upper limit for value value. Must be positive.
        
    Raises:
        TypeError, ValueError
    
    """
    if maxvalue is None:
        raise TypeError('The maxvalue (for the {}) must not be None!'.format(description))
    minimalmodbus._checkNumerical(value, minvalue, maxvalue, description)

def _checkParameterNumber( paramnumber ):
    """Check that the given  stepumber is valid.
    
    Args:
        * paramnumber (int): The paramnumber to be checked.
        
    Raises:
        TypeError, ValueError
    
    """
    # Exceptions - parameters: 4, 24, 32, 33, 34, 52(!)
    minimalmodbus._checkInt(paramnumber, minvalue=1, maxvalue=52, description='parameter number') 
    
########################
## Testing the module ##
########################

if __name__ == '__main__':

    minimalmodbus._print_out( 'TESTING PIXSYS ATR620 MODBUS MODULE')

    PORTNAME = '/dev/ttyUSB0'
    ADDRESS = 2
    
    minimalmodbus._print_out( 'Port: ' +  str(PORTNAME) + ', Address: ' + str(ADDRESS) )
    
    a = PixsysATR620(PORTNAME, ADDRESS)
    a.debug = False
    
    minimalmodbus._print_out( 'SP1:                    {0}'.format(  a.get_sp_loop1()             ))
    #minimalmodbus._print_out( 'SP1 target:             {0}'.format(  a.get_sptarget_loop1()       ))
    minimalmodbus._print_out( 'SP2:                    {0}'.format(  a.get_sp_loop2()             ))
    minimalmodbus._print_out( 'OP1:                    {0}%'.format( a.get_op_loop1()             ))
    minimalmodbus._print_out( 'OP2:                    {0}%'.format( a.get_op_loop2()             ))
    #minimalmodbus._print_out( 'Manual mode Loop1:      {0}'.format(  a.is_manual_loop1()          ))
    minimalmodbus._print_out( 'PV1:                    {0}'.format(  a.get_pv_loop1()             ))
    minimalmodbus._print_out( 'PV2:                    {0}'.format(  a.get_pv_loop2()             ))
    minimalmodbus._print_out( 'Ambient temp.:          {0}'.format(  a.get_ambient_temperature()  ))
    minimalmodbus._print_out( 'Parameter 5:            {0}'.format(  a.get_parameter(5)  ))

    #a.set_sprate_loop1(30)
    #a.enable_sprate_loop1() 

    minimalmodbus._print_out( 'DONE!' )

pass    
