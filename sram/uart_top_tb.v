`timescale 1ns/10ps

`include "uart_top.v"

module uart_top_tb ();

	// Testbench uses a 27 MHz clock
	// Want to interface to 115200 baud UART
	// 27000000 / 115200 = 234 Clocks Per Bit.
	parameter		c_CLOCK_PERIOD_NS = 37;
	parameter		c_CLKS_PER_BIT    = 234;    
	parameter		c_BIT_PERIOD      = 8600;
	localparam		DATA_BUS_WORD_LEN = 100;

	reg				clk;
	reg				reset;
	wire [5:0]		leds;
	wire [9:0]		address_bus;
	wire [7:0]		data_bus;
	reg [7:0]		data_bus_tb;
	reg [7:0]		data_bus_read_tb;
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

	localparam		CASE01 = 0;		// this case exercise the read, it first do a INIT routine, then receive a UDP packet using RECV Interrupt
	localparam		CASE02 = 1;		// this case exercise the send, it go streight to send a UDP packet and then handle the SENDOK interrupt.
	localparam		CASE03 = 2;		// next case here

	reg				enable_wr_decode_s0_ir;
	reg [1:0]		count;

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

	always @(negedge rd)
	begin
		data_bus_tb <= data_bus_16[{data_bus_idx[7:1], nibble}];
		if(nibble == 1'b1) begin
			//last nibble here
			data_bus_idx <= data_bus_idx + 8'd2;    // move to next word
		end
		nibble <= ~nibble;
	end

	always @(negedge wr)
	begin
		if(enable_wr_decode_s0_ir == 1'b1) begin			// This task here is very specific for the UDP send case only, it help to clear the SENDOK interrupt when FPGA writes to SO_IR register
			if(count == 2) begin 
				enable_wr_decode_s0_ir <= 1'b0;
				count <= 0;
			end
			else if(count == 1) begin 
				count <= count + 1;	
				if(data_bus_read_tb == 8'b00010000) begin	// check the value here
					@(posedge clk);
					@(posedge clk);
					int_n_tb <= 1'b1;
				end
			end
			else begin
				count <= count + 1;	
			end
		end
	end

	// assign data in data_bus of w5300 interface to a register in test bench for getting value been written
	assign data_bus_read_tb = !wr ? data_bus : 'hz;
	// assign data_bus of w5300 interface to athe value in data_bus_tb register in test bench for setting value been read.
	assign data_bus = !rd ? data_bus_tb : 'hz;

	// generate the clock
	initial begin
			enable_wr_decode_s0_ir <= 0;
			count <= 0;
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

			test_case = CASE01;					// change here the test case
			@(posedge clk);

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
					nibble <= 1'b0;
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
					@(posedge clk);
					int_n_tb <= 1'b0;
					@(posedge clk);
					@(posedge clk);
					@(posedge clk);
					@(posedge clk);
					@(posedge clk);
					@(posedge clk);
					@(posedge clk);
					@(posedge clk);
					@(posedge clk);
					@(posedge clk);
					int_n_tb <= 1'b1;
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
					enable_wr_decode_s0_ir <= 1'b1;
					count <= 2'd0;
					int_n_tb <= 1'b0;					 
				end
			endcase
		end

	
		uart dut (
				.clk (clk),
				.rst_n (reset),
				.uart_rx (data_in),
				.uart_tx (data_out), 
				.int_n(int_n_tb),
				.led (leds),
				.addr(address_bus),
				.wr(wr),
				.cs(cs),
				.rd(rd),
				.data_bus(data_bus)

		);



endmodule