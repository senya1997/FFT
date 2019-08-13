onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fft_mult_comp_tb/MULT/iCLK
add wave -noupdate -radix decimal /fft_mult_comp_tb/MULT/iRE
add wave -noupdate -radix decimal /fft_mult_comp_tb/MULT/iIM
add wave -noupdate -radix decimal /fft_mult_comp_tb/MULT/iW_RE
add wave -noupdate -radix decimal /fft_mult_comp_tb/MULT/iW_IM
add wave -noupdate -color Gold -radix decimal /fft_mult_comp_tb/MULT/oRE
add wave -noupdate -color Gold -radix decimal /fft_mult_comp_tb/MULT/oIM
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {7595 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 128
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ns} {2520 ns}
