transcript on

quit -sim

set path_vo D:/SS/fpga/fft/simulation/modelsim/fft.vo

project::addfile $path_vo
project::removefile $path_vo

project::compileall
vsim -novopt work.fft_control_tb

do D:/SS/fpga/fft/tb/wave/control.do
configure wave -timelineunits us