transcript on

quit -sim

# remove .vo from prj cause get error "need lib for sim with sdf"
	set path_vo ../../fft/simulation/modelsim/fft.vo
	project::addfile 	$path_vo
	project::removefile $path_vo

project::compileall
vsim -novopt fft_control_tb

do ../../fft/tb/wave/control.do
configure wave -timelineunits us