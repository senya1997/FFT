onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /fft_tb/FFT/iCLK
add wave -noupdate -radix hexadecimal /fft_tb/FFT/iSTART
add wave -noupdate -radix hexadecimal /fft_tb/FFT/oRDY
add wave -noupdate -format Analog-Step -height 74 -max 32767.0 -min -32767.0 -radix decimal /fft_tb/data_adc
add wave -noupdate -radix hexadecimal /fft_tb/FFT/ROM_1/address
add wave -noupdate -radix hexadecimal /fft_tb/FFT/ROM_1/q
add wave -noupdate -radix hexadecimal /fft_tb/FFT/ROM_2/address
add wave -noupdate -radix hexadecimal /fft_tb/FFT/ROM_2/q
add wave -noupdate -radix hexadecimal /fft_tb/FFT/ROM_3/address
add wave -noupdate -radix hexadecimal /fft_tb/FFT/ROM_3/q
add wave -noupdate -expand -group A {/fft_tb/FFT/RAM_A/ram_bank[3]/RAM_RE/altsyncram_component/m_non_arria10/altsyncram_inst/mem_data}
add wave -noupdate -expand -group A {/fft_tb/FFT/RAM_A/ram_bank[3]/RAM_IM/altsyncram_component/m_non_arria10/altsyncram_inst/mem_data}
add wave -noupdate -expand -group A {/fft_tb/FFT/RAM_A/ram_bank[2]/RAM_RE/altsyncram_component/m_non_arria10/altsyncram_inst/mem_data}
add wave -noupdate -expand -group A {/fft_tb/FFT/RAM_A/ram_bank[2]/RAM_IM/altsyncram_component/m_non_arria10/altsyncram_inst/mem_data}
add wave -noupdate -expand -group A {/fft_tb/FFT/RAM_A/ram_bank[1]/RAM_RE/altsyncram_component/m_non_arria10/altsyncram_inst/mem_data}
add wave -noupdate -expand -group A {/fft_tb/FFT/RAM_A/ram_bank[1]/RAM_IM/altsyncram_component/m_non_arria10/altsyncram_inst/mem_data}
add wave -noupdate -expand -group A {/fft_tb/FFT/RAM_A/ram_bank[0]/RAM_RE/altsyncram_component/m_non_arria10/altsyncram_inst/mem_data}
add wave -noupdate -expand -group A {/fft_tb/FFT/RAM_A/ram_bank[0]/RAM_IM/altsyncram_component/m_non_arria10/altsyncram_inst/mem_data}
add wave -noupdate -expand -group B {/fft_tb/FFT/RAM_B/ram_bank[3]/RAM_RE/altsyncram_component/m_non_arria10/altsyncram_inst/mem_data}
add wave -noupdate -expand -group B {/fft_tb/FFT/RAM_B/ram_bank[3]/RAM_IM/altsyncram_component/m_non_arria10/altsyncram_inst/mem_data}
add wave -noupdate -expand -group B {/fft_tb/FFT/RAM_B/ram_bank[2]/RAM_RE/altsyncram_component/m_non_arria10/altsyncram_inst/mem_data}
add wave -noupdate -expand -group B {/fft_tb/FFT/RAM_B/ram_bank[2]/RAM_IM/altsyncram_component/m_non_arria10/altsyncram_inst/mem_data}
add wave -noupdate -expand -group B {/fft_tb/FFT/RAM_B/ram_bank[1]/RAM_RE/altsyncram_component/m_non_arria10/altsyncram_inst/mem_data}
add wave -noupdate -expand -group B {/fft_tb/FFT/RAM_B/ram_bank[1]/RAM_IM/altsyncram_component/m_non_arria10/altsyncram_inst/mem_data}
add wave -noupdate -expand -group B {/fft_tb/FFT/RAM_B/ram_bank[0]/RAM_RE/altsyncram_component/m_non_arria10/altsyncram_inst/mem_data}
add wave -noupdate -expand -group B {/fft_tb/FFT/RAM_B/ram_bank[0]/RAM_IM/altsyncram_component/m_non_arria10/altsyncram_inst/mem_data}
add wave -noupdate /fft_tb/FFT/CONTROL/oBUT_TYPE
add wave -noupdate /fft_tb/FFT/CONTROL/oSOURCE_CONT
add wave -noupdate /fft_tb/FFT/CONTROL/oSOURCE_DATA
add wave -noupdate /fft_tb/FFT/CONTROL/oWE_A
add wave -noupdate /fft_tb/FFT/CONTROL/oWE_B
add wave -noupdate /fft_tb/temp
add wave -noupdate /fft_tb/time_s
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {38060000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 182
configure wave -valuecolwidth 129
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
WaveRestoreZoom {0 ps} {210 us}
