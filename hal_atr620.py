#!/usr/bin/env python
import hal, sys, time
import pixsysatr620
import serial

h = hal.component("hal_atr620")

PORTNAME = sys.argv[1]

Instr = []

i = 0
if (len(sys.argv) > 2):
    for address in sys.argv[2:]:
        i += 1
        try:
            Instr.append(pixsysatr620.PixsysATR620(PORTNAME, int(address))) # TODO: enable startup without existing serial port and instrument
            instr = Instr[i - 1]
            instr.h_pv1 = h.newpin("k{0}.pv1".format(i), hal.HAL_FLOAT, hal.HAL_OUT)
            instr.h_pv2 = h.newpin("k{0}.pv2".format(i), hal.HAL_FLOAT, hal.HAL_OUT)
            instr.h_ambient = h.newpin("k{0}.ambient".format(i), hal.HAL_FLOAT, hal.HAL_OUT)
            instr.h_op1 = h.newpin("k{0}.op1".format(i), hal.HAL_FLOAT, hal.HAL_OUT)
            instr.h_op2 = h.newpin("k{0}.op2".format(i), hal.HAL_FLOAT, hal.HAL_OUT)
            instr.h_sp1 = h.newpin("k{0}.sp1".format(i), hal.HAL_FLOAT, hal.HAL_OUT)
            instr.h_sp2 = h.newpin("k{0}.sp2".format(i), hal.HAL_FLOAT, hal.HAL_OUT)
            instr.h_ok = h.newpin("k{0}.ok".format(i), hal.HAL_BIT, hal.HAL_OUT)
            instr.h_run = h.newpin("k{0}.run".format(i), hal.HAL_BIT, hal.HAL_IN)
            instr.h_ser_sp = h.newpin("k{0}.ser-sp".format(i), hal.HAL_FLOAT, hal.HAL_IN)
            instr.h_debug = h.newpin("k{0}.debug".format(i), hal.HAL_S32, hal.HAL_OUT)
            
            #instr.serial.port = str(PORTNAME) # this is the serial port name
            #instr.serial.baudrate = 19200   # Baud
            #instr.serial.bytesize = 8
            #instr.serial.parity   = serial.PARITY_NONE
            #instr.serial.stopbits = 1
            instr.serial.timeout  = 0.1 # 0.05   # seconds
            #instr.address     # this is the slave address number
            #instr.mode = 'rtu'   # rtu or ascii mode
            #instr.debug = True
            #instr.ok = property(lambda: None)
            instr.old_run = False

        except IOError:
            print()
            print('Failed to init instrument number {0}, modbus address {1}'.format(i, address))

h.ready()
run = False

def stop_all():
    try: # turn instruments off and set mode to manual before exiting
        for instr in Instr:
            instr.stop()
            instr.set_manual_control()
            instr.set_ser_sp_loop1(0)
            instr.set_ser_sp_loop2(0)
    except:
        pass
    raise SystemExit
    
while 1:
    try:
        time.sleep(0.95) # TODO:
        err_count = 0
        i = 0
        for instr in Instr:
            i += 1
            ok = False
            try:
                instr.get_main_values()
                run = instr.h_run.value
                if run:
                    tmp = instr.old_run # Safety. Off is assumed safer
                    instr.old_run = True
                    if not tmp and instr.get_is_control_manual():
                        instr.set_serial_control()
                    instr.old_run = True
                    tmp = instr.h_ser_sp.value
                    instr.run_sp(tmp, tmp)
                else: # turn instrument off and set mode to manual
                    if instr.old_run:
                        instr.stop()
                        instr.set_manual_control()
                        instr.set_ser_sp_loop1(0)
                        instr.set_ser_sp_loop2(0)
                        instr.old_run = False # Safety. Off is assumed safer
                ok = True
            except IOError:
                pass
                #print("IOError getting main values or in serial control for instr. {0}, address {1}.".format(i, instr.address))
            except ValueError:
                pass
                #print("ValueError getting main values or in serial control for instr. {0}, address {1}.".format(i, instr.address))
            except KeyboardInterrupt:
                stop_all()
            if ok:
                instr.h_pv1.value = instr.pv1
                instr.h_pv2.value = instr.pv2
                instr.h_ambient.value = instr.ambient
                instr.h_op1.value = instr.op1
                instr.h_op2.value = instr.op2
                instr.h_sp1.value = instr.sp1
                instr.h_sp2.value = instr.sp2
                instr.h_ok.value = ok
            else:
                err_count += 1
                instr.h_pv1.value = 0
                instr.h_pv2.value = 0
                instr.h_ambient.value = 0
                instr.h_op1.value = 0
                instr.h_op2.value = 0
                instr.h_sp1.value = 0
                instr.h_sp2.value = 0
                instr.h_ok.value = 0
                if err_count == len(Instr):
                    try:
                        if instr.serial.isOpen():
                            instr.serial.close()
                        instr.serial.open()
                    except serial.serialutil.SerialException as e:
                        print('SerialException error({0}): {1}'.format(e.errno, e.strerror))
                        pass
                    except KeyboardInterrupt:
                        stop_all()
            instr.h_debug.value = instr.h_debug.value + 1;
    except KeyboardInterrupt:
        stop_all()
