onerror {resume}
quietly virtual function -install /uart_top_tb/dut -env /uart_top_tb { &{/uart_top_tb/dut/message[0][7], /uart_top_tb/dut/message[0][6], /uart_top_tb/dut/message[0][5], /uart_top_tb/dut/message[0][4], /uart_top_tb/dut/message[0][3], /uart_top_tb/dut/message[0][2], /uart_top_tb/dut/message[0][1] }} message_0_7_1
quietly virtual function -install /uart_top_tb/dut -env /uart_top_tb/dut { &{/uart_top_tb/dut/message_tx[79], /uart_top_tb/dut/message_tx[78], /uart_top_tb/dut/message_tx[77], /uart_top_tb/dut/message_tx[76], /uart_top_tb/dut/message_tx[75], /uart_top_tb/dut/message_tx[74], /uart_top_tb/dut/message_tx[73], /uart_top_tb/dut/message_tx[72], /uart_top_tb/dut/message_tx[71], /uart_top_tb/dut/message_tx[70], /uart_top_tb/dut/message_tx[69], /uart_top_tb/dut/message_tx[68], /uart_top_tb/dut/message_tx[67], /uart_top_tb/dut/message_tx[66], /uart_top_tb/dut/message_tx[65], /uart_top_tb/dut/message_tx[64], /uart_top_tb/dut/message_tx[63], /uart_top_tb/dut/message_tx[62], /uart_top_tb/dut/message_tx[61], /uart_top_tb/dut/message_tx[60], /uart_top_tb/dut/message_tx[59], /uart_top_tb/dut/message_tx[58], /uart_top_tb/dut/message_tx[57], /uart_top_tb/dut/message_tx[56], /uart_top_tb/dut/message_tx[55], /uart_top_tb/dut/message_tx[54], /uart_top_tb/dut/message_tx[53], /uart_top_tb/dut/message_tx[52], /uart_top_tb/dut/message_tx[51], /uart_top_tb/dut/message_tx[50], /uart_top_tb/dut/message_tx[49], /uart_top_tb/dut/message_tx[48], /uart_top_tb/dut/message_tx[47], /uart_top_tb/dut/message_tx[46], /uart_top_tb/dut/message_tx[45], /uart_top_tb/dut/message_tx[44], /uart_top_tb/dut/message_tx[43], /uart_top_tb/dut/message_tx[42], /uart_top_tb/dut/message_tx[41], /uart_top_tb/dut/message_tx[40], /uart_top_tb/dut/message_tx[39], /uart_top_tb/dut/message_tx[38], /uart_top_tb/dut/message_tx[37], /uart_top_tb/dut/message_tx[36], /uart_top_tb/dut/message_tx[35], /uart_top_tb/dut/message_tx[34], /uart_top_tb/dut/message_tx[33], /uart_top_tb/dut/message_tx[32], /uart_top_tb/dut/message_tx[31], /uart_top_tb/dut/message_tx[30], /uart_top_tb/dut/message_tx[29], /uart_top_tb/dut/message_tx[28], /uart_top_tb/dut/message_tx[27], /uart_top_tb/dut/message_tx[26], /uart_top_tb/dut/message_tx[25], /uart_top_tb/dut/message_tx[24], /uart_top_tb/dut/message_tx[23], /uart_top_tb/dut/message_tx[22], /uart_top_tb/dut/message_tx[21], /uart_top_tb/dut/message_tx[20], /uart_top_tb/dut/message_tx[19], /uart_top_tb/dut/message_tx[18], /uart_top_tb/dut/message_tx[17], /uart_top_tb/dut/message_tx[16], /uart_top_tb/dut/message_tx[15], /uart_top_tb/dut/message_tx[14], /uart_top_tb/dut/message_tx[13] }} aaa
quietly virtual function -install /uart_top_tb/dut -env /uart_top_tb/dut { &{/uart_top_tb/dut/message_tx[12], /uart_top_tb/dut/message_tx[11], /uart_top_tb/dut/message_tx[10], /uart_top_tb/dut/message_tx[9], /uart_top_tb/dut/message_tx[8], /uart_top_tb/dut/message_tx[7], /uart_top_tb/dut/message_tx[6], /uart_top_tb/dut/message_tx[5], /uart_top_tb/dut/message_tx[4], /uart_top_tb/dut/message_tx[3], /uart_top_tb/dut/message_tx[2], /uart_top_tb/dut/message_tx[1], /uart_top_tb/dut/message_tx[0] }} hello_world
quietly WaveActivateNextPane {} 0
add wave -noupdate /uart_top_tb/clk
add wave -noupdate /uart_top_tb/leds
add wave -noupdate -radix hexadecimal -childformat {{{/uart_top_tb/address_bus[9]} -radix hexadecimal} {{/uart_top_tb/address_bus[8]} -radix hexadecimal} {{/uart_top_tb/address_bus[7]} -radix hexadecimal} {{/uart_top_tb/address_bus[6]} -radix hexadecimal} {{/uart_top_tb/address_bus[5]} -radix hexadecimal} {{/uart_top_tb/address_bus[4]} -radix hexadecimal} {{/uart_top_tb/address_bus[3]} -radix hexadecimal} {{/uart_top_tb/address_bus[2]} -radix hexadecimal} {{/uart_top_tb/address_bus[1]} -radix hexadecimal} {{/uart_top_tb/address_bus[0]} -radix hexadecimal}} -subitemconfig {{/uart_top_tb/address_bus[9]} {-height 15 -radix hexadecimal} {/uart_top_tb/address_bus[8]} {-height 15 -radix hexadecimal} {/uart_top_tb/address_bus[7]} {-height 15 -radix hexadecimal} {/uart_top_tb/address_bus[6]} {-height 15 -radix hexadecimal} {/uart_top_tb/address_bus[5]} {-height 15 -radix hexadecimal} {/uart_top_tb/address_bus[4]} {-height 15 -radix hexadecimal} {/uart_top_tb/address_bus[3]} {-height 15 -radix hexadecimal} {/uart_top_tb/address_bus[2]} {-height 15 -radix hexadecimal} {/uart_top_tb/address_bus[1]} {-height 15 -radix hexadecimal} {/uart_top_tb/address_bus[0]} {-height 15 -radix hexadecimal}} /uart_top_tb/address_bus
add wave -noupdate /uart_top_tb/wr
add wave -noupdate /uart_top_tb/cs
add wave -noupdate -radix hexadecimal -childformat {{{/uart_top_tb/data_bus[7]} -radix hexadecimal} {{/uart_top_tb/data_bus[6]} -radix hexadecimal} {{/uart_top_tb/data_bus[5]} -radix hexadecimal} {{/uart_top_tb/data_bus[4]} -radix hexadecimal} {{/uart_top_tb/data_bus[3]} -radix hexadecimal} {{/uart_top_tb/data_bus[2]} -radix hexadecimal} {{/uart_top_tb/data_bus[1]} -radix hexadecimal} {{/uart_top_tb/data_bus[0]} -radix hexadecimal}} -subitemconfig {{/uart_top_tb/data_bus[7]} {-height 15 -radix hexadecimal} {/uart_top_tb/data_bus[6]} {-height 15 -radix hexadecimal} {/uart_top_tb/data_bus[5]} {-height 15 -radix hexadecimal} {/uart_top_tb/data_bus[4]} {-height 15 -radix hexadecimal} {/uart_top_tb/data_bus[3]} {-height 15 -radix hexadecimal} {/uart_top_tb/data_bus[2]} {-height 15 -radix hexadecimal} {/uart_top_tb/data_bus[1]} {-height 15 -radix hexadecimal} {/uart_top_tb/data_bus[0]} {-height 15 -radix hexadecimal}} /uart_top_tb/data_bus
add wave -noupdate /uart_top_tb/rd
add wave -noupdate -radix hexadecimal /uart_top_tb/dut/rx_data
add wave -noupdate -radix decimal /uart_top_tb/dut/rx_index
add wave -noupdate /uart_top_tb/data_in
add wave -noupdate -radix ascii /uart_top_tb/dut/tx_data
add wave -noupdate -radix decimal /uart_top_tb/dut/tx_cnt
add wave -noupdate /uart_top_tb/data_out
add wave -noupdate -radix hexadecimal -childformat {{{/uart_top_tb/dut/W5300_16REG_RD[15]} -radix hexadecimal} {{/uart_top_tb/dut/W5300_16REG_RD[14]} -radix hexadecimal} {{/uart_top_tb/dut/W5300_16REG_RD[13]} -radix hexadecimal} {{/uart_top_tb/dut/W5300_16REG_RD[12]} -radix hexadecimal} {{/uart_top_tb/dut/W5300_16REG_RD[11]} -radix hexadecimal} {{/uart_top_tb/dut/W5300_16REG_RD[10]} -radix hexadecimal} {{/uart_top_tb/dut/W5300_16REG_RD[9]} -radix hexadecimal} {{/uart_top_tb/dut/W5300_16REG_RD[8]} -radix hexadecimal} {{/uart_top_tb/dut/W5300_16REG_RD[7]} -radix hexadecimal} {{/uart_top_tb/dut/W5300_16REG_RD[6]} -radix hexadecimal} {{/uart_top_tb/dut/W5300_16REG_RD[5]} -radix hexadecimal} {{/uart_top_tb/dut/W5300_16REG_RD[4]} -radix hexadecimal} {{/uart_top_tb/dut/W5300_16REG_RD[3]} -radix hexadecimal} {{/uart_top_tb/dut/W5300_16REG_RD[2]} -radix hexadecimal} {{/uart_top_tb/dut/W5300_16REG_RD[1]} -radix hexadecimal} {{/uart_top_tb/dut/W5300_16REG_RD[0]} -radix hexadecimal}} -subitemconfig {{/uart_top_tb/dut/W5300_16REG_RD[15]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/W5300_16REG_RD[14]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/W5300_16REG_RD[13]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/W5300_16REG_RD[12]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/W5300_16REG_RD[11]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/W5300_16REG_RD[10]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/W5300_16REG_RD[9]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/W5300_16REG_RD[8]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/W5300_16REG_RD[7]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/W5300_16REG_RD[6]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/W5300_16REG_RD[5]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/W5300_16REG_RD[4]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/W5300_16REG_RD[3]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/W5300_16REG_RD[2]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/W5300_16REG_RD[1]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/W5300_16REG_RD[0]} {-height 15 -radix hexadecimal}} /uart_top_tb/dut/W5300_16REG_RD
add wave -noupdate -radix unsigned /uart_top_tb/dut/init_w5300_state
add wave -noupdate /uart_top_tb/dut/int_n
add wave -noupdate -divider {New Divider}
add wave -noupdate -expand -group recv_debug -radix unsigned /uart_top_tb/dut/socket_tmit_write_size
add wave -noupdate -expand -group recv_debug -radix unsigned /uart_top_tb/dut/socket_tmit_free_size
add wave -noupdate -expand -group recv_debug /uart_top_tb/dut/idle_to_next_state
add wave -noupdate -expand -group recv_debug /uart_top_tb/dut/address
add wave -noupdate -expand -group recv_debug /uart_top_tb/dut/address2
add wave -noupdate -expand -group recv_debug /uart_top_tb/dut/start_in
add wave -noupdate -expand -group recv_debug /uart_top_tb/dut/busy
add wave -noupdate -expand -group recv_debug /uart_top_tb/dut/data_rdy
add wave -noupdate -expand -group recv_debug /uart_top_tb/dut/address2
add wave -noupdate -expand -group recv_debug -radix unsigned /uart_top_tb/dut/state
add wave -noupdate -expand -group recv_debug -radix unsigned /uart_top_tb/dut/nextstate
add wave -noupdate -expand -group recv_debug /uart_top_tb/dut/reg_rdy
add wave -noupdate -expand -group recv_debug /uart_top_tb/dut/write_done
add wave -noupdate -expand -group recv_debug -radix unsigned /uart_top_tb/dut/init_w5300_state
add wave -noupdate -expand -group recv_debug -radix unsigned /uart_top_tb/dut/socket_init_state_udp
add wave -noupdate -expand -group recv_debug /uart_top_tb/dut/int_n
add wave -noupdate -expand -group recv_debug -radix hexadecimal /uart_top_tb/dut/socket_recv_value
add wave -noupdate -expand -group recv_debug /uart_top_tb/dut/send_serial_flag
add wave -noupdate -expand -group recv_debug /uart_top_tb/dut/get_size_nibble
add wave -noupdate -expand -group recv_debug -radix unsigned /uart_top_tb/dut/get_recv_done
add wave -noupdate -expand -group recv_debug -radix unsigned /uart_top_tb/dut/tx_wr_index
add wave -noupdate -expand -group recv_debug /uart_top_tb/dut/w5300_rx_index
add wave -noupdate -divider {New Divider}
add wave -noupdate -group w5300_ctrl /uart_top_tb/dut/w5300_ctrl/clk
add wave -noupdate -group w5300_ctrl /uart_top_tb/dut/w5300_ctrl/start_operation
add wave -noupdate -group w5300_ctrl /uart_top_tb/dut/w5300_ctrl/rw
add wave -noupdate -group w5300_ctrl /uart_top_tb/dut/w5300_ctrl/address_input
add wave -noupdate -group w5300_ctrl /uart_top_tb/dut/w5300_ctrl/data_f2s
add wave -noupdate -group w5300_ctrl /uart_top_tb/dut/w5300_ctrl/data_s2f
add wave -noupdate -group w5300_ctrl -radix hexadecimal /uart_top_tb/dut/w5300_ctrl/address_to_sram_output
add wave -noupdate -group w5300_ctrl /uart_top_tb/dut/w5300_ctrl/ce_to_sram_output
add wave -noupdate -group w5300_ctrl /uart_top_tb/dut/w5300_ctrl/we_to_sram_output
add wave -noupdate -group w5300_ctrl /uart_top_tb/dut/w5300_ctrl/oe_to_sram_output
add wave -noupdate -group w5300_ctrl -radix hexadecimal /uart_top_tb/dut/w5300_ctrl/data_from_to_sram_input_output
add wave -noupdate -group w5300_ctrl /uart_top_tb/dut/w5300_ctrl/data_ready_signal_output
add wave -noupdate -group w5300_ctrl /uart_top_tb/dut/w5300_ctrl/writing_finished_signal_output
add wave -noupdate -group w5300_ctrl -radix decimal /uart_top_tb/dut/w5300_ctrl/counter
add wave -noupdate -group w5300_ctrl /uart_top_tb/dut/w5300_ctrl/state_reg
add wave -noupdate -group w5300_ctrl /uart_top_tb/dut/w5300_ctrl/register_for_reading_data
add wave -noupdate -group w5300_ctrl /uart_top_tb/dut/w5300_ctrl/register_for_writing_data
add wave -noupdate -group w5300_ctrl /uart_top_tb/dut/w5300_ctrl/register_for_splitting
add wave -noupdate -group w5300_ctrl -radix decimal /uart_top_tb/dut/w5300_ctrl/state_reg
add wave -noupdate -group w5300_ctrl /uart_top_tb/dut/w5300_ctrl/start_operation
add wave -noupdate -group w5300_ctrl /uart_top_tb/dut/w5300_ctrl/busy_signal_output
add wave -noupdate -expand -group {serial stuff} /uart_top_tb/dut/reg_cnt
add wave -noupdate -expand -group {serial stuff} /uart_top_tb/dut/reg_cnt_sent
add wave -noupdate -expand -group {serial stuff} /uart_top_tb/dut/data_16bits
add wave -noupdate -expand -group {serial stuff} -radix hexadecimal -childformat {{{/uart_top_tb/dut/message[19]} -radix ascii} {{/uart_top_tb/dut/message[18]} -radix ascii} {{/uart_top_tb/dut/message[17]} -radix ascii} {{/uart_top_tb/dut/message[16]} -radix ascii} {{/uart_top_tb/dut/message[15]} -radix ascii} {{/uart_top_tb/dut/message[14]} -radix ascii} {{/uart_top_tb/dut/message[13]} -radix ascii} {{/uart_top_tb/dut/message[12]} -radix ascii} {{/uart_top_tb/dut/message[11]} -radix ascii} {{/uart_top_tb/dut/message[10]} -radix ascii} {{/uart_top_tb/dut/message[9]} -radix ascii} {{/uart_top_tb/dut/message[8]} -radix ascii} {{/uart_top_tb/dut/message[7]} -radix ascii} {{/uart_top_tb/dut/message[6]} -radix ascii} {{/uart_top_tb/dut/message[5]} -radix ascii} {{/uart_top_tb/dut/message[4]} -radix ascii} {{/uart_top_tb/dut/message[3]} -radix ascii} {{/uart_top_tb/dut/message[2]} -radix ascii} {{/uart_top_tb/dut/message[1]} -radix ascii} {{/uart_top_tb/dut/message[0]} -radix ascii -childformat {{{/uart_top_tb/dut/message[0][7]} -radix hexadecimal} {{/uart_top_tb/dut/message[0][6]} -radix hexadecimal} {{/uart_top_tb/dut/message[0][5]} -radix hexadecimal} {{/uart_top_tb/dut/message[0][4]} -radix hexadecimal} {{/uart_top_tb/dut/message[0][3]} -radix hexadecimal} {{/uart_top_tb/dut/message[0][2]} -radix hexadecimal} {{/uart_top_tb/dut/message[0][1]} -radix hexadecimal} {{/uart_top_tb/dut/message[0][0]} -radix hexadecimal}}}} -subitemconfig {{/uart_top_tb/dut/message[19]} {-height 15 -radix ascii} {/uart_top_tb/dut/message[18]} {-height 15 -radix ascii} {/uart_top_tb/dut/message[17]} {-height 15 -radix ascii} {/uart_top_tb/dut/message[16]} {-height 15 -radix ascii} {/uart_top_tb/dut/message[15]} {-height 15 -radix ascii} {/uart_top_tb/dut/message[14]} {-height 15 -radix ascii} {/uart_top_tb/dut/message[13]} {-height 15 -radix ascii} {/uart_top_tb/dut/message[12]} {-height 15 -radix ascii} {/uart_top_tb/dut/message[11]} {-height 15 -radix ascii} {/uart_top_tb/dut/message[10]} {-height 15 -radix ascii} {/uart_top_tb/dut/message[9]} {-height 15 -radix ascii} {/uart_top_tb/dut/message[8]} {-height 15 -radix ascii} {/uart_top_tb/dut/message[7]} {-height 15 -radix ascii} {/uart_top_tb/dut/message[6]} {-height 15 -radix ascii} {/uart_top_tb/dut/message[5]} {-height 15 -radix ascii} {/uart_top_tb/dut/message[4]} {-height 15 -radix ascii} {/uart_top_tb/dut/message[3]} {-height 15 -radix ascii} {/uart_top_tb/dut/message[2]} {-height 15 -radix ascii} {/uart_top_tb/dut/message[1]} {-height 15 -radix ascii} {/uart_top_tb/dut/message[0]} {-height 15 -radix ascii -childformat {{{/uart_top_tb/dut/message[0][7]} -radix hexadecimal} {{/uart_top_tb/dut/message[0][6]} -radix hexadecimal} {{/uart_top_tb/dut/message[0][5]} -radix hexadecimal} {{/uart_top_tb/dut/message[0][4]} -radix hexadecimal} {{/uart_top_tb/dut/message[0][3]} -radix hexadecimal} {{/uart_top_tb/dut/message[0][2]} -radix hexadecimal} {{/uart_top_tb/dut/message[0][1]} -radix hexadecimal} {{/uart_top_tb/dut/message[0][0]} -radix hexadecimal}}} {/uart_top_tb/dut/message[0][7]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/message[0][6]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/message[0][5]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/message[0][4]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/message[0][3]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/message[0][2]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/message[0][1]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/message[0][0]} {-height 15 -radix hexadecimal}} /uart_top_tb/dut/message
add wave -noupdate -expand -group {serial stuff} -radix ascii -childformat {{{/uart_top_tb/dut/message_tx[79]} -radix hexadecimal} {{/uart_top_tb/dut/message_tx[78]} -radix hexadecimal} {{/uart_top_tb/dut/message_tx[77]} -radix hexadecimal} {{/uart_top_tb/dut/message_tx[76]} -radix hexadecimal} {{/uart_top_tb/dut/message_tx[75]} -radix hexadecimal} {{/uart_top_tb/dut/message_tx[74]} -radix hexadecimal} {{/uart_top_tb/dut/message_tx[73]} -radix hexadecimal} {{/uart_top_tb/dut/message_tx[72]} -radix hexadecimal} {{/uart_top_tb/dut/message_tx[71]} -radix hexadecimal} {{/uart_top_tb/dut/message_tx[70]} -radix hexadecimal} {{/uart_top_tb/dut/message_tx[69]} -radix hexadecimal} {{/uart_top_tb/dut/message_tx[68]} -radix hexadecimal} {{/uart_top_tb/dut/message_tx[67]} -radix hexadecimal} {{/uart_top_tb/dut/message_tx[66]} -radix hexadecimal} {{/uart_top_tb/dut/message_tx[65]} -radix hexadecimal} {{/uart_top_tb/dut/message_tx[64]} -radix hexadecimal} {{/uart_top_tb/dut/message_tx[63]} -radix hexadecimal} {{/uart_top_tb/dut/message_tx[62]} -radix hexadecimal} {{/uart_top_tb/dut/message_tx[61]} -radix hexadecimal} {{/uart_top_tb/dut/message_tx[60]} -radix hexadecimal} {{/uart_top_tb/dut/message_tx[59]} -radix hexadecimal} {{/uart_top_tb/dut/message_tx[58]} -radix hexadecimal} {{/uart_top_tb/dut/message_tx[57]} -radix hexadecimal} {{/uart_top_tb/dut/message_tx[56]} -radix hexadecimal} {{/uart_top_tb/dut/message_tx[55]} -radix hexadecimal} {{/uart_top_tb/dut/message_tx[54]} -radix hexadecimal} {{/uart_top_tb/dut/message_tx[53]} -radix hexadecimal} {{/uart_top_tb/dut/message_tx[52]} -radix hexadecimal} {{/uart_top_tb/dut/message_tx[51]} -radix ascii} {{/uart_top_tb/dut/message_tx[50]} -radix ascii} {{/uart_top_tb/dut/message_tx[49]} -radix ascii} {{/uart_top_tb/dut/message_tx[48]} -radix ascii} {{/uart_top_tb/dut/message_tx[47]} -radix ascii} {{/uart_top_tb/dut/message_tx[46]} -radix ascii} {{/uart_top_tb/dut/message_tx[45]} -radix ascii} {{/uart_top_tb/dut/message_tx[44]} -radix ascii} {{/uart_top_tb/dut/message_tx[43]} -radix ascii} {{/uart_top_tb/dut/message_tx[42]} -radix ascii} {{/uart_top_tb/dut/message_tx[41]} -radix ascii} {{/uart_top_tb/dut/message_tx[40]} -radix ascii} {{/uart_top_tb/dut/message_tx[39]} -radix ascii} {{/uart_top_tb/dut/message_tx[38]} -radix ascii} {{/uart_top_tb/dut/message_tx[37]} -radix ascii} {{/uart_top_tb/dut/message_tx[36]} -radix ascii} {{/uart_top_tb/dut/message_tx[35]} -radix ascii} {{/uart_top_tb/dut/message_tx[34]} -radix ascii} {{/uart_top_tb/dut/message_tx[33]} -radix ascii} {{/uart_top_tb/dut/message_tx[32]} -radix ascii} {{/uart_top_tb/dut/message_tx[31]} -radix ascii} {{/uart_top_tb/dut/message_tx[30]} -radix ascii} {{/uart_top_tb/dut/message_tx[29]} -radix ascii} {{/uart_top_tb/dut/message_tx[28]} -radix ascii} {{/uart_top_tb/dut/message_tx[27]} -radix ascii} {{/uart_top_tb/dut/message_tx[26]} -radix ascii} {{/uart_top_tb/dut/message_tx[25]} -radix ascii} {{/uart_top_tb/dut/message_tx[24]} -radix ascii} {{/uart_top_tb/dut/message_tx[23]} -radix ascii} {{/uart_top_tb/dut/message_tx[22]} -radix ascii} {{/uart_top_tb/dut/message_tx[21]} -radix ascii} {{/uart_top_tb/dut/message_tx[20]} -radix ascii} {{/uart_top_tb/dut/message_tx[19]} -radix ascii} {{/uart_top_tb/dut/message_tx[18]} -radix ascii} {{/uart_top_tb/dut/message_tx[17]} -radix ascii} {{/uart_top_tb/dut/message_tx[16]} -radix ascii} {{/uart_top_tb/dut/message_tx[15]} -radix ascii} {{/uart_top_tb/dut/message_tx[14]} -radix ascii} {{/uart_top_tb/dut/message_tx[13]} -radix ascii} {{/uart_top_tb/dut/message_tx[12]} -radix ascii} {{/uart_top_tb/dut/message_tx[11]} -radix ascii} {{/uart_top_tb/dut/message_tx[10]} -radix ascii} {{/uart_top_tb/dut/message_tx[9]} -radix ascii} {{/uart_top_tb/dut/message_tx[8]} -radix ascii} {{/uart_top_tb/dut/message_tx[7]} -radix ascii} {{/uart_top_tb/dut/message_tx[6]} -radix ascii} {{/uart_top_tb/dut/message_tx[5]} -radix ascii} {{/uart_top_tb/dut/message_tx[4]} -radix ascii} {{/uart_top_tb/dut/message_tx[3]} -radix ascii} {{/uart_top_tb/dut/message_tx[2]} -radix ascii} {{/uart_top_tb/dut/message_tx[1]} -radix ascii} {{/uart_top_tb/dut/message_tx[0]} -radix ascii}} -subitemconfig {{/uart_top_tb/dut/message_tx[79]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/message_tx[78]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/message_tx[77]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/message_tx[76]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/message_tx[75]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/message_tx[74]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/message_tx[73]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/message_tx[72]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/message_tx[71]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/message_tx[70]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/message_tx[69]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/message_tx[68]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/message_tx[67]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/message_tx[66]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/message_tx[65]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/message_tx[64]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/message_tx[63]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/message_tx[62]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/message_tx[61]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/message_tx[60]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/message_tx[59]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/message_tx[58]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/message_tx[57]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/message_tx[56]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/message_tx[55]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/message_tx[54]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/message_tx[53]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/message_tx[52]} {-height 15 -radix hexadecimal} {/uart_top_tb/dut/message_tx[51]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[50]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[49]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[48]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[47]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[46]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[45]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[44]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[43]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[42]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[41]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[40]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[39]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[38]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[37]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[36]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[35]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[34]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[33]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[32]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[31]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[30]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[29]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[28]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[27]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[26]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[25]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[24]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[23]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[22]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[21]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[20]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[19]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[18]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[17]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[16]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[15]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[14]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[13]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[12]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[11]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[10]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[9]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[8]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[7]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[6]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[5]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[4]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[3]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[2]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[1]} {-height 15 -radix ascii} {/uart_top_tb/dut/message_tx[0]} {-height 15 -radix ascii}} /uart_top_tb/dut/message_tx
add wave -noupdate -group hello_world -radix hexadecimal {/uart_top_tb/dut/message_tx[12]}
add wave -noupdate -group hello_world -radix hexadecimal {/uart_top_tb/dut/message_tx[11]}
add wave -noupdate -group hello_world -radix hexadecimal {/uart_top_tb/dut/message_tx[10]}
add wave -noupdate -group hello_world -radix hexadecimal {/uart_top_tb/dut/message_tx[9]}
add wave -noupdate -group hello_world -radix hexadecimal {/uart_top_tb/dut/message_tx[8]}
add wave -noupdate -group hello_world -radix hexadecimal {/uart_top_tb/dut/message_tx[7]}
add wave -noupdate -group hello_world -radix hexadecimal {/uart_top_tb/dut/message_tx[6]}
add wave -noupdate -group hello_world -radix hexadecimal {/uart_top_tb/dut/message_tx[5]}
add wave -noupdate -group hello_world -radix hexadecimal {/uart_top_tb/dut/message_tx[4]}
add wave -noupdate -group hello_world -radix hexadecimal {/uart_top_tb/dut/message_tx[3]}
add wave -noupdate -group hello_world -radix hexadecimal {/uart_top_tb/dut/message_tx[2]}
add wave -noupdate -group hello_world -radix hexadecimal {/uart_top_tb/dut/message_tx[1]}
add wave -noupdate -group hello_world -radix hexadecimal {/uart_top_tb/dut/message_tx[0]}
add wave -noupdate -group w5300_data -radix hexadecimal {/uart_top_tb/dut/message_w5300_rx[12]}
add wave -noupdate -group w5300_data -radix hexadecimal {/uart_top_tb/dut/message_w5300_rx[11]}
add wave -noupdate -group w5300_data -radix hexadecimal {/uart_top_tb/dut/message_w5300_rx[10]}
add wave -noupdate -group w5300_data -radix hexadecimal {/uart_top_tb/dut/message_w5300_rx[9]}
add wave -noupdate -group w5300_data -radix hexadecimal {/uart_top_tb/dut/message_w5300_rx[8]}
add wave -noupdate -group w5300_data -radix hexadecimal {/uart_top_tb/dut/message_w5300_rx[7]}
add wave -noupdate -group w5300_data -radix hexadecimal {/uart_top_tb/dut/message_w5300_rx[6]}
add wave -noupdate -group w5300_data -radix hexadecimal {/uart_top_tb/dut/message_w5300_rx[5]}
add wave -noupdate -group w5300_data -radix hexadecimal {/uart_top_tb/dut/message_w5300_rx[4]}
add wave -noupdate -group w5300_data -radix hexadecimal {/uart_top_tb/dut/message_w5300_rx[3]}
add wave -noupdate -group w5300_data -radix hexadecimal {/uart_top_tb/dut/message_w5300_rx[2]}
add wave -noupdate -group w5300_data -radix hexadecimal {/uart_top_tb/dut/message_w5300_rx[1]}
add wave -noupdate -group w5300_data -radix hexadecimal {/uart_top_tb/dut/message_w5300_rx[0]}
add wave -noupdate -group w5300_interface /uart_top_tb/dut/w5300_itfc/clk
add wave -noupdate -group w5300_interface /uart_top_tb/dut/w5300_itfc/address_in
add wave -noupdate -group w5300_interface /uart_top_tb/dut/w5300_itfc/address_out
add wave -noupdate -group w5300_interface /uart_top_tb/dut/w5300_itfc/start_in
add wave -noupdate -group w5300_interface /uart_top_tb/dut/w5300_itfc/start_ctrl
add wave -noupdate -group w5300_interface /uart_top_tb/dut/w5300_itfc/busy_ctrl
add wave -noupdate -group w5300_interface /uart_top_tb/dut/w5300_itfc/data_rdy_ctrl
add wave -noupdate -group w5300_interface /uart_top_tb/dut/w5300_itfc/writing_finished_signal
add wave -noupdate -group w5300_interface /uart_top_tb/dut/w5300_itfc/reg_rdy
add wave -noupdate -group w5300_interface /uart_top_tb/dut/w5300_itfc/write_done
add wave -noupdate -group w5300_interface /uart_top_tb/dut/w5300_itfc/w5300_16reg_read
add wave -noupdate -group w5300_interface -radix hexadecimal /uart_top_tb/dut/w5300_itfc/w5300_16reg_write
add wave -noupdate -group w5300_interface -radix hexadecimal /uart_top_tb/dut/w5300_itfc/data_w2f
add wave -noupdate -group w5300_interface -radix hexadecimal /uart_top_tb/dut/w5300_itfc/data_f2w
add wave -noupdate -group w5300_interface /uart_top_tb/dut/w5300_itfc/operation
add wave -noupdate -group w5300_interface /uart_top_tb/dut/w5300_itfc/reg_nb_sel
add wave -noupdate -group w5300_interface /uart_top_tb/dut/w5300_itfc/address
add wave -noupdate -group w5300_interface /uart_top_tb/dut/w5300_itfc/w5300_16reg_read_int
add wave -noupdate /uart_top_tb/data_bus_tb
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {17005458621 ps} 0} {{Cursor 2} {198340968 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 240
configure wave -valuecolwidth 73
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {198018464 ps} {200299917 ps}