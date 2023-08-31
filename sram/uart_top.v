module uart(
	input						clk,
	input						rst_n,          // reset pin of tang nano 9k board
	input						user_btn,
	input						uart_rx,
	output						uart_tx,
	output reg [5:0]			led,
	input						int_n,          // /INT pin of w5300
    input                       toe_mcu_nrst,   // MCU reset line of w5300 TOE shield
    input                       w5300_nrst, 	// W5300 /RST line in W5300 shield, this is controlled by MIC811
    output                      n_mr_mic811,    // output to control /MR pin of MIC811 in TOE board
	output wire [9:0]			addr,			// 10-bit Address bus
	output wire					wr,				// write enable
	output wire					rd,				// read enable
	output wire					cs,				// chip enable
	inout wire [7:0]			data_bus		// 8 bit data bus
);


reg 							rw;
wire   			   	 			data_rdy;
wire   							wr_done;
wire 							busy;
wire  							start;
wire [7:0]						data_w2f;           	//  It is the 8-bit registered data retrieved from the W5300 Ethernet (the -w2f suffix stands for W5300 to FPGA
wire [7:0]						data_f2w;             	//  Data to be writteb in the W5300 chip

parameter						CLK_FRE  = 27;			// MHz
parameter						UART_FRE = 115200;		// bps

localparam						IDLE =  0;
localparam						SEND =  1;   
localparam						PROCESS_RX = 2;
localparam						PROCESS_ADDR_READ = 3;
localparam						PROCESS_ADDR_PRINT = 4;
localparam						INIT_ROUTINE = 5;
localparam						W5300_WRITE_REG = 6;
localparam						PROCESS_REG_PRINT = 7;
localparam						PROCESS_REG_READ = 8;
localparam						W5300_ISR_STATE = 9;
localparam						W5300_SOCK_RECV_ISR = 10;
localparam						W5300_READ_SOCK_RECV_SIZE = 11;
localparam						W5300_GET_PACKET_INFO = 12;
localparam						W5300_RECV_STATE = 13;
localparam						W5300_RECV_PROCESS = 14;
localparam						W5300_RECV_COMPLETE = 15;
localparam						W5300_SEND_START = 16;
localparam						W5300_SEND_CHECK_SIZE = 17;
localparam						W5300_READ_SOCK_TMIT_SIZE = 18;
localparam						W5300_SET_DEST_IP_PORT = 19;
localparam						W5300_SEND_ADJ_SND_SIZE = 20;
localparam						W5300_SEND_WRITE_FIFOR = 21;
localparam						W5300_SEND_COMPLETED = 22;
localparam						W5300_SET_WRITE_SIZE = 23;
localparam						W5300_SET_SEND_CMD = 24;
localparam						W5300_LOOPBACK_READ_COMPLETED = 25;
localparam						W5300_FIX_READ_RX_FIFO_AFTER_WRITE_TX_FIFO = 26;
localparam						WAIT_W5300_RST = 27;
localparam						RESET_W5300 = 28;

// These are states used just for testing some stuff
localparam						RECV_TEST_COMPLETED = 50;
localparam						TEST_RESPONSE = 51;				

localparam						CR = 8'b00001101;
localparam						HELP = 8'h68;      			// h
localparam						SET_W5300_ADDR = 8'h61;    	// a
localparam 						READ_W5300_REG = 8'h62;		// b
localparam						INIT_W5300 = 8'h63;      	// c
localparam						TEST = 8'h64;      			// d
localparam						TEST2 = 8'h65;      		// e
localparam						WRITE = 8'h66;     			// f

localparam						ADDRESS_SIZE = 10;
localparam						DATA_SIZE = 8;
localparam						DATA_SIZE_WORD = 16;

localparam						read_1 = 3'd0;
localparam						read_2 = 3'd1;
localparam						read_3 = 3'd2;

// Initialization Sub-States
localparam 						INIT_W5300_1 = 0;
localparam 						INIT_W5300_2 = 1;
localparam 						INIT_W5300_3 = 2;
localparam 						INIT_W5300_4 = 3;
localparam 						INIT_W5300_DONE = 4;
localparam 						INIT_W5300_FAILURE = 5;
// ISR sub-states
localparam 						ISR_GET_IR = 3'd0;
localparam 						ISR_GET_SN_IR = 3'd1;
localparam 						ISR_CLEAR_SN_IR = 3'd2;
localparam 						ISR_JUMP_INTO_RECV = 3'd3;
localparam 						ISR_JUMP_INTO_SEND = 3'd4;
// W5300 COMMON AND SOCKET REGISTER ADDRESSES
localparam 						MR_REG = 10'h000;
localparam 						IR_REG = 10'h002;
localparam 						IMR_REG = 10'h004;
localparam 						SHAR_REG = 10'h008;
localparam 						SHAR2_REG = 10'h00A;
localparam 						SHAR4_REG = 10'h00C;
localparam 						GAR_REG = 10'h010;
localparam 						GAR2_REG = 10'h012;
localparam 						SUBR_REG = 10'h014;
localparam 						SUBR2_REG = 10'h016;
localparam 						SIPR_REG = 10'h018;
localparam 						SIPR2_REG = 10'h01A;
localparam 						IDR_REG = 10'h0FE;
localparam						S0_MR = 10'h200;
localparam						S0_CR = 10'h202;
localparam						S1_MR = 10'h240;
localparam						S1_CR = 10'h242;
localparam						S0_PORTR = 10'h20A;
localparam						S1_PORTR = 10'h24A;
localparam 						S0_SSR = 10'h208;
localparam 						S1_SSR = 10'h248;
localparam 						S0_IMR = 10'h204;
localparam 						S1_IMR = 10'h244;
localparam 						S0_IR = 10'h206;
localparam 						S1_IR = 10'h246;
localparam 						S0_RX_RSR = 10'h228;
localparam 						S1_RX_RSR = 10'h268;
localparam 						S0_RX_RSR2 = 10'h22A;
localparam 						S1_RX_RSR2 = 10'h26A;
localparam 						S0_RX_FIFOR = 10'h230;
localparam 						S1_RX_FIFOR = 10'h270;
localparam 						S0_TX_FIFOR = 10'h22E;
localparam 						S1_TX_FIFOR = 10'h26E;
localparam 						S0_TX_FSR = 10'h224;
localparam 						S1_TX_FSR = 10'h264;
localparam 						S0_TX_FSR2 = 10'h226;
localparam 						S1_TX_FSR2 = 10'h266;
localparam 						S0_TX_DPORTR = 10'h212;
localparam 						S1_TX_DPORTR = 10'h252;
localparam 						S0_TX_DIPR = 10'h214;
localparam 						S1_TX_DIPR = 10'h254;
localparam 						S0_TX_DIPR2 = 10'h216;
localparam 						S1_TX_DIPR2 = 10'h256;
localparam 						S0_TX_WRSR = 10'h220;
localparam 						S1_TX_WRSR = 10'h260;
localparam 						S0_TX_WRSR2 = 10'h222;
localparam 						S1_TX_WRSR2 = 10'h262;

// BIT LOCATION OF INTERRUPT FLAG IN IR REGISTER
localparam 						IPCF = 15;			// Ip Connflict Interrupt
localparam 						DPUR = 14;			// Destination Port Unreachable
localparam 						PPPT = 13;
localparam 						FMTU = 12;
localparam 						S7_INT = 7;
localparam 						S6_INT = 6;
localparam 						S5_INT = 5;
localparam 						S4_INT = 4;
localparam 						S3_INT = 3;
localparam 						S2_INT = 2;
localparam 						S1_INT = 1;
localparam 						S0_INT = 0;

reg [2:0]  						init_w5300_state;
localparam						SOCKET_MODE_OPEN = 0;
localparam						SOCKET_INTERRUPT_MASK = 1;
localparam						SOCKET_PORT = 2;
localparam						SOCKET_READ_SSR = 3;
localparam						SOCKET_WAIT_SSR = 4;

