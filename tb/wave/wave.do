onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fft_control_tb/CONTROL/iCLK
add wave -noupdate /fft_control_tb/CONTROL/iSTART
add wave -noupdate -expand -group fft_ctrl -group logic -radix binary /fft_control_tb/CONTROL/addr_rd_mask
add wave -noupdate -expand -group fft_ctrl -group logic -radix unsigned /fft_control_tb/CONTROL/cnt_stage_time
add wave -noupdate -expand -group fft_ctrl -group logic -color Plum -height 34 -radix unsigned /fft_control_tb/CONTROL/cnt_stage
add wave -noupdate -expand -group fft_ctrl -group logic -radix unsigned /fft_control_tb/CONTROL/cnt_block_time
add wave -noupdate -expand -group fft_ctrl -group logic -radix unsigned /fft_control_tb/CONTROL/cnt_block_time_tw
add wave -noupdate -expand -group fft_ctrl -group logic -radix binary -childformat {{{/fft_control_tb/CONTROL/block_mod[8]} -radix binary} {{/fft_control_tb/CONTROL/block_mod[7]} -radix binary} {{/fft_control_tb/CONTROL/block_mod[6]} -radix binary} {{/fft_control_tb/CONTROL/block_mod[5]} -radix binary} {{/fft_control_tb/CONTROL/block_mod[4]} -radix binary} {{/fft_control_tb/CONTROL/block_mod[3]} -radix binary} {{/fft_control_tb/CONTROL/block_mod[2]} -radix binary} {{/fft_control_tb/CONTROL/block_mod[1]} -radix binary} {{/fft_control_tb/CONTROL/block_mod[0]} -radix binary}} -subitemconfig {{/fft_control_tb/CONTROL/block_mod[8]} {-height 15 -radix binary} {/fft_control_tb/CONTROL/block_mod[7]} {-height 15 -radix binary} {/fft_control_tb/CONTROL/block_mod[6]} {-height 15 -radix binary} {/fft_control_tb/CONTROL/block_mod[5]} {-height 15 -radix binary} {/fft_control_tb/CONTROL/block_mod[4]} {-height 15 -radix binary} {/fft_control_tb/CONTROL/block_mod[3]} {-height 15 -radix binary} {/fft_control_tb/CONTROL/block_mod[2]} {-height 15 -radix binary} {/fft_control_tb/CONTROL/block_mod[1]} {-height 15 -radix binary} {/fft_control_tb/CONTROL/block_mod[0]} {-height 15 -radix binary}} /fft_control_tb/CONTROL/block_mod
add wave -noupdate -expand -group fft_ctrl -group logic -radix binary /fft_control_tb/CONTROL/coef_mod
add wave -noupdate -expand -group fft_ctrl -group logic -radix binary {/fft_control_tb/CONTROL/eof_block_delay[1]}
add wave -noupdate -expand -group fft_ctrl -group logic -radix binary {/fft_control_tb/CONTROL/eof_block_tw_delay[4]}
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
add wave -noupdate -expand -group fft_ctrl -color Gray75 /fft_control_tb/CONTROL/oWE_A
add wave -noupdate -expand -group fft_ctrl -color Gray75 /fft_control_tb/CONTROL/oWE_B
add wave -noupdate -expand -group fft_ctrl -color Gray75 /fft_control_tb/CONTROL/oSOURCE_DATA
add wave -noupdate -expand -group fft_ctrl -color Gray75 /fft_control_tb/CONTROL/oSOURCE_CONT
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
add wave -noupdate -expand -group vhdl_exmpl -color Gray75 /fft_control_tb/CONTROL_VHDL/WRITE_EN_A_ro
add wave -noupdate -expand -group vhdl_exmpl -color Gray75 /fft_control_tb/CONTROL_VHDL/WRITE_EN_B_ro
add wave -noupdate -expand -group vhdl_exmpl -color Gray75 /fft_control_tb/CONTROL_VHDL/SOURCE_OF_DATA_ro
add wave -noupdate -expand -group vhdl_exmpl -color Gray75 /fft_control_tb/CONTROL_VHDL/SOURCE_OF_CONTROL_ro
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 3} {14407 ns} 0}
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
WaveRestoreZoom {0 ns} {44614 ns}
