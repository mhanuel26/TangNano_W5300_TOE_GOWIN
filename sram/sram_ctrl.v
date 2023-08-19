`timescale 1ns / 1ps
//PLL_CLK, period=about 6.67ns
// WDF x PLL_CLK = 3d'7 x 6.67ns = 46.7 ns

module sram_ctrl(clk, rst_n, start_operation, rw, address_input, data_f2s, data_s2f, address_to_sram_output, we_to_sram_output, oe_to_sram_output, ce_to_sram_output, data_from_to_sram_input_output, data_ready_signal_output, writing_finished_signal_output, busy_signal_output);

  input wire clk ;                                 //  Clock signal
  input      rst_n;
  input wire start_operation;                      //  start operation signal

  input wire rw;                                   //  With this signal, we select reading or writing operation
  input wire [9:0] address_input;                 //  Address bus
  input wire [7:0] data_f2s;                       //  Data to be writteb in the SRAM

  output wire [7:0] data_s2f;                      //  It is the 8-bit registered data retrieved from the SRAM (the -s2f suffix stands for SRAM to FPGA)
  output reg [9:0] address_to_sram_output;        //  Address bus

  output reg we_to_sram_output;                    //  Write enable (active-low)
  output reg oe_to_sram_output;                    //  Output enable (active-low)
  output reg ce_to_sram_output;                    //  Chip enable (active-low). Disables or enables the chip.

  inout wire [7:0] data_from_to_sram_input_output; //  Data bus

  output reg data_ready_signal_output;             //   Ready signal
  output reg writing_finished_signal_output;       //   Writing finished signal
  output reg busy_signal_output;                   //   Busy signal

  reg [2:0] counter; 


  //FSM states declaration
  localparam [1:0]
  idle   =   2'b00,
  rd0    =   2'b01,
  wr0    =   2'b10;

  //	signal declaration
  reg [3:0] state_reg;

  reg [7:0] register_for_reading_data;
  reg [7:0] register_for_writing_data;

  reg register_for_splitting;

  // initial
  //   begin
  //     address_to_sram_output <= 10'd0;
  //     ce_to_sram_output<=1'b1;
  //     oe_to_sram_output<=1'b1;
  //     we_to_sram_output<=1'b1;

  //     state_reg <= idle;

  //     register_for_reading_data[7:0]<=8'b0000_0000;
  //     register_for_writing_data[7:0]<=8'b0000_0000;

  //     register_for_splitting<=1'b0;

  //     data_ready_signal_output<=1'b0;
  //     writing_finished_signal_output<=1'b0;
  //     busy_signal_output<=1'b0;

  //   end

  always@(posedge clk or negedge rst_n)
    if(rst_n == 1'b0)
    begin
      address_to_sram_output <= 10'd0;
      ce_to_sram_output<=1'b1;
      oe_to_sram_output<=1'b1;
      we_to_sram_output<=1'b1;
      state_reg <= idle;
      register_for_reading_data[7:0]<=8'b0000_0000;
      register_for_writing_data[7:0]<=8'b0000_0000;
      register_for_splitting<=1'b0;
      data_ready_signal_output<=1'b0;
      writing_finished_signal_output<=1'b0;
      busy_signal_output<=1'b0;
    end
    else
    begin
      case(state_reg)
        idle: 
          begin                   
            writing_finished_signal_output <= 1'b1;               //  The write operation is not in process
            oe_to_sram_output <= 1'b1;    // read enable
            we_to_sram_output <= 1'b1;    // write enable
            busy_signal_output <= 1'b0;                           //  The controller is not busy
            data_ready_signal_output <= 1'b0;                     //  No data ready for reading

            if(~start_operation)
              state_reg <= idle;
            else begin
              if(rw) begin
                counter <= 3'd0;
                address_to_sram_output[9:0] <= address_input[9:0];
                 ce_to_sram_output <= 1'b0;    // chip select
                oe_to_sram_output <= 1'b0;     // read enable
                busy_signal_output <= 1'b1;
                state_reg <= rd0;
              end
              else begin
                busy_signal_output <= 1'b1;   // busy signal is for read and write operation.
                register_for_splitting <= 1'b1; //  We configure the data bus for writing
                counter <= 3'd0;
                address_to_sram_output[9:0] <= address_input[9:0];
                register_for_writing_data[7:0] <= data_f2s[7:0];
                ce_to_sram_output <= 1'b0;    // chip select
                we_to_sram_output <= 1'b0;    // write enable
                state_reg <= wr0;
              end
            end
          end
        //============================== READING PHASE ==============================
        rd0:
          begin
            if(counter == 3'd1) begin
              state_reg <= idle;
              oe_to_sram_output <= 1'b1;
               ce_to_sram_output <= 1'b1;    // chip select
              data_ready_signal_output <= 1'b0; 
            end
            else if(counter == 3'd0) begin
              data_ready_signal_output <= 1'b1;
              register_for_reading_data[7:0] <= data_from_to_sram_input_output[7:0];
              counter <= counter + 3'd1;
            end
          end
        //============================== WRITING PHASE ==============================
        wr0:
          begin
            if (counter == 3'd2) begin
              state_reg <= idle;
              register_for_splitting <= 1'b0;    
            end
            else if(counter == 3'd1) begin
              counter <= counter + 3'd1;
              writing_finished_signal_output <= 1'b0;
              we_to_sram_output <= 1'b1;
              ce_to_sram_output <= 1'b1;    // chip select
            end
            else if(counter == 3'd0) begin
              counter <= counter + 3'd1;
            end
          end
      endcase
    end

  assign data_s2f = register_for_reading_data;

  assign data_from_to_sram_input_output = (register_for_splitting) ? register_for_writing_data : 8'bz;

endmodule   