// SOCKET Sn_MR Protocol fields
localparam 					    SN_MR_TCP = {8'h00, 8'h01};
localparam 					    SN_MR_UDP = {8'h00, 8'h02};
localparam 					    SN_MR_CLOSE = {8'h00, 8'h00};
localparam 					    SN_MR_IPRAW = {8'h00, 8'h03};
localparam 					    SN_MR_MACRAW = {8'h00, 8'h04};
localparam 					    SN_MR_PPPOE = {8'h00, 8'h05};
// socket Sn_CR defs
localparam 					    CR_OPEN = {8'h00, 8'h01}; 
localparam 					    CR_LISTEN = {8'h00, 8'h02}; 
localparam 					    CR_CONNECT = {8'h00, 8'h04}; 
localparam 					    CR_DISCON = {8'h00, 8'h08}; 
localparam 					    CR_CLOSE = {8'h00, 8'h10}; 
localparam 					    CR_SEND = {8'h00, 8'h20}; 
localparam 					    CR_SEND_MAC = {8'h00, 8'h21}; 
localparam 					    CR_SEND_KEEP = {8'h00, 8'h22}; 
localparam 					    CR_RECV = {8'h00, 8'h40}; 
// PACKET INFO FOR DIFFERENT PROTOCOLS
// just udp for now
localparam						UDP_PACKET_INFO_LEN = 8'd8;
// definitions for Sn_IR interrupt flags
localparam						PRECV = 7;
localparam						PFAIL = 6;
localparam						PNEXT = 5;
localparam						SEND_OK = 4;
localparam						TIMEOUT = 3;
localparam						RECV = 2;
localparam						DISCON = 1;
localparam						CON = 0;

// Source Ip address
localparam                      SIPR0 = 8'd192;     //192.168.0.7
localparam                      SIPR1 = 8'd168;
localparam                      SIPR2 = 8'd0;
localparam                      SIPR3 = 8'd7;
// Subnet Mask Register
localparam                      SUBR0 = 8'd255;     //255.255.255.0
localparam                      SUBR1 = 8'd255;
localparam                      SUBR2 = 8'd255;
localparam                      SUBR3 = 8'd0;
// Gateway IP address register
localparam                      GAR0 = 8'd192;      //192.168.0.1
localparam                      GAR1 = 8'd168;
localparam                      GAR2 = 8'd0;
localparam                      GAR3 = 8'd1;
// Source Hardware Address register
localparam                      SHAR0 = 8'h00;      //00:08:DC:01:02:03
localparam                      SHAR1 = 8'h08;
localparam                      SHAR2 = 8'hdc;
localparam                      SHAR3 = 8'h01;
localparam                      SHAR4 = 8'h02;
localparam                      SHAR5 = 8'h03;


// MESSAGES FOR SERIAL CONSOLE OUTPUT
parameter 	DATA_NUM_HELP = 62;
reg [ DATA_NUM_HELP * 8 - 1:0] help_data = {8'h0d,8'h0a,"HELP MENU",8'h0d,8'h0a,"<a>set address",8'h0d,8'h0a,"<b>read register",8'h0d,8'h0a,"<c>init w5300",8'h0d,8'h0a};
parameter 	DATA_NUM_READ = 40;
reg [ DATA_NUM_READ * 8 - 1:0] set_address = {8'h0d,8'h0a,"SET ADDRESS",8'h0d,8'h0a,"Enter Address (default:",8'h0d,8'h0a};
parameter 	DATA_NUM_INIT = 61;
reg [ DATA_NUM_INIT * 8 - 1:0] init_data = {8'h0d,8'h0a,"INIT",8'h0d,8'h0a,"Start Init sequence for W5300 ethernet controller",8'h0d,8'h0a};
parameter 	DATA_NUM_INIT_DONE = 26;
reg [ DATA_NUM_INIT_DONE * 8 - 1:0] init_done = {8'h0d,8'h0a,"Init routine completed",8'h0d,8'h0a};
parameter 	DATA_NUM_RECV_DONE = 30;
reg [ DATA_NUM_RECV_DONE * 8 - 1:0] recv_done = {8'h0d,8'h0a,"Recv Socket Data Completed",8'h0d,8'h0a};
parameter 	DATA_NUM_INIT_FAILURE = 23;
reg [ DATA_NUM_INIT_FAILURE * 8 - 1:0] init_fail = {8'h0d,8'h0a,"Init routine failed",8'h0d,8'h0a};
parameter 	DATA_NUM_READ_ADDR = 21;
reg [ DATA_NUM_READ_ADDR * 8 - 1:0] read_addr = {8'h0d,8'h0a,"Entered value is:",8'h0d,8'h0a};
parameter 	DATA_WRONG_ADDR = 21;
reg [ DATA_WRONG_ADDR  * 8 - 1:0] wrong_addr =  {"Wrong Value Entered",8'h0d,8'h0a};
reg [ DATA_WRONG_ADDR  * 8 - 1:0] test_string = {"Hola Mundo Verilogi",8'h0d,8'h0a};
parameter 	READ_VALUE_STR = 16;
reg [ READ_VALUE_STR  * 8 - 1:0] mem_value_hdr = {"Memory Value:",8'h0d,8'h0a};
parameter 	READ_REG_STR = 24;
reg [ READ_REG_STR  * 8 - 1:0] read_reg_hdr = {8'h0d,8'h0a,"Read W5300 Register:",8'h0d,8'h0a};
parameter 	DATA_NUM_TEST = 17;
reg [ DATA_NUM_TEST * 8 - 1:0] send_isr_done = {8'h0d,8'h0a,"SEND ISR DONE",8'h0d,8'h0a};

localparam						MSG_RX_SIZE = 20;	
localparam						MSG_TX_SIZE = 80;	
localparam						MSG_BUF = 128;

reg [7:0]						tx_data;
reg								tx_data_valid;
wire							tx_data_ready;
reg [7:0]						tx_cnt;
wire [7:0]						rx_data;
wire							rx_data_valid;
wire							rx_data_ready;
reg [31:0]						wait_cnt;
reg [7:0]						state;
reg [7:0]						nextstate;
reg [7:0]						ret2state;
reg [7:0]						ret2nextstate;

reg [ADDRESS_SIZE-1:0]			address;
wire [ADDRESS_SIZE-1:0]			address2;
reg [7:0]						read_idx;
wire [15:0]						W5300_16REG_RD;
wire [15:0]						W5300_16REG_WR;
reg [15:0]						data_16bits;
reg [15:0]						w5300_regs [20:0];					// buffer to hold the data when doing register write operations to control w5300 internals not data.
reg [4:0]						reg_cnt;
reg [4:0]						reg_cnt_sent;

reg [7:0]						message [MSG_RX_SIZE - 1:0];
reg [7:0]						message_tx [MSG_TX_SIZE - 1:0];
reg [16:0]						socket_recv_value;
reg [7:0]						message_w5300_rx[MSG_BUF - 1: 0];
reg [7:0]						w5300_rx_index;
reg [7:0]						rx_index;
reg [7:0]						rx_wr_index;
reg [7:0]						msg_size;
integer							i;        
reg								idle_to_next_state;
reg								start_in;	
wire							reg_rdy;
wire							write_done;

reg [2:0]						socket_init_state_udp;
reg [7:0]						init_dly_cnt;
reg [2:0]						init_retry_cnt;
reg [1:0]						get_recv_done;
reg								proc_ether_packet;
reg								get_size_nibble;
reg [2:0]						get_interrupt_socket;
reg [7:0]						dest_ip [3:0];
reg [15:0]						dest_port;
reg [7:0]						src_ip [3:0];
reg [15:0]						src_port;
reg [7:0]						message_w5300_tx[MSG_BUF - 1: 0];
reg [7:0]						tx_wr_index;
reg [16:0]						socket_tmit_send_size;
reg [16:0]						socket_tmit_write_size;
reg [16:0]						socket_tmit_free_size;
reg [7:0]						wait_for_tx_free_space;
reg [1:0]						comms_mode;
reg [3:0]						w5300_packet_info_idx;
reg                             w5300_nrst_ctrl;


// parameters for assigning the communication mode.
localparam 						ETHERNET_SERIAL = 2'd0;		// Ethernet to Serial bridge
localparam						LOOPBACK = 2'd1;			// Loopback mode, received data will be send back to peer. 
localparam						COMMAND_MODE = 2'd2;   		// TODO: This will call a state to process the message according to a protocol.
parameter						COMMS_MODE = LOOPBACK;		// hardwiring this here to test. TODO: There should a serial command to change mode on the flight.


assign rx_data_ready = 1'b1;
assign W5300_16REG_WR = data_16bits;
assign n_mr_mic811 = w5300_nrst_ctrl & toe_mcu_nrst;

// parameter N = 26;

// always @ (posedge clk)
//     if (slow_clk == 26'd50000000) begin
//         countsec <= countsec + 8'b1;
//         slow_clk <= 0;
//     end
//     else begin
//         slow_clk <= slow_clk + 1'b1;
//     end


always@(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
	begin
        w5300_nrst_ctrl <= 1'b1;
		wait_cnt <= 32'd10000;
		wait_for_tx_free_space <= 8'd0;
		socket_tmit_send_size <= 17'd0;
		w5300_packet_info_idx <= 0;
		comms_mode <= COMMS_MODE; 			
		proc_ether_packet <= 1'b0;
		get_size_nibble <= 1'b0;
		rx_wr_index <= 8'd0;
		init_dly_cnt <= 8'd0;
		init_retry_cnt <= 3'd0;
		reg_cnt <= 5'd0;				
		reg_cnt_sent <= 5'd0;
		start_in <= 1'b0;
		idle_to_next_state <= 1'b0;
		led <= ~6'b100000;
		state <= RESET_W5300;
        nextstate <= PROCESS_RX;
		address <= 10'd0;
		tx_cnt <= 8'd0;
		tx_data_valid <= 1'b0;
		rx_index <= 8'd0;
		rw <= 1'd0;
		read_idx <= 8'd0;
	end
	else
	case(state)
		RESET_W5300:
		begin
			if(wait_cnt == 32'd0) begin
				if(w5300_nrst_ctrl == 1'b1) begin
					w5300_nrst_ctrl <= 1'b0;
					wait_cnt <= 32'd100;
				end
				else begin
					w5300_nrst_ctrl <= 1'b1;
					state <= IDLE;
				end
			end
			else begin
				wait_cnt <= wait_cnt - 32'd1;
			end
		end
		IDLE:
		begin
			if(rx_data_valid == 1'b1)
			begin
				message[rx_index] <= rx_data;   // send uart received data
				if(rx_data == CR)	    // assume enter on tabby will send only 0x0d
				begin
					// rx_index <= 8'd0;
					read_idx <= 8'd0;
                    state <= nextstate;
				end
				else begin
					led <= ~rx_data[5:0];
					rx_index <= rx_index + 8'd1;
				end
			end
			else if(int_n == 1'b0)			// if there is a w5300 interrupt we need to service it 
			begin
				state <= W5300_ISR_STATE;				// service the interrupt
				get_interrupt_socket <= ISR_GET_IR;		// Init sub-state is to get IR reg
			end
			else if(w5300_nrst == 1'b0) begin
				state <= WAIT_W5300_RST;
			end
		end
		SEND:
		begin
			tx_data <= message_tx[tx_cnt];
			if(tx_data_valid == 1'b1 && tx_data_ready == 1'b1 && tx_cnt < msg_size - 1)
			begin
				tx_cnt <= tx_cnt + 8'd1; //Send data counter
			end
			else if(tx_data_valid && tx_data_ready)
			begin
				tx_cnt <= 8'd0;
				tx_data_valid <= 1'b0;
				led <= ~6'b010000;
				if(idle_to_next_state == 1'b1)
				begin
					state <= nextstate;
				end
				else
				begin
					rx_index <= 8'd0;
					state <= IDLE;
				end
			end
			else if(~tx_data_valid)
			begin
				tx_data_valid <= 1'b1;
			end
		end
		PROCESS_RX:
		begin
			case(message[0])
			HELP, CR:
			begin
				for(i=0; i < DATA_NUM_HELP ; i = i + 1) begin
                    message_tx[DATA_NUM_HELP - 1 - i] = help_data[i * 8 +: 8];
				end
                msg_size = DATA_NUM_HELP;
				state <= SEND;
                nextstate <= PROCESS_RX;
			end
            SET_W5300_ADDR:
            begin
                for(i=0; i < DATA_NUM_READ ; i = i + 1) begin
                    message_tx[DATA_NUM_READ - 1 - i] = set_address[i * 8 +: 8];
                end
				for(i=0; i < ADDRESS_SIZE ; i = i + 1) begin
                    message_tx[DATA_NUM_READ+i] <= { 7'h18, address[ADDRESS_SIZE - 1 - i]};
                end
				message_tx[DATA_NUM_READ+ADDRESS_SIZE] <= 8'h29;	// adding ) at the end
				for(i=0; i < ADDRESS_SIZE; i = i + 1) begin 
					message[i] <= 8'h00;
				end 
                msg_size <= DATA_NUM_READ+ADDRESS_SIZE+1;
                state <= SEND;
                nextstate <= PROCESS_ADDR_READ;
            end
			WRITE:
			begin
				for(i=0; i < ADDRESS_SIZE ; i = i + 1) begin
					message_tx[i] <= { 7'h18, address[ADDRESS_SIZE - 1 - i]};
				end
				msg_size <= ADDRESS_SIZE;	// ADDRESS_SIZE;
				state <= SEND;
				nextstate <= PROCESS_RX;
			end
			TEST:
			// testing quickly here the UDP send, this will probably go away later - only for test
			begin
				// hardwire here the socket  destination port and ip for testing
				dest_port <= {8'h13, 8'h88};   // Set the destination port for sending UDP packet
				dest_ip[0] <= 8'hC0;
				dest_ip[1] <= 8'hA8;
				dest_ip[2] <= 8'h00;
				dest_ip[3] <= 8'h01;
				// set the message to send 
				message_w5300_tx[0] <= 8'h48;   // DATA Byte Index 0  H
				message_w5300_tx[1] <= 8'h45;   // DATA Byte Index 1  E
				message_w5300_tx[2] <= 8'h4C;   // DATA Byte Index 2  L
				message_w5300_tx[3] <= 8'h4C;   // DATA Byte Index 3  L
				message_w5300_tx[4] <= 8'h4F;   // DATA Byte Index 4  O
				message_w5300_tx[5] <= 8'h20;   // DATA Byte Index 5
				message_w5300_tx[6] <= 8'h57;   // DATA Byte Index 6  W
				message_w5300_tx[7] <= 8'h4F;   // DATA Byte Index 7  O
				message_w5300_tx[8] <= 8'h52;   // DATA Byte Index 8  R
				message_w5300_tx[9] <= 8'h4C;   // DATA Byte Index 9  L
				message_w5300_tx[10] <= 8'h44;   // DATA Byte Index 10  D
				message_w5300_tx[11] <= 8'h0D;   // DATA Byte Index 11  CR
				socket_tmit_send_size <= 17'd12;
				state <= W5300_SEND_START;
				ret2state <= TEST_RESPONSE;
				// ret2nextstate <= PROCESS_RX;	// this is not used in this context
				idle_to_next_state <= 1'b0;
			end
			TEST2:
			begin
				address <= 10'b0000000000;
				data_16bits <= 16'b0000000000000000;
				start_in <= 1'b1;
				rw <= 1'b0;
				if(write_done == 1'b1)
				begin
					start_in <= 1'b0;
					address <= address2;
					state <= IDLE;
                    nextstate <= PROCESS_RX;
				end
			end
			INIT_W5300:
			begin
				// Print message of Init operation and go to init state
                for(i=0; i < DATA_NUM_INIT ; i = i + 1) begin
                    message_tx[DATA_NUM_INIT - 1 - i] = init_data[i * 8 +: 8];
                end
				msg_size <= DATA_NUM_INIT;
				state <= SEND;
				nextstate <= INIT_ROUTINE;			
				idle_to_next_state <= 1'b1;
				init_w5300_state <= INIT_W5300_1;
			end
			READ_W5300_REG:
			begin
                for(i=0; i < READ_REG_STR ; i = i + 1) begin
                    message_tx[READ_REG_STR - 1 - i] = read_reg_hdr[i * 8 +: 8];
                end
				msg_size <= READ_REG_STR;
				state <= SEND;
				nextstate <= PROCESS_REG_READ;
				idle_to_next_state <= 1'b1;
			end
			default:
			begin
				 message[0] <= HELP;
//				 led <= ~6'b001000;
				state <= PROCESS_RX;
			end
			endcase
		end
		WAIT_W5300_RST:
		begin
			if(w5300_nrst == 1'b1) begin
				// state <= IDLE;
				// nextstate <= PROCESS_RX;
				state <= INIT_ROUTINE;
				init_w5300_state <= INIT_W5300_1;
			end
		end
		RECV_TEST_COMPLETED:
		begin
			// Print message of Init operation and go to init state
			for(i=0; i < DATA_NUM_RECV_DONE ; i = i + 1) begin
				message_tx[DATA_NUM_RECV_DONE - 1 - i] = recv_done[i * 8 +: 8];
			end
			msg_size <= DATA_NUM_RECV_DONE;
			state <= SEND;
			nextstate <= IDLE;
		end
		TEST_RESPONSE:
		begin
			for(i=0; i < DATA_NUM_TEST ; i = i + 1) begin
				message_tx[i] <= send_isr_done[i * 8 +: 8];
			end		
			msg_size <= DATA_NUM_TEST;
			state <= SEND; 
			idle_to_next_state = 1'b0;			// make sure this flag is clear if you want to get ito IDLE state and be able to process serial commands.
			nextstate <= PROCESS_RX;
		end
		PROCESS_REG_READ:
		begin
			// read register at location given by address variable value
			if(busy == 1'b0)
			begin
				start_in <= 1'b1;
				rw <= 1'b1;
			end
			if(reg_rdy == 1'b1)
			begin
				start_in <= 1'b0;
				address <= address2;
				if(idle_to_next_state == 1'b1) begin
					state <= nextstate;
				end
				else begin
					idle_to_next_state <= 1'b0;
					state <= PROCESS_REG_PRINT;
				end
			end
		end
		PROCESS_REG_PRINT:
		begin
			message_tx[0] <= 8'h61;	// a
			message_tx[1] <= 8'h64;	// d
			message_tx[2] <= 8'h64;	// d
			message_tx[3] <= 8'h72;	// r
			message_tx[4] <= 8'h65;	// e
			message_tx[5] <= 8'h73;	// s
			message_tx[6] <= 8'h73;	// s
			message_tx[7] <= 8'h3A;	// :
			message_tx[8] <= 8'h20;	// space
			// display the address first
			for(i=0; i < ADDRESS_SIZE ; i = i + 1) begin
                message_tx[9+i] <= { 7'h18, address[ADDRESS_SIZE - 1 - i]};
            end
			message_tx[ADDRESS_SIZE+9] <= 8'h0d;		// cr
			message_tx[ADDRESS_SIZE+10] <= 8'h0a;	// newline
			message_tx[ADDRESS_SIZE+11] <= 8'h72;	// r
			message_tx[ADDRESS_SIZE+12] <= 8'h65;	// e
			message_tx[ADDRESS_SIZE+13] <= 8'h67;	// g
			message_tx[ADDRESS_SIZE+14] <= 8'h20;	// 
			message_tx[ADDRESS_SIZE+15] <= 8'h64;	// d
			message_tx[ADDRESS_SIZE+16] <= 8'h61;	// a
			message_tx[ADDRESS_SIZE+17] <= 8'h74;	// t
			message_tx[ADDRESS_SIZE+18] <= 8'h61;	// a
			message_tx[ADDRESS_SIZE+19] <= 8'h3A;	// :
			message_tx[ADDRESS_SIZE+20] <= 8'h20;	// space
			message_tx[ADDRESS_SIZE+21] <= 8'h0d;	// cr
			message_tx[ADDRESS_SIZE+22] <= 8'h0a;	// newline
			// display the data
			for(i=0; i < DATA_SIZE_WORD ; i = i + 1) begin
				message_tx[ADDRESS_SIZE + 23 + DATA_SIZE_WORD - 1 - i] <= {7'h18, W5300_16REG_RD[i]};
			end
			msg_size <= ADDRESS_SIZE + 22 + DATA_SIZE_WORD;
			state <= SEND;
			nextstate <= IDLE;
		end
		PROCESS_ADDR_READ:
        begin
			for(i=0; i < DATA_NUM_READ_ADDR ; i = i + 1) begin
				message_tx[DATA_NUM_READ_ADDR - 1 - i] <= read_addr[i * 8 +: 8];
				end
			// this section here was not working in modelsim...
			// for(i=0; i < ADDRESS_SIZE ; i = i + 1) begin
			// 	if(message[i][7:1] == 7'h18) begin
			// 		address <= {address[8:0], message[i][0]};
			// 	end
			// end
			address[0] <= message[9][0];
			address[1] <= message[8][0];
			address[2] <= message[7][0];
			address[3] <= message[6][0];
			address[4] <= message[5][0];
			address[5] <= message[4][0];
			address[6] <= message[3][0];
			address[7] <= message[2][0];
			address[8] <= message[1][0];
			address[9] <= message[0][0];
			state <= PROCESS_ADDR_PRINT;
        end
		PROCESS_ADDR_PRINT:
		begin
			for(i=0; i < ADDRESS_SIZE ; i = i + 1) begin
				message_tx[DATA_NUM_READ_ADDR+i] <= { 7'h18, address[ADDRESS_SIZE - 1 - i]};
			end		
			msg_size <= DATA_NUM_READ_ADDR + ADDRESS_SIZE;
			state <= SEND; 
			// idle_to_next_state <= 1'b1;	// this only sets the value and wait for read or write command to follow
			nextstate <= PROCESS_RX;
		end
		INIT_ROUTINE:
		begin
			
			case(init_w5300_state)
			INIT_W5300_1:
			// SET IMR Register
			begin
				idle_to_next_state <= 1'b0;
				init_dly_cnt <= 8'd0;					// Init the counter to create a delay or wait period
				init_retry_cnt <= 3'd0;
				address <= IMR_REG;
				data_16bits <= 16'd0;
				data_16bits[S0_INT] <= 1'b1;			// Configure IMR_REG to get Interrupt on Socket 0
				state <= W5300_WRITE_REG;
				init_w5300_state <= INIT_W5300_2;
			end
			INIT_W5300_2:
			// Set SHAR Register			
			begin
				address <= SHAR_REG;
				data_16bits <= {SHAR0, SHAR1};			// first register is set here
				w5300_regs[0] <= {SHAR2, SHAR3};
				w5300_regs[1] <= {SHAR4, SHAR5};
				reg_cnt <= 5'd2;						// we need to send two more registers
				reg_cnt_sent <= 5'd0;					// Start sending Index 0 of w5300_regs
				state <= W5300_WRITE_REG;
				init_w5300_state <= INIT_W5300_3;
			end
			INIT_W5300_3:
			begin
				// Set GAR, SUBR, SIPR Registers
				address <= GAR_REG;
				data_16bits <= {GAR0, GAR1};
				w5300_regs[0] <= {GAR2, GAR3};
				// since register address are in contiguous address we can keep adding values for Subnet and IP address
				// SUBR register
				w5300_regs[1] <= {SUBR0, SUBR1};
				w5300_regs[2] <= {SUBR2, SUBR3};
				// SIPR register
				w5300_regs[3] <= {SIPR0, SIPR1};
				w5300_regs[4] <= {SIPR2, SIPR3};					
				reg_cnt <= 5'd5;						// we need to send two more registers
				reg_cnt_sent <= 5'd0;					// Start sending Index 0 of w5300_regs
				state <= W5300_WRITE_REG;
				init_w5300_state <= INIT_W5300_4;
				// init counter for init udp socket
				socket_init_state_udp <= SOCKET_MODE_OPEN;
			end
			INIT_W5300_4:
			begin
				case(socket_init_state_udp) 
				SOCKET_MODE_OPEN:
				begin
					address <= S0_MR;
					data_16bits <= SN_MR_UDP;        // Init socket in UDP mode  Sn_MR=0x02
					w5300_regs[0] <= CR_OPEN;        // OPEN socket, Sn_CR = OPEN = 0x01
					reg_cnt <= 5'd1;						// we need to send two more registers
					reg_cnt_sent <= 5'd0;					// Start sending Index 0 of w5300_regs
					state <= W5300_WRITE_REG;
					socket_init_state_udp <= SOCKET_INTERRUPT_MASK;
				end
				SOCKET_INTERRUPT_MASK:
				begin
					// Set S0_IR Register
					address <= S0_IMR;
					data_16bits <= {8'h00, 8'b00010100};		// Enable RECV and SENDOK interrupt for Socket 0
					reg_cnt <= 5'd0;							// only send one register with data contained in data_16bits
					state <= W5300_WRITE_REG;
					socket_init_state_udp <= SOCKET_PORT;
				end
				SOCKET_PORT:
				begin
					address <= S0_PORTR;
					data_16bits <= {8'h13, 8'h88};   // Set the source port for UDP socket
					reg_cnt <= 5'd0;
					state <= W5300_WRITE_REG;
					socket_init_state_udp <= SOCKET_READ_SSR;
				end
				SOCKET_READ_SSR:
				begin
					// configure address and change to read register state
					address <= S0_SSR;  // read socket status register
					state <= PROCESS_REG_READ;
					idle_to_next_state <= 1'b1;  // next state after PROCESS_REG_READ is given by nextstate register
					nextstate <= INIT_ROUTINE;		// need to come back to init routine
					// change to wait state within init routine
					socket_init_state_udp <= SOCKET_WAIT_SSR;
				end	
				SOCKET_WAIT_SSR:
				begin
					if(W5300_16REG_RD[7:0] == 8'h22) begin  // if equal to SOCK_UDP
						init_w5300_state <= INIT_W5300_DONE; // are we done here? 
					end
					else begin		// each count will produce a period delay T = 36 ns
						// 
						if(init_retry_cnt == 3'd2) begin
							init_w5300_state <= INIT_W5300_FAILURE; // are we done here?
						end
						else if(init_retry_cnt == 3'd1) begin
							socket_init_state_udp <= SOCKET_MODE_OPEN;
							// close socket
							address <= S0_CR;
							data_16bits <= CR_CLOSE;
							reg_cnt <= 5'd0;
							state <= W5300_WRITE_REG;
							init_retry_cnt <= init_retry_cnt + 3'd1;
						end
						else begin
							if(init_dly_cnt == 100) begin
								init_retry_cnt <= init_retry_cnt + 3'd1;
								socket_init_state_udp <= SOCKET_READ_SSR;
								init_dly_cnt <= 0;
							end
							else begin
								init_dly_cnt <= init_dly_cnt + 8'd1;
							end
						end
					end
				end
				endcase
			end
			INIT_W5300_DONE:
			begin
				// Print message of Init operation result and go to init state
                for(i=0; i < DATA_NUM_INIT_DONE ; i = i + 1) begin
                    message_tx[DATA_NUM_INIT_DONE - 1 - i] = init_done[i * 8 +: 8];
                end
				msg_size <= DATA_NUM_INIT_DONE;
                idle_to_next_state = 1'b0;			// make sure this flag is clear if you want to get ito IDLE state and be able to process serial commands.
				state <= SEND;
				nextstate <= PROCESS_RX;
			end
			INIT_W5300_FAILURE:
			begin
				// Print message of Init operation result and go to init state
                for(i=0; i < DATA_NUM_INIT_FAILURE ; i = i + 1) begin
                    message_tx[DATA_NUM_INIT_FAILURE - 1 - i] = init_fail[i * 8 +: 8];
                end
				msg_size <= DATA_NUM_INIT_FAILURE;  
                idle_to_next_state = 1'b0;			// make sure this flag is clear if you want to get ito IDLE state and be able to process serial commands.
				state <= SEND;
				nextstate <= PROCESS_RX;
			end
			endcase
		end
		W5300_WRITE_REG:
		begin
			if(busy == 1'b0)
			begin
				start_in <= 1'b1;
				rw <= 1'b0;
			end
			if(write_done == 1'b1)
			begin
				start_in <= 1'b0;
				address <= address2;
				if(reg_cnt == 0) begin
					if(idle_to_next_state == 1'b1) begin
						state <= nextstate;
					end
					else begin
						state <= INIT_ROUTINE;
					end
				end
				else begin
					reg_cnt <= reg_cnt - 1'b1;
					data_16bits <= w5300_regs[reg_cnt_sent];
					reg_cnt_sent <= reg_cnt_sent + 1'b1;		
				end
			end
		end
		W5300_ISR_STATE:
		begin
			if(get_interrupt_socket == ISR_GET_IR) begin
				// get the value of IR register
				get_interrupt_socket <= ISR_GET_SN_IR;		// check for socket interrupt number
				idle_to_next_state <= 1'b1;  		// return to this state after fetching register
				address <= IR_REG;					// interrupt register
				state <= PROCESS_REG_READ;			// PROCESS_REG_READ is the state to read a register
				nextstate <= W5300_ISR_STATE;		// this state
			end
			else if(get_interrupt_socket == ISR_GET_SN_IR) begin
				if(W5300_16REG_RD[0] == 1'b1) begin		// if socket 0 interrupt
					get_interrupt_socket <= ISR_CLEAR_SN_IR;		// start a read on the S0_IR register here
					address <= S0_IR;					// S0_IR address
					idle_to_next_state <= 1'b1;  		// return to this state after fetching register
					state <= PROCESS_REG_READ;			// PROCESS_REG_READ is the state to read a register
					nextstate <= W5300_ISR_STATE;		// this state
				end 
				else begin
					idle_to_next_state <= 1'b0;
					state <= IDLE;
					nextstate <= PROCESS_RX;
				end
			end
			else if(get_interrupt_socket == ISR_CLEAR_SN_IR) begin
				// we should look here at the different interrupts that might be active at the same time
				if(W5300_16REG_RD[RECV] == 1'b1) begin			// if socket 0 RECV interrupt
					// clear the RECV interrupt flag in S0_IR
					address <= S0_IR;
					data_16bits <= {8'h00, 8'b00000100};		// Clear the RECV interrupt
					reg_cnt <= 5'd0;							// only send one register with data contained in data_16bits
					idle_to_next_state <= 1'b1;  				// return to this state after writing register
					state <= W5300_WRITE_REG;					// write state
					nextstate <= W5300_ISR_STATE;				// this state
					get_interrupt_socket <= ISR_JUMP_INTO_RECV;				// jump into RECV ISR after clearing S0_IR RECV flag			
				end
				else if(W5300_16REG_RD[SEND_OK] == 1'b1) begin			// if socket 0 SENDOK interrupt
					// clear the SENDOK interrupt flag in S0_IR
					address <= S0_IR;
					data_16bits <= {8'h00, 8'b00010000};		// Clear the SENDOK interrupt
					reg_cnt <= 5'd0;							// only send one register with data contained in data_16bits
					idle_to_next_state <= 1'b1;  				// return to this state after writing register
					state <= W5300_WRITE_REG;					// write state
					nextstate <= W5300_ISR_STATE;				// this state
					get_interrupt_socket <= ISR_JUMP_INTO_SEND;				// jump into SENDOK ISR after clearing S0_IR RECV flag	
				end
			end
			else if(get_interrupt_socket == ISR_JUMP_INTO_RECV) begin
				get_recv_done <= 2'b0;				// state flag used to signal if register S0_RX_RSR has been read already
				state <= W5300_SOCK_RECV_ISR; 		// service the receive interrupt
			end
			else if(get_interrupt_socket == ISR_JUMP_INTO_SEND) begin
				// the transmit interrupt need to jump to return state configured when jumping to SEND state
				state <= IDLE;  		//ret2state;
				nextstate <= PROCESS_RX; //ret2nextstate;
			end
		end
		W5300_SOCK_RECV_ISR:
		begin 
			if(get_recv_done == 2'd0) begin
				state <= W5300_READ_SOCK_RECV_SIZE;
				get_size_nibble <= 1'b0;
			end
			else if(get_recv_done == 2'd1) begin
				socket_recv_value[15:0] <= W5300_16REG_RD;		// GET full number here for received length
				get_recv_done <= 2'd2;
			end
			else if(get_recv_done == 2'd2) begin	
				get_recv_done <= 2'd3;
				// received length includes the UDP PACKET INFO length but for the SEND command we only set the payload length.
				socket_tmit_send_size <= socket_recv_value - UDP_PACKET_INFO_LEN;	
				if(socket_recv_value[0] == 1'b1) begin
					// here we need to read one dummy register at the end as data size is odd
					socket_recv_value <= socket_recv_value + 17'd1;
				end
			end
			else if(get_recv_done == 2'd3) begin
				if(socket_recv_value != 17'd0) begin
					// move here into a state to process the packet info section of received frame first
					state <= W5300_GET_PACKET_INFO;
					w5300_packet_info_idx <= 0;		// our index here to save the packet info into rx memory
					idle_to_next_state <= 1'b0;
				end
			end
		end
		W5300_READ_SOCK_RECV_SIZE:
		begin
			if(get_size_nibble == 1'b0) begin
				socket_recv_value <= 17'd0;
				get_size_nibble <= 1'b1;
				idle_to_next_state <= 1'b1;  		// return to this state after fetching register
				address <= S0_RX_RSR;				// register contains the received size
				state <= PROCESS_REG_READ;			//PROCESS_REG_READ is the state to read a register
				nextstate <= W5300_READ_SOCK_RECV_SIZE;
			end
			else if(get_size_nibble == 1'b1)begin
				socket_recv_value[16] <= W5300_16REG_RD[0];		// assign the bit 0 of S0_RX_RSR to MSB bit of socket received size
				get_recv_done <= 2'd1;				// move into a state to get full 17 bit number for received length
				idle_to_next_state <= 1'b1;  		// return to this state after fetching register
				address <= S0_RX_RSR2;				// register contains the received size
				state <= PROCESS_REG_READ;			// PROCESS_REG_READ is the state to read a register
				nextstate <= W5300_SOCK_RECV_ISR;				
			end
		end
		W5300_GET_PACKET_INFO:
		begin
			if(w5300_packet_info_idx == UDP_PACKET_INFO_LEN) begin
				// set the destination port and ip from the peer data in MESSAGE-INFO section of RX packet
				src_port <= {message_w5300_rx[4], message_w5300_rx[5]};   // Set the source port of received UDP packet
				src_ip[0] <= message_w5300_rx[0];		// Assign peer ip address to source registers
				src_ip[1] <= message_w5300_rx[1];
				src_ip[2] <= message_w5300_rx[2];
				src_ip[3] <= message_w5300_rx[3];
				w5300_rx_index <= 0; 					// index for received data payload
				idle_to_next_state <= 1'b0;				// important to keep this low to enter W5300_RECV_STATE first time or when reentering
				state <= W5300_RECV_STATE;				// Now that we have already fetch the packet info, go to a state to get the actual UDP payload data.
			end
			else begin
				if(idle_to_next_state == 1'b0) begin	// only 0 when comming here from ISR or need to fetch more data
					address <= S0_RX_FIFOR;				// register contains the received size
					state <= PROCESS_REG_READ;			// PROCESS_REG_READ is the state to read a register
					nextstate <= W5300_GET_PACKET_INFO;		// get rx packet into local memory
					idle_to_next_state <= 1'b1;  		// return to this state after fetching register
				end
				else begin
					// every time here FPGA fetch a WORD from FIFOR and save previous register read
					message_w5300_rx[w5300_packet_info_idx] <= W5300_16REG_RD[15:8];				// MSB of RX FIFO is assigned to lower current index in our buffer
					message_w5300_rx[w5300_packet_info_idx+8'd1] <= W5300_16REG_RD[7:0];			// LSB of RX FIFO is assigned to higher next index in our buffer
					w5300_packet_info_idx <= w5300_packet_info_idx + 4'd2;
					socket_recv_value <= socket_recv_value - 17'd2;									// Packet info length is also included in the total length of received bytes
					if(w5300_packet_info_idx < UDP_PACKET_INFO_LEN - 8'd2) begin				// otherwise remain  in state to save values and move to next state
						// we need to keep extracting data from RX FIFO to read completely the PACKET-INFO header
						address <= S0_RX_FIFOR;								// register contains the received size
						state <= PROCESS_REG_READ;							// PROCESS_REG_READ is the state to read a register
						nextstate <= W5300_GET_PACKET_INFO;					// get rx packet into local memory
						idle_to_next_state <= 1'b1;  						// return to this state after fetching register
					end
				end
			end
		end
		W5300_RECV_STATE:
		begin
			if(socket_recv_value == 17'd0) begin
				// No more bytes left case
				message_w5300_rx[w5300_rx_index] <= W5300_16REG_RD[15:8];
				message_w5300_rx[w5300_rx_index+8'd1] <= W5300_16REG_RD[7:0];
				w5300_rx_index <= w5300_rx_index + 8'd2;
				proc_ether_packet <= 1'b0;				// time to process a new received ethernet packet
				state <= W5300_RECV_PROCESS;
				// rx_wr_index <= 8'd0;			// check if ok to remove
			end
			else begin
				if(idle_to_next_state == 1'b0) begin	// only 0 when comming here from ISR or need to fetch more data
					address <= S0_RX_FIFOR;				// register contains the received size
					state <= PROCESS_REG_READ;			// PROCESS_REG_READ is the state to read a register
					nextstate <= W5300_RECV_STATE;		// get rx packet into local memory
					idle_to_next_state <= 1'b1;  		// return to this state after fetching register
					socket_recv_value <= socket_recv_value - 17'd2;		// need to decrement the total count of bytes received 
				end 
				else begin
					if(w5300_rx_index < MSG_BUF - 2) begin			// we are extracting here two bytes with every access to RX FIFO
						// every time FPGA fetch a WORD from FIFOR
						message_w5300_rx[w5300_rx_index] <= W5300_16REG_RD[15:8];				// MSB of RX FIFO is assigned to lower current index in our buffer
						message_w5300_rx[w5300_rx_index+8'd1] <= W5300_16REG_RD[7:0];			// LSB of RX FIFO is assigned to higher next index in our buffer
						w5300_rx_index <= w5300_rx_index + 8'd2;
						address <= S0_RX_FIFOR;				// register contains the received size
						state <= PROCESS_REG_READ;			// PROCESS_REG_READ is the state to read a register
						nextstate <= W5300_RECV_STATE;		// get rx packet into local memory
						idle_to_next_state <= 1'b1;  		// return to this state after fetching register
						socket_recv_value <= socket_recv_value - 17'd2;
					end
					else begin
						message_w5300_rx[w5300_rx_index] <= W5300_16REG_RD[15:8];				// MSB of RX FIFO is assigned to lower current index in our buffer
						message_w5300_rx[w5300_rx_index+8'd1] <= W5300_16REG_RD[7:0];			// LSB of RX FIFO is assigned to higher next index in our buffer
						w5300_rx_index <= w5300_rx_index + 8'd2;
						proc_ether_packet <= 1'b0;				// time to process a new received ethernet packet
						state <= W5300_RECV_PROCESS;
					end
				end
			end
		end
		W5300_RECV_PROCESS:
		begin
			case(comms_mode)
			ETHERNET_SERIAL:
			begin
				if(proc_ether_packet == 1'b0)
				begin
					// do something here with packets like sending it out of serial port
					if(rx_wr_index > w5300_rx_index) begin				// let's hardwired this for now to test 
						proc_ether_packet <= 1'b1;
						msg_size <= w5300_rx_index;
						tx_cnt <= 8'd0;						// the index for accessing the data in the SEND serial state
						state <= SEND;						// go to the SEND state
						idle_to_next_state <= 1'b1;			// signal that we need to come back to this state
						nextstate <= W5300_RECV_PROCESS;
					end
					else begin 
						message_tx[rx_wr_index] <= message_w5300_rx[rx_wr_index];
						rx_wr_index <= rx_wr_index + 1'b1;
					end
				end
				else if(proc_ether_packet == 1'b1)
				begin
					proc_ether_packet <= 1'b0;
					w5300_rx_index <= 8'd0;
					idle_to_next_state <= 1'b0;		// signal in this state that we need to first fetch before read
					if(socket_recv_value != 17'd0) begin
						rx_wr_index <= 8'd0;		// we need to fetch more data
						state <= W5300_RECV_STATE;
					end
					else begin
						state <= RECV_TEST_COMPLETED;
					end
				end
			end
			LOOPBACK:
			begin
				if(proc_ether_packet == 1'b0)
				begin
					proc_ether_packet <= 1'b1;						// disposition the next step in data processing of data
					socket_tmit_write_size <= w5300_rx_index;		// here w5300_rx_index register should be always even as we are reading WORD from RX FIFO, so no need to adjust transmit size here
					tx_wr_index <= 8'd0;							// make the index 0 for handling the data copying process
					state <= W5300_SEND_WRITE_FIFOR;
					idle_to_next_state <= 1'b0;
				end
				else if(proc_ether_packet == 1'b1)
				begin
					if(socket_recv_value == 17'd0) begin
						// here we have copied all data from RX FIFO into TX FIFO
						// do the final steps for sending the packet , i.e. set size and set SEND command
						address <= S0_CR;
						data_16bits <= CR_RECV;			// set RECV command in S0_CR, will transmit data of size given by S0_TX_WRSR
						reg_cnt <= 5'd0;						
						idle_to_next_state <= 1'b1;
						state <= W5300_WRITE_REG;
						nextstate <= W5300_LOOPBACK_READ_COMPLETED;
					end
					else
					begin
						// we cannot inmediately access RX FIFOR here as we are coming from accessing TX FIFOR
						// so we need to do a read on a register like S0_MR as per suggested in datasheet Sn_RX_FIFOR section page 89
						// configure address and change to read register state
						address <= S0_MR;  // read socket status register
						state <= PROCESS_REG_READ;
						idle_to_next_state <= 1'b1;  // next state after PROCESS_REG_READ is given by nextstate register
						nextstate <= W5300_FIX_READ_RX_FIFO_AFTER_WRITE_TX_FIFO;		// need to come back to init routine
					end
				end
			end
			default:
			begin
				// TODO

			end
			endcase
		end
		W5300_FIX_READ_RX_FIFO_AFTER_WRITE_TX_FIFO:
		begin
			// there is still data in the RX FIFO of W5300 that we need to fetch
			state <= W5300_RECV_STATE;
			proc_ether_packet <= 1'b0;		// next time we return to this step after receivimg more RX FIFO data we need to send it back
			w5300_rx_index <= 8'd0;			// our index register for the w5300 rx memory			
			idle_to_next_state <= 1'b0;		// signal in this state that we need to first fetch before read
		end
		W5300_LOOPBACK_READ_COMPLETED:
		begin
			// socket_tmit_send_size already should have the data length to send
			state <= W5300_SEND_START;
			ret2state <= IDLE;
			// ret2nextstate <= PROCESS_RX;	// ?????
			idle_to_next_state <= 1'b0;
		end
		W5300_SEND_START:									
		// before moving to this state idle_to_next_state need to be zero and the calling state should be saved to ret2state
		// For this state we need to have setup the Destination IP and Destination PORT in our registers, i.e.
		// dest_port <= {8'h13, 8'h88}; // Set the destination port for UDP socket
		// 
		begin
			if(idle_to_next_state == 1'b0) begin
				get_size_nibble <= 1'b0;
				state <= W5300_READ_SOCK_TMIT_SIZE;
			end
			else if(idle_to_next_state == 1'b1) begin
				socket_tmit_free_size[15:0] <= W5300_16REG_RD;		// GET full number here for available transmit length in memory
				wait_for_tx_free_space <= 8'd0;
				state <= W5300_SEND_CHECK_SIZE;
			end
		end
		W5300_SEND_CHECK_SIZE:
		begin 
			if(socket_tmit_free_size < socket_tmit_send_size) begin
				if(wait_for_tx_free_space == 100) begin
					get_size_nibble <= 1'b0;
					state <= W5300_READ_SOCK_TMIT_SIZE;		// if there is no available space keep querying the size
				end
				else
				begin
					wait_for_tx_free_space <= wait_for_tx_free_space + 8'd1;
				end
			end 
			else 
			begin
				state <= W5300_SET_DEST_IP_PORT;
				idle_to_next_state <= 1'b0; 
				get_size_nibble <= 1'b0;
			end
		end
		W5300_READ_SOCK_TMIT_SIZE:
		begin
			if(get_size_nibble == 1'b0) begin
				socket_tmit_free_size <= 17'd0;
				get_size_nibble <= 1'b1;
				idle_to_next_state <= 1'b1;  		// return to this state after fetching register
				address <= S0_TX_FSR;				// register contains the free size available in TX memory of socket
				state <= PROCESS_REG_READ;			// PROCESS_REG_READ is the state to read a register
				nextstate <= W5300_READ_SOCK_TMIT_SIZE;
			end
			else if(get_size_nibble == 1'b1)begin
				socket_tmit_free_size[16] <= W5300_16REG_RD[0];		// assign the bit 0 of S0_RX_RSR to MSB bit of sockeet received size
				idle_to_next_state <= 1'b1;  		// this will just signal to get full size in state W5300_SEND_START
				address <= S0_TX_FSR2;				// register contains the received size
				state <= PROCESS_REG_READ;			// PROCESS_REG_READ is the state to read a register
				nextstate <= W5300_SEND_START;				
			end
		end
		W5300_SET_DEST_IP_PORT:
		begin
			case(comms_mode)
			ETHERNET_SERIAL:
			begin
				address <= S0_TX_DPORTR;
				data_16bits <= dest_port;  // Set the destination port for UDP socket
				// since register address are in contiguous address we can keep adding values for Destination IP address
				w5300_regs[0] <= {dest_ip[0], dest_ip[1]};		// DIPR register, dest_ip[0] contains highest octet of dest ip address
				w5300_regs[1] <= {dest_ip[2], dest_ip[3]};		// DIPR2 register, dest_ip[3 contains the less significant octet of destination IP address.
				reg_cnt <= 5'd2;						// we need to send two more registers
				reg_cnt_sent <= 5'd0;					// Start sending Index 0 of w5300_regs
				idle_to_next_state <= 1'b1;  			// move state into the one assigned to nextstate here after writing register
				state <= W5300_WRITE_REG;
				nextstate <= W5300_SEND_ADJ_SND_SIZE;	// size adjust is initiated here and finish on this next state
				// calculate the write count of Sn_TX_FIFOR for odd numbers
				if(socket_tmit_send_size[0] == 1'b1) begin	// if odd size
					socket_tmit_write_size <= socket_tmit_send_size + 17'd1;
				end
			end
			LOOPBACK:
			begin 
				address <= S0_TX_DPORTR;
				data_16bits <= src_port;  // Set the destination port for UDP socket same as received peer port
				// since register address are in contiguous address we can keep adding values for Destination IP address
				w5300_regs[0] <= {src_ip[0], src_ip[1]};		// DIPR register, dest_ip[0] contains highest octet of dest ip address
				w5300_regs[1] <= {src_ip[2], src_ip[3]};		// DIPR2 register, dest_ip[3 contains the less significant octet of destination IP address.
				reg_cnt <= 5'd2;						// we need to send two more registers
				reg_cnt_sent <= 5'd0;					// Start sending Index 0 of w5300_regs
				idle_to_next_state <= 1'b1;  			// move state into the one assigned to nextstate here after writing register
				state <= W5300_WRITE_REG;
				nextstate <= W5300_SET_WRITE_SIZE;		// move into state which will set the SEND command
				// calculate the write count of Sn_TX_FIFOR for odd numbers
				if(socket_tmit_send_size[0] == 1'b1) begin	// if odd size
					socket_tmit_write_size <= (socket_tmit_send_size + 17'd1) >> 1;
				end
			end
			endcase
		end
		W5300_SEND_ADJ_SND_SIZE:
		begin
			socket_tmit_write_size <= socket_tmit_send_size >> 1;
			idle_to_next_state <= 1'b0;
			state <= W5300_SEND_WRITE_FIFOR;
			tx_wr_index <= 8'd0;
		end
		W5300_SET_WRITE_SIZE:
		begin
		//set the transmit size in S0_TX_WRSR
			address <= S0_TX_WRSR;
			data_16bits <= {15'd0, socket_tmit_send_size[16]};
			w5300_regs[0] <= socket_tmit_send_size[15:0];
			reg_cnt <= 5'd1;						// we need to send one more register for WRITE SIZE REGISTER (17 bits)
			reg_cnt_sent <= 5'd0;					// Start sending Index 0 of w5300_regs
			idle_to_next_state <= 1'b1;
			state <= W5300_WRITE_REG;
			nextstate <= W5300_SET_SEND_CMD;
		end
		W5300_SEND_WRITE_FIFOR:
		begin
			if(socket_tmit_write_size == 17'd0) begin
				if(comms_mode == LOOPBACK) begin
					state <= W5300_RECV_PROCESS;
				end
				else begin
					address <= S0_TX_WRSR;
					data_16bits <= {15'd0, socket_tmit_send_size[16]};
					w5300_regs[0] <= socket_tmit_send_size[15:0];
					reg_cnt <= 5'd1;						// we need to send one more register for WRITE SIZE REGISTER (17 bits)
					reg_cnt_sent <= 5'd0;					// Start sending Index 0 of w5300_regs
					idle_to_next_state <= 1'b1;
					state <= W5300_WRITE_REG;
					nextstate <= W5300_SET_SEND_CMD;
				end
			end
			else begin
				address <= S0_TX_FIFOR;										// write always to FIFO register 
				// check if in loopback mode here to avoid copying from rx to tx buffer as copying will take 36ns for each byte.
				if(comms_mode == LOOPBACK) begin
					data_16bits[7:0] <= message_w5300_rx[tx_wr_index + 8'd1];		// set lower nibble of 16 bit FIFO register to next byte in w5300 RX temp buffer. We are avoiding copying data in Loopback mode
					data_16bits[15:8] <= message_w5300_rx[tx_wr_index];				// set lower nibble of 16 bit FIFO register
				end
				else begin
					data_16bits[7:0] <= message_w5300_tx[tx_wr_index + 8'd1];		// set lower nibble of 16 bit FIFO register to next byte in w5300 TX temp buffer
					data_16bits[15:8] <= message_w5300_tx[tx_wr_index];			// set lower nibble of 16 bit FIFO register
				end
				socket_tmit_write_size <= socket_tmit_write_size - 17'd2;
				tx_wr_index <= tx_wr_index + 8'd2;
				idle_to_next_state <= 1'b1;
				state <= W5300_WRITE_REG;
				nextstate <= W5300_SEND_WRITE_FIFOR;
			end
		end
		W5300_SET_SEND_CMD:
		begin
			address <= S0_CR;
			data_16bits <= CR_SEND;			// set SEND command in S0_CR, will transmit data of size given by S0_TX_WRSR
			reg_cnt <= 5'd0;						
			reg_cnt_sent <= 5'd0;			// Start sending Index 0 of w5300_regs
			idle_to_next_state <= 1'b1;
			state <= W5300_WRITE_REG;
			nextstate <= W5300_SEND_COMPLETED;
		end
		W5300_SEND_COMPLETED:
		begin
			idle_to_next_state <= 1'b0;
			state <= IDLE;					// return to our original state before sending UDP packet
			nextstate <= PROCESS_RX;
		end
		default:
			state <= IDLE;
	endcase
end



uart_rx#
(
	.CLK_FRE(CLK_FRE),
	.BAUD_RATE(UART_FRE)
) uart_rx_inst
(
	.clk                        (clk                      ),
	.rst_n                      (rst_n                    ),
	.rx_data                    (rx_data                  ),
	.rx_data_valid              (rx_data_valid            ),
	.rx_data_ready              (rx_data_ready            ),
	.rx_pin                     (uart_rx                  )
);

uart_tx#
(
	.CLK_FRE(CLK_FRE),
	.BAUD_RATE(UART_FRE)
) uart_tx_inst
(
	.clk                        (clk                      ),
	.rst_n                      (rst_n                    ),
	.tx_data                    (tx_data                  ),
	.tx_data_valid              (tx_data_valid            ),
	.tx_data_ready              (tx_data_ready            ),
	.tx_pin                     (uart_tx                  )
);


 sram_ctrl w5300_ctrl
 (
 	.clk(clk),
    .rst_n(rst_n),
 	.start_operation(start),
 	.rw(rw),
 	.address_input(address2),
 	.data_f2s(data_f2w),
 	.data_s2f(data_w2f),
 	.address_to_sram_output(addr),
 	.we_to_sram_output(wr),
 	.oe_to_sram_output(rd),
 	.ce_to_sram_output(cs),
 	.data_from_to_sram_input_output(data_bus),
 	.data_ready_signal_output(data_rdy),
 	.writing_finished_signal_output(wr_done),
 	.busy_signal_output(busy)
 );


 w5300_interface w5300_itfc 
 (
 	.clk(clk),
 	.address_in(address),
 	.address_out(address2),
 	.start_in(start_in),
 	.start_ctrl(start),
 	.busy_ctrl(busy),
 	.data_rdy_ctrl(data_rdy),
 	.writing_finished_signal(wr_done),
 	.reg_rdy(reg_rdy),
 	.write_done(write_done),
 	.w5300_16reg_read(W5300_16REG_RD),
 	.w5300_16reg_write(W5300_16REG_WR),
 	.data_w2f(data_w2f),
 	.data_f2w(data_f2w),
 	.operation(rw)
 );


endmodule
