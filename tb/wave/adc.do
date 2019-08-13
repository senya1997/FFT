onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fft_adc_tb/ADC_ADS8320/iCLK
add wave -noupdate -radix hexadecimal /fft_adc_tb/adc_par_data
add wave -noupdate /fft_adc_tb/ADC_ADS8320/iEN
add wave -noupdate -color Gold -height 35 /fft_adc_tb/ADC_ADS8320/oADC_CS
add wave -noupdate -height 35 /fft_adc_tb/ADC_ADS8320/iADC_DATA
add wave -noupdate -color Thistle -height 35 /fft_adc_tb/ADC_ADS8320/oADC_SCL
add wave -noupdate -color {Medium Orchid} -height 35 -radix hexadecimal /fft_adc_tb/ADC_ADS8320/oDATA
add wave -noupdate -color Pink -height 35 /fft_adc_tb/ADC_ADS8320/oRDY
add wave -noupdate /fft_adc_tb/ADC_ADS8320/req_data
add wave -noupdate -radix unsigned /fft_adc_tb/ADC_ADS8320/cnt_abs
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {37717 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 204
configure wave -valuecolwidth 116
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
WaveRestoreZoom {0 ns} {146342 ns}
