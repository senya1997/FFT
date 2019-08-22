transcript on
set work_pc 1

quit -sim

if {$work_pc} { set path_work D:/work/fft
} else { 		set path_work D:/SS/fpga/fft }

# remove .vo from prj cause get error "need lib for sim with sdf"
	set path_vo $path_work/simulation/modelsim/fft.vo
	project::addfile 	$path_vo
	project::removefile $path_vo

project::compileall
vsim -novopt fft_control_tb

do $path_work/tb/wave/control.do
configure wave -timelineunits us