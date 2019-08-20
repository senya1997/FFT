transcript on
set work_pc 1

quit -sim

if {$work_pc} { set path_work D:/work 
} else { set path_work D:/SS/fpga }

set path_vo $path_work/fft/simulation/modelsim/fft.vo

project::addfile 	$path_vo
project::removefile $path_vo

project::compileall
vsim -novopt work.fft_control_tb

do $path_work/fft/tb/wave/control.do
configure wave -timelineunits us