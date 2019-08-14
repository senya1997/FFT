transcript on

quit -sim
project::removefile D:/SS/fpga/fft/simulation/modelsim/fft.vo
project::compileall
vsim -novopt work.fft_control_tb

do D:/SS/fpga/fft/tb/wave/control.do
configure wave -timelineunits us