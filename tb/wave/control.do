onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fft_control_tb/CONTROL/iCLK
add wave -noupdate /fft_control_tb/CONTROL/iSTART
add wave -noupdate -expand -group fft_ctrl -radix binary /fft_control_tb/CONTROL/addr_rd_mask
add wave -noupdate -expand -group fft_ctrl -color {Slate Blue} -radix unsigned /fft_control_tb/CONTROL/oBANK_RD_ROT
add wave -noupdate -expand -group fft_ctrl -color {Slate Blue} -radix unsigned /fft_control_tb/CONTROL/oBANK_WR_ROT
add wave -noupdate -expand -group fft_ctrl -color Gold -radix unsigned /fft_control_tb/CONTROL/oADDR_RD_0
add wave -noupdate -expand -group fft_ctrl -color Gold -radix unsigned /fft_control_tb/CONTROL/oADDR_RD_1
add wave -noupdate -expand -group fft_ctrl -color Gold -radix unsigned /fft_control_tb/CONTROL/oADDR_RD_2
add wave -noupdate -expand -group fft_ctrl -color Gold -radix unsigned /fft_control_tb/CONTROL/oADDR_RD_3
add wave -noupdate -expand -group fft_ctrl -color {Medium Orchid} -radix unsigned /fft_control_tb/CONTROL/oADDR_COEF
add wave -noupdate -expand -group fft_ctrl -color Sienna -radix unsigned /fft_control_tb/CONTROL/oADDR_WR
add wave -noupdate -expand -group fft_ctrl /fft_control_tb/CONTROL/oBUT_TYPE
add wave -noupdate -expand -group fft_ctrl /fft_control_tb/CONTROL/oRDY
add wave -noupdate -expand -group fft_ctrl -radix unsigned /fft_control_tb/CONTROL/cnt_stage_time
add wave -noupdate -expand -group fft_ctrl -color Plum -height 34 -radix unsigned /fft_control_tb/CONTROL/cnt_stage
add wave -noupdate -expand -group fft_ctrl -radix unsigned /fft_control_tb/CONTROL/cnt_block_time
add wave -noupdate -expand -group fft_ctrl -radix unsigned /fft_control_tb/CONTROL/cnt_block_time_tw
add wave -noupdate -expand -group fft_ctrl -radix binary -childformat {{{/fft_control_tb/CONTROL/block_mod[8]} -radix binary} {{/fft_control_tb/CONTROL/block_mod[7]} -radix binary} {{/fft_control_tb/CONTROL/block_mod[6]} -radix binary} {{/fft_control_tb/CONTROL/block_mod[5]} -radix binary} {{/fft_control_tb/CONTROL/block_mod[4]} -radix binary} {{/fft_control_tb/CONTROL/block_mod[3]} -radix binary} {{/fft_control_tb/CONTROL/block_mod[2]} -radix binary} {{/fft_control_tb/CONTROL/block_mod[1]} -radix binary} {{/fft_control_tb/CONTROL/block_mod[0]} -radix binary}} -subitemconfig {{/fft_control_tb/CONTROL/block_mod[8]} {-height 15 -radix binary} {/fft_control_tb/CONTROL/block_mod[7]} {-height 15 -radix binary} {/fft_control_tb/CONTROL/block_mod[6]} {-height 15 -radix binary} {/fft_control_tb/CONTROL/block_mod[5]} {-height 15 -radix binary} {/fft_control_tb/CONTROL/block_mod[4]} {-height 15 -radix binary} {/fft_control_tb/CONTROL/block_mod[3]} {-height 15 -radix binary} {/fft_control_tb/CONTROL/block_mod[2]} {-height 15 -radix binary} {/fft_control_tb/CONTROL/block_mod[1]} {-height 15 -radix binary} {/fft_control_tb/CONTROL/block_mod[0]} {-height 15 -radix binary}} /fft_control_tb/CONTROL/block_mod
add wave -noupdate -expand -group fft_ctrl -radix binary /fft_control_tb/CONTROL/coef_mod
add wave -noupdate -expand -group fft_ctrl -radix binary {/fft_control_tb/CONTROL/eof_block_delay[1]}
add wave -noupdate -expand -group fft_ctrl -radix binary {/fft_control_tb/CONTROL/eof_block_tw_delay[4]}
add wave -noupdate -expand -group fft_ctrl /fft_control_tb/CONTROL/debug
add wave -noupdate -expand -group fft_ctrl -radix binary {/fft_control_tb/CONTROL/addr_rd[0]}
add wave -noupdate -expand -group fft_ctrl -radix binary {/fft_control_tb/CONTROL/addr_rd[1]}
add wave -noupdate -expand -group fft_ctrl -radix binary {/fft_control_tb/CONTROL/addr_rd[2]}
add wave -noupdate -expand -group fft_ctrl -radix binary {/fft_control_tb/CONTROL/addr_rd[3]}
add wave -noupdate -expand -group vhdl_exmpl -color {Slate Blue} -radix unsigned /fft_control_tb/CONTROL_VHDL/INPUT_ROTATION_ro
add wave -noupdate -expand -group vhdl_exmpl -color {Slate Blue} -radix unsigned /fft_control_tb/CONTROL_VHDL/OUTPUT_ROTATION_ro
add wave -noupdate -expand -group vhdl_exmpl -color Gold -radix unsigned /fft_control_tb/CONTROL_VHDL/ADDR_RD_ro(0)
add wave -noupdate -expand -group vhdl_exmpl -color Gold -radix unsigned /fft_control_tb/CONTROL_VHDL/ADDR_RD_ro(1)
add wave -noupdate -expand -group vhdl_exmpl -color Gold -radix unsigned /fft_control_tb/CONTROL_VHDL/ADDR_RD_ro(2)
add wave -noupdate -expand -group vhdl_exmpl -color Gold -radix unsigned /fft_control_tb/CONTROL_VHDL/ADDR_RD_ro(3)
add wave -noupdate -expand -group vhdl_exmpl -color {Medium Orchid} -radix unsigned /fft_control_tb/CONTROL_VHDL/ADDR_COEF_ro
add wave -noupdate -expand -group vhdl_exmpl -color Sienna -radix unsigned /fft_control_tb/CONTROL_VHDL/ADDR_WR_ro(0)
add wave -noupdate -expand -group vhdl_exmpl -radix unsigned /fft_control_tb/CONTROL_VHDL/BUTTERFLY_MODE_ro
add wave -noupdate -expand -group vhdl_exmpl /fft_control_tb/CONTROL_VHDL/READY_ro
add wave -noupdate -expand -group vhdl_exmpl /fft_control_tb/CONTROL_VHDL/WRITE_EN_A_ro
add wave -noupdate -expand -group vhdl_exmpl /fft_control_tb/CONTROL_VHDL/WRITE_EN_B_ro
add wave -noupdate -expand -group vhdl_exmpl /fft_control_tb/CONTROL_VHDL/SOURCE_OF_DATA_ro
add wave -noupdate -expand -group vhdl_exmpl /fft_control_tb/CONTROL_VHDL/SOURCE_OF_CONTROL_ro
add wave -noupdate -expand -group vhdl_exmpl /fft_control_tb/CONTROL_VHDL/STOP_ro
add wave -noupdate -expand -group vhdl_exmpl -radix unsigned /fft_control_tb/CONTROL_VHDL/STAGE_INTRVL_CNTR
add wave -noupdate -expand -group vhdl_exmpl -radix unsigned /fft_control_tb/CONTROL_VHDL/STAGE_CNTR
add wave -noupdate -expand -group vhdl_exmpl -radix binary /fft_control_tb/CONTROL_VHDL/ENABLE_d
add wave -noupdate -expand -group vhdl_exmpl /fft_control_tb/CONTROL_VHDL/fr_END_OF_FFT
add wave -noupdate -expand -group vhdl_exmpl /fft_control_tb/CONTROL_VHDL/fr_END_OF_STAGE
add wave -noupdate -expand -group vhdl_exmpl /fft_control_tb/CONTROL_VHDL/fr_START_OF_STAGE
add wave -noupdate -expand -group vhdl_exmpl -childformat {{/fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(0) -radix binary -childformat {{/fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(0)(10) -radix binary} {/fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(0)(9) -radix binary} {/fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(0)(8) -radix binary} {/fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(0)(7) -radix binary} {/fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(0)(6) -radix binary} {/fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(0)(5) -radix binary} {/fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(0)(4) -radix binary} {/fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(0)(3) -radix binary} {/fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(0)(2) -radix binary} {/fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(0)(1) -radix binary} {/fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(0)(0) -radix binary}}} {/fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(1) -radix binary} {/fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(2) -radix binary} {/fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(3) -radix binary}} -expand -subitemconfig {/fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(0) {-height 15 -radix binary -childformat {{/fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(0)(10) -radix binary} {/fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(0)(9) -radix binary} {/fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(0)(8) -radix binary} {/fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(0)(7) -radix binary} {/fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(0)(6) -radix binary} {/fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(0)(5) -radix binary} {/fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(0)(4) -radix binary} {/fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(0)(3) -radix binary} {/fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(0)(2) -radix binary} {/fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(0)(1) -radix binary} {/fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(0)(0) -radix binary}}} /fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(0)(10) {-height 15 -radix binary} /fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(0)(9) {-height 15 -radix binary} /fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(0)(8) {-height 15 -radix binary} /fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(0)(7) {-height 15 -radix binary} /fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(0)(6) {-height 15 -radix binary} /fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(0)(5) {-height 15 -radix binary} /fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(0)(4) {-height 15 -radix binary} /fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(0)(3) {-height 15 -radix binary} /fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(0)(2) {-height 15 -radix binary} /fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(0)(1) {-height 15 -radix binary} /fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(0)(0) {-height 15 -radix binary} /fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(1) {-height 15 -radix binary} /fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(2) {-height 15 -radix binary} /fft_control_tb/CONTROL_VHDL/ADDR_ROTATE(3) {-height 15 -radix binary}} /fft_control_tb/CONTROL_VHDL/ADDR_ROTATE
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 3} {2164 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 201
configure wave -valuecolwidth 101
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {1923 ns} {2353 ns}
