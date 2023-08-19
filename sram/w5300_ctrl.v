module w5300_interface(clk, address_in, address_out, start_in, start_ctrl, busy_ctrl, writing_finished_signal, data_rdy_ctrl, reg_rdy, write_done, w5300_16reg_read, w5300_16reg_write, data_w2f, data_f2w, operation);

input wire 				clk;
input wire [9:0]		address_in;
output wire  [9:0]		address_out;
input wire 				start_in;

output reg 			    start_ctrl;
input wire 				busy_ctrl;	
input wire 				data_rdy_ctrl;
input wire				writing_finished_signal;
output reg 				reg_rdy;
output reg				write_done;
output  wire [15:0] 	w5300_16reg_read;
input wire [15:0]		w5300_16reg_write;
input wire [7:0]        data_w2f;
output wire [7:0]		data_f2w;
input wire 				operation;

reg 					reg_nb_sel;
//reg 					write_done;
reg [9:0]				address;
reg [15:0] 				w5300_16reg_read_int;



initial
begin 
	write_done <= 1'b0;
	reg_rdy <= 1'b0;
	reg_nb_sel <= 1'b0;
	address <= 10'd0;
	start_ctrl <= 1'b0;
end

//assign write_done = write_done;
assign address_out = address;
assign w5300_16reg_read = w5300_16reg_read_int;
assign data_f2w = (reg_nb_sel==0) ?  w5300_16reg_write[15:8] : w5300_16reg_write[7:0];

always@(posedge clk)
begin
	if(start_in == 1'b1 && reg_rdy == 1'b0 && operation == 1'd1)
	begin
		// enable the sram type controller
		if(busy_ctrl == 1'b0)
		begin
			address <= address_in;
			reg_nb_sel <= 1'b0;
			start_ctrl <= 1'd1;
		end 
		else 
		begin
			if(data_rdy_ctrl == 1'd1 && reg_nb_sel == 1'd1)
			begin
				w5300_16reg_read_int[7:0] <= data_w2f;
				address <= address + 10'd1;
				start_ctrl <= 1'b0;
				reg_nb_sel <= 1'b0;
				reg_rdy <= 1'b1;
			end
			else if(data_rdy_ctrl == 1'd1 && reg_nb_sel == 1'd0)
			begin
				w5300_16reg_read_int[15:8] <= data_w2f;
				reg_nb_sel <= 1'b1;
				address <= address + 10'd1;
				start_ctrl <= 1'b1;
			end
			else
			begin
				start_ctrl <= 1'b0;
			end
		end
	end
	else if(start_in == 1'b1 && write_done == 1'b0 && operation == 1'd0)
	begin
		if(busy_ctrl == 1'b0)
		begin
			address <= address_in;
			reg_nb_sel <= 1'b0;
			start_ctrl <= 1'd1;
		end
		else
		begin
			if(writing_finished_signal == 0 && reg_nb_sel == 1'd1)
			begin
				address <= address + 10'd1;
				start_ctrl <= 1'b0;
				write_done <= 1'b1;
			end
			else if(writing_finished_signal == 0 && reg_nb_sel == 1'd0)
			begin
				reg_nb_sel <= 1'b1;
				address <= address + 10'd1;
				start_ctrl <= 1'b1;
			end
			else
			begin
				start_ctrl <= 1'b0;
			end
		end
	end
	else if(reg_rdy == 1'b1)
	begin
		reg_rdy <= 1'b0;
	end
	else if(write_done == 1'b1)
	begin
		write_done <= 1'b0;
	end
end

endmodule