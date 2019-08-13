onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fft_tb/clk
add wave -noupdate -radix hexadecimal /fft_tb/adc_par_data
add wave -noupdate /fft_tb/adc_ser_data
add wave -noupdate -expand -group {main cnt} -radix unsigned /fft_tb/FFT/cnt_once_pack
add wave -noupdate -expand -group {main cnt} -radix unsigned /fft_tb/FFT/cnt_pack
add wave -noupdate -expand -group {main cnt} -radix unsigned /fft_tb/FFT/cnt_rem
add wave -noupdate -expand -group {main cnt} /fft_tb/FFT/FULL_PACK
add wave -noupdate -expand -group {main cnt} /fft_tb/FFT/ONCE_PACK
add wave -noupdate -expand -group {main cnt} /fft_tb/FFT/ONCE_SMPL
add wave -noupdate -expand -group ADC /fft_tb/FFT/ADC_EN
add wave -noupdate -expand -group ADC /fft_tb/FFT/ADC_RDY
add wave -noupdate -expand -group ADC -radix hexadecimal /fft_tb/FFT/ADC/oDATA
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 3} {594095 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 178
configure wave -valuecolwidth 120
configure wave -justifyvalue left
configure wave -signalnamewidth 2
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
WaveRestoreZoom {0 ns} {830467 ns}
