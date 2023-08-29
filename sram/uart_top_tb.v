`timescale 1ns/10ps

`include "uart_top.v"

module uart_top_tb ();

	// Testbench uses a 27 MHz clock
	// Want to interface to 115200 baud UART
	// 27000000 / 115200 = 234 Clocks Per Bit.
	parameter		c_CLOCK_PERIOD_NS = 37;
	parameter		c_CLKS_PER_BIT    = 234;    
	parameter		c_BIT_PERIOD      = 8600;
	// parameters used in the test bench
	localparam 		PAYLOAD_SIZE = 200;
	localparam 		UDP_PACKET_INFO_SIZE = 8;
	localparam		DATA_BUS_WORD_LEN = 300;		// this has to be able to hold teh data we want to simulate a read
	localparam		CASE01 = 0;		// this case exercise the read, it first do a INIT routine, then receive a UDP packet using RECV Interrupt
	localparam		CASE02 = 1;		// this case exercise the send, it go streight to send a UDP packet and then handle the SENDOK interrupt.
	localparam		CASE03 = 2;		// this test will exercise the loopback mode
	localparam		CASE04 = 3;		// Test the reset here

	reg				clk;
	reg				reset;
	wire [5:0]		leds;
	wire [9:0]		address_bus;
	wire 			toe_mcu_nrst; 
	reg				toe_mcu_nrst_tb;
	wire 			n_mr_mic811_tb;
	wire			w5300_nrst;
	reg				w5300_nrst_tb;
	wire [7:0]		data_bus;
	reg [7:0]		data_bus_tb;
	wire [7:0]		data_bus_read_tb;
	wire			wr;
	wire			rd;
	wire			cs;
	reg				int_n_tb;
	reg				data_in = 1;
	wire			data_out;
	reg				nibble;
	reg [7:0]		data_bus_idx;
	reg [7:0]		data_bus_16 [DATA_BUS_WORD_LEN:0];
	reg [2:0]		test_case;
	reg [7:0]		s0_ir_tb;
	wire [7:0]		address_bus_tb;
	integer			k;
	integer 		sock_rcv_size_reg;

	// Takes in input byte and serializes it 
	task UART_WRITE_BYTE;
		input [7:0] i_Data;
		integer     ii;
		begin
			// Send Start Bit
			data_in <= 1'b0;
			#(c_BIT_PERIOD);
			#1000;
			// Send Data Byte
			for (ii=0; ii<8; ii=ii+1)
				begin
					data_in <= i_Data[ii];
					#(c_BIT_PERIOD);
				end
			// Send Stop Bit
			data_in <= 1'b1;
			#(c_BIT_PERIOD);
		 end
	endtask // UART_WRITE_BYTE

	always @(negedge n_mr_mic811_tb)
	begin
		w5300_nrst_tb <= 1'b0;
		#400000
		w5300_nrst_tb <= 1'b1;
	end

	always @(negedge rd)
	begin
		if(address_bus_tb == 8'h200) begin				// case for read S0_MR0
			data_bus_tb <= 8'h00;						// S0_MR is only written in our design to configure socket for UDP mode.
		end
		else if(address_bus_tb == 8'h201) begin			// case for read S0_MR1
			data_bus_tb <= 8'h02;						// we are always in UDP mode for this test bench so far...
		end
		else begin
			data_bus_tb <= data_bus_16[{data_bus_idx[7:1], nibble}];
			if(nibble == 1'b1) begin
				//last nibble here
				data_bus_idx <= data_bus_idx + 8'd2;    // move to next word
			end
			nibble <= ~nibble;
		end
	end

	always @(negedge wr)
	begin
		if(address_bus_tb == 8'h207) begin				// case for the S0_IR1
			if(data_bus_read_tb == 8'b00010000) begin	// check the value here
				$monitor("Test Bench detect FPGA clear SEND_OK flag in S0_IR t=%3d\n",$time);
				s0_ir_tb <= s0_ir_tb ^ data_bus_read_tb;
				@(posedge clk);
				@(posedge clk);
				if(s0_ir_tb ==8'h00) begin
					int_n_tb <= 1'b1;
					$monitor("Test Bench set /INT HIGH at time t=%3d\n",$time);
				end
			end
			else if(data_bus_read_tb == 8'b00000100) begin
				$monitor("Test Bench detect FPGA clear RECV flag in S0_IR t=%3d\n",$time);
				s0_ir_tb <= s0_ir_tb ^ data_bus_read_tb;
				@(posedge clk);
				@(posedge clk);
				if(s0_ir_tb ==8'h00) begin
					int_n_tb <= 1'b1;
					$monitor("Test Bench set /INT HIGH at time t=%3d\n",$time);
				end
			end
		end
		else if(address_bus_tb == 8'h203) begin			// case for the S0_CR
			if(data_bus_read_tb == 8'h20) begin			// check the value here
				$monitor("FPGA issue SEND command at time t=%3d\n",$time);
				#10000									// let's suppose it takes 10 us to send packet 
				@(posedge clk);
				$monitor("Test Bench set /INT LOW at time t=%3d\n",$time);
				int_n_tb <= 1'b0;
			end
		end
	end

	assign toe_mcu_nrst = toe_mcu_nrst_tb;

	assign w5300_nrst = w5300_nrst_tb;

	assign address_bus_tb = address_bus;
	// assign data in data_bus of w5300 interface to a register in test bench for getting value been written
	assign data_bus_read_tb = !wr ? data_bus : 'hz;
	// assign data_bus of w5300 interface to athe value in data_bus_tb register in test bench for setting value been read.
	assign data_bus = !rd ? data_bus_tb : 'hz;

	// generate the clock
	initial begin
			$display("Init Test Bench\n");
			toe_mcu_nrst_tb <= 1'b1;
			data_bus_idx <= 8'd0;
			clk <= 1'b0;
			int_n_tb <= 1'b1;
			nibble = 1'b1;
			data_bus_16[0] <= 8'h00;
			data_bus_16[1] <= 8'h00;
			forever #(c_CLOCK_PERIOD_NS/2) clk = ~clk;
	end
	
	initial begin
			// Generate the reset
			data_bus_tb = 8'b00000000;
			reset <= 1'b0;
			#10000
			reset <= 1'b1;
			#10000

			test_case = CASE04;					// change here the test case

			case(test_case)
				CASE01:
				begin
					// send a command
					@(posedge clk);
					UART_WRITE_BYTE(8'h61);  // a 
					#100
					@(posedge clk);
					UART_WRITE_BYTE(8'h0D);  // ENTER KEY
					#5000000
					// send 10-bit number for address 
					@(posedge clk);
					UART_WRITE_BYTE(8'h31);   // 1
					#10
					@(posedge clk);           
					UART_WRITE_BYTE(8'h31);   // 1
					#10
					@(posedge clk);
					UART_WRITE_BYTE(8'h30);   // 0
					#10
					@(posedge clk);
					UART_WRITE_BYTE(8'h31);   // 1
					#10
					@(posedge clk);
					UART_WRITE_BYTE(8'h30);   // 0
					#10
					@(posedge clk);
					UART_WRITE_BYTE(8'h30);   // 0
					#10
					@(posedge clk);
					UART_WRITE_BYTE(8'h30);   // 0
					#10
					@(posedge clk);
					UART_WRITE_BYTE(8'h31);   // 1
					#10
					@(posedge clk);
					UART_WRITE_BYTE(8'h30);   // 0
					#10
					@(posedge clk);
					UART_WRITE_BYTE(8'h31);   // 1
					#10
					@(posedge clk);
					UART_WRITE_BYTE(8'h0D);    // ENTER KEY
					#4600000
					@(posedge clk);
					data_bus_idx <= 8'd0;
					nibble <= 1'b0;
					data_bus_16[0] <= 8'h00;
					data_bus_16[1] <= 8'h22;
					// send a command
					@(posedge clk);
					// UART_WRITE_BYTE(8'h62);    // b READ REGISTER
					UART_WRITE_BYTE(8'h63);    // c - INIT ROUTINE CALL
					#100
					@(posedge clk);
					UART_WRITE_BYTE(8'h0D);    // ENTER KEY
					#9000000
					// send a command
					// @(posedge clk);
					// UART_WRITE_BYTE(8'h0D);    // ENTER KEY
					// set the w5300 register contents here for our test bench
					@(posedge clk);
					// nibble <= 1'b0;
					data_bus_idx <= 8'd0;
					// SET size of packet for UDP. UDP length <8> + DATA length
					data_bus_16[0] <= 8'h00;   		// IR_REG0
					data_bus_16[1] <= 8'h01;   		// IR_REG1   Bit 0 is S0_INT
					data_bus_16[2] <= 8'h00;   		// S0_IR_REG0
					data_bus_16[3] <= 8'b00000100;	// S0_IR_REG1   Bit 0 is RECV interrupt					
					data_bus_16[4] <= 8'h00;   		// S0_RX_RSR0
					data_bus_16[5] <= 8'h00;   		// S0_RX_RSR1
					data_bus_16[6] <= 8'h00;   		// S0_RX_RSR2
					data_bus_16[7] <= 8'h12;   		// S0_RX_RSR3   // SIZE = UDP <8> + DATA <10>
					data_bus_16[8] <= 8'hC0;   		// UDP Byte Index 0  UDP DESTINATION IP
					data_bus_16[9] <= 8'hA8;   		// UDP Byte Index 1
					data_bus_16[10] <= 8'h00;   	// UDP Byte Index 2
					data_bus_16[11] <= 8'h01;   	// UDP Byte Index 3
					data_bus_16[12] <= 8'h13;   	// UDP Byte Index 4   UDP DESTINATION PORT  
					data_bus_16[13] <= 8'h88;   	// UDP Byte Index 5
					data_bus_16[14] <= 8'h00;   	// UDP Byte Index 6
					data_bus_16[15] <= 8'h0A;   	// UDP Byte Index 7
					data_bus_16[16] <= 8'h48;   	// DATA Byte Index 0  H
					data_bus_16[17] <= 8'h45;   	// DATA Byte Index 1  E
					data_bus_16[18] <= 8'h4C;   	// DATA Byte Index 2  L
					data_bus_16[19] <= 8'h4C;   	// DATA Byte Index 3  L
					data_bus_16[20] <= 8'h4F;   	// DATA Byte Index 4  O
					data_bus_16[21] <= 8'h20;   	// DATA Byte Index 5
					data_bus_16[22] <= 8'h57;   	// DATA Byte Index 6  W
					data_bus_16[23] <= 8'h4F;   	// DATA Byte Index 7  O
					data_bus_16[24] <= 8'h52;   	// DATA Byte Index 8  R
					data_bus_16[25] <= 8'h4C;   	// DATA Byte Index 9  L
					data_bus_16[26] <= 8'h44;   	// DATA Byte Index 10  D
					data_bus_16[27] <= 8'h0D;   	// DATA Byte Index 11  CR
					data_bus_16[28] <= 8'h00;   	// This is the Read to S0_TX_FSR
					data_bus_16[29] <= 8'h00;   	// This is the Read to S0_TX_FSR1
					data_bus_16[30] <= 8'h08;   	// This is the Read to S0_TX_FSR2, value for 2K free size available in TX FIFOR
					data_bus_16[31] <= 8'h00;   	// This is the Read to S0_TX_FSR3
					@(posedge clk);
					s0_ir_tb <= 8'b00000100;
					int_n_tb <= 1'b0;
				end
				CASE02:
				begin
					// set the w5300 register contents here for our test bench    
					#10000				// 10 us
					@(posedge clk);
					nibble <= 1'b0;
					data_bus_idx <= 8'd0;
					// SET size of free size register
					data_bus_16[0] <= 8'h00;   // S0_TX_FSR0
					data_bus_16[1] <= 8'h00;   // S0_TX_FSR1
					data_bus_16[2] <= 8'h00;   // S0_TX_FSR2
					data_bus_16[3] <= 8'hFF;   // S0_TX_FSR3  
					// SEND TEST COMMAND
					@(posedge clk);
					UART_WRITE_BYTE(8'h64);  // TEST
					#100
					@(posedge clk);
					UART_WRITE_BYTE(8'h0D);  // ENTER KEY   
					#2000				// 2 us 		This time is just for testing the interrupt, not related to the real time it takes to send the UDP packet
					@(posedge clk);
					nibble <= 1'b0;
					data_bus_idx <= 8'd0;
					// IR register
					data_bus_16[0] <= 8'h00;   // IR_REG0
					data_bus_16[1] <= 8'h01;   // IR_REG1 socket 0
					data_bus_16[2] <= 8'h00;   // S0_IR0
					data_bus_16[3] <= 8'b00010000;   // S0_IR1 with SENDOK flag ON
					@(posedge clk);
					int_n_tb <= 1'b0;					 
				end
				CASE03:
				begin
					// set the w5300 register contents here for our test bench
					sock_rcv_size_reg = PAYLOAD_SIZE + UDP_PACKET_INFO_SIZE;
					@(posedge clk);
					nibble <= 1'b0;
					data_bus_idx <= 8'd0;
					// SET size of packet for UDP. UDP length <8> + DATA length
					data_bus_16[0] <= 8'h00;   		// IR_REG0
					data_bus_16[1] <= 8'h01;   		// IR_REG1   Bit 0 is S0_INT
					data_bus_16[2] <= 8'h00;   		// S0_IR_REG0
					data_bus_16[3] <= 8'b00000100;	// S0_IR_REG1   Bit 0 is RECV interrupt					
					data_bus_16[4] <= 8'h00;   		// S0_RX_RSR0
					data_bus_16[5] <= (17'h010000 & sock_rcv_size_reg) >> 16;   // S0_RX_RSR1
					data_bus_16[6] <= (17'hff00 & sock_rcv_size_reg) >> 8;   	// S0_RX_RSR2
					data_bus_16[7] <= (17'h00ff & sock_rcv_size_reg);   		// S0_RX_RSR3   // SIZE = PAYLOAD + PACKET_INFO_SIZE
					data_bus_16[8] <= 8'hC0;   							// UDP Byte Index 0  - UDP DESTINATION IP
					data_bus_16[9] <= 8'hA8;   							// UDP Byte Index 1
					data_bus_16[10] <= 8'h00;   						// UDP Byte Index 2
					data_bus_16[11] <= 8'h01;   						// UDP Byte Index 3
					data_bus_16[12] <= 8'h13;   						// UDP Byte Index 4   - UDP DESTINATION PORT  
					data_bus_16[13] <= 8'h88;   						// UDP Byte Index 5
					data_bus_16[14] <= (16'hff00 & PAYLOAD_SIZE) >> 8;  // UDP Byte Index 6	 - PACKET_LEN
					data_bus_16[15] <= (16'h00ff & PAYLOAD_SIZE);    	// UDP Byte Index 7
					for(k = 0; k < PAYLOAD_SIZE; k = k + 1) begin
						data_bus_16[16+k] <= k;   	// DATA Byte Index 0  H
					end
					k = 16 + PAYLOAD_SIZE;
					data_bus_16[k] <= 8'h00;   	// This is the Read to S0_TX_FSR
					k = k + 1;
					data_bus_16[k] <= 8'h00;   	// This is the Read to S0_TX_FSR1
					k = k + 1;
					data_bus_16[k] <= 8'h08;   	// This is the Read to S0_TX_FSR2, value for 2K free size available in TX FIFOR
					k = k + 1;
					data_bus_16[k] <= 8'h00;   	// This is the Read to S0_TX_FSR3
					k = k + 1;
					@(posedge clk);
					s0_ir_tb <= 8'b00000100;
					// prepare for SEND_OK interrupt handshake simulation
					// FPGA read IR register
					data_bus_16[k] <= 8'h00;   // IR_REG0
					k = k + 1;
					data_bus_16[k] <= 8'h01;   // IR_REG1 socket 0
					k = k + 1;
					data_bus_16[k] <= 8'h00;   // S0_IR0
					k = k + 1;
					data_bus_16[k] <= 8'b00010000;   // S0_IR1 with SENDOK flag ON
					k = k + 1;
					// set interrupt pin low for RECV interrupt
					int_n_tb <= 1'b0;
					$monitor("Test Bench set /INT LOW to simulate reception t=%3d\n",$time);
					@(posedge clk);
					@(posedge int_n_tb);
					@(posedge clk);
					s0_ir_tb <= 8'b00010000;
				end
				CASE04:		// test the reset
				begin
					#10000
					@(posedge clk);
					toe_mcu_nrst_tb <= 1'b0;
					#1000
					toe_mcu_nrst_tb <= 1'b1;
					@(posedge clk);
					@(posedge w5300_nrst_tb);

				end
			endcase
		end

	
		uart dut (
				.clk (clk),
				.rst_n (reset),
				.uart_rx (data_in),
				.uart_tx (data_out),
				.led (leds), 
				.int_n(int_n_tb),
				.toe_mcu_nrst(toe_mcu_nrst),
				.w5300_nrst(w5300_nrst),
				.n_mr_mic811(n_mr_mic811_tb),
				.addr(address_bus),
				.wr(wr),
				.cs(cs),
				.rd(rd),
				.data_bus(data_bus)

		);



endmodule