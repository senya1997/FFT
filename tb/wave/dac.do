onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fft_dac_tb/DAC_AD5683/iCLK
add wave -noupdate /fft_dac_tb/DAC_AD5683/iEN
add wave -noupdate -radix hexadecimal /fft_dac_tb/DAC_AD5683/iDATA
add wave -noupdate -color Gold -height 35 /fft_dac_tb/DAC_AD5683/oDAC_CS
add wave -noupdate -color {Slate Blue} -height 35 /fft_dac_tb/DAC_AD5683/oDAC_CLK
add wave -noupdate -color Pink -height 35 /fft_dac_tb/DAC_AD5683/oDAC_DATA
add wave -noupdate -radix unsigned /fft_dac_tb/DAC_AD5683/cnt_abs
add wave -noupdate /fft_dac_tb/DAC_AD5683/req_data
add wave -noupdate /fft_dac_tb/resp_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 187
configure wave -valuecolwidth 132
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
WaveRestoreZoom {0 ns} {22838 ns}
