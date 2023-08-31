# TangNano_W5300_TOE_GOWIN README

This is a verilog FSM project for controlling Wiznet W5300 IC using SiPeed TangNano 9k FPGA and TOE Shield board.

### About the project. ###

* Quick summary

   The W5300 chip is a Hardwired TCP/IP embedded Ethernet controller that enables easier internet connection for embedded systems that require high network performance.
   
   [ W5300 IC ](https://docs.wiznet.io/Product/iEthernet/W5300)
   
   Tang nano 9K is a development board based on Gowin GW1NR-9 FPGA chip.
   
   [Tang Nano 9K](https://wiki.sipeed.com/hardware/en/tang/Tang-Nano-9K/Nano-9K.html)
   
   The W5300 TOE Shield is a board that enables high-speed bus communication with the W5300 and ST's Cortex MCU. And Now to an FPGA too :sunglasses:
   
   [Wiznet TOE Shield](https://docs.wiznet.io/Product/iEthernet/W5300/W5300-TOE-Shield)
   
   This repository contains the verilog code to allow communication between W5300 IC and FPGA board based on GoWin device. You need several wires to connect each other.
   A basic PCB board is also included to interface Wiznet TOE shield to the Tang Nano 9k board.
   

### Setup Instructions ###

* Summary of Current Development State

	Tang Nano configures the W5300 IC on TOE Shield upon power up, it first reset the w5300 and send init routine for UDP socket.
	Afterwards, you can send an UDP packet and get response back. 
	
* Summary of set up
	+ The project uses [GOWIN IDE](https://www.gowinsemi.com/en/support/home/)
	+ To setup and install driver for TangNano 9k board you need to follow this [guide](https://wiki.sipeed.com/hardware/en/tang/Tang-Nano-Doc/questions.html)
	+ You need to connect the following signals between TangNano 9k and Wiznet TOE Shield.

	1. Address Bus (10 outputs)   
	2. Data Bus. (8 inputs/outputs)
	3. Control signals /CS, /RD and /WR. (3 outputs)   
	4. Interrupt signal /INT.  (1 input)

	+ [Tang Nano 9K](https://wiki.sipeed.com/hardware/en/tang/Tang-Nano-9K/Nano-9K.html) board has LED, RST, and serial lines connected to FTDI IC.
	
* Configuration
	Use wires or a PCB like the one provided (gerbers) on this repo to connect both boards, check for pin in FPGA by looking at tangnano_toe.cst file and provide different power supply to each board as well.
* Dependencies
	The verilog code that interfaces between FPGA and Wiznet chip has some dependency on the clock used. Timing of Read/Write operations are tuned for Tang Nano 9k board which has a 27MHz clock.
	The serial port settings can be easily change by changing frequency and baudrate.
* Limitations.
  TODO

### TESTING ###

* Using Physical Hardware.   
  You need to power Wiznet TOE Shield from 5V externally. TangNano 9k is not able to provide ~200mA to the TOE board from USB 5V. And you need the USB for Serial Comms as well as loading binary.
* Deployment instructions.  
	1. Connect Tang Nano 9k to USB.
	2. Power Wiznet TOE Shield.
	3. Open Serial Port of Tang Nano FTDI IC and use commands to execute init routine.
	4. After Init routine completes, you can receive data from UDP socket. Make sure you change the MAC and IP addresses as well as PORT number assigned to UDP socket to receive data. Received data will be printed in Serial terminal.
* Using ModelSim.  
	The project can be simulated using [ModelSim](https://www.intel.com/content/www/us/en/software-kit/750368/modelsim-intel-fpgas-standard-edition-software-version-18-1.html). There is a test bench included.

### Acknoledgement ###

 The FSM for controlling the W5300 interface signals was inspired by this [project](https://www.hackster.io/salvador-canas/a-practical-introduction-to-sram-memories-using-an-fpga-ii-a18801), 
 althought original FSM was for an SRAM memory, the module was modified to provide the correct timing and sequence of W5300.
 The serial port low level drivers were based on the example provided by SiPeed Tang Nano 9K [example](https://github.com/sipeed/TangNano-9K-example).
 
