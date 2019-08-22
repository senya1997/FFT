transcript on
set work_pc 1

quit -sim

if {$work_pc} { set path_work D:/work 
} else { 		set path_work D:/SS/fpga }

#compile .c to .dll
	file copy -force $path_work/fft/tb/scripts/signal.c $path_work/modelsim/fft
	if {![file exist signal.dll]} { file delete -force signal.dll }
	exec gcc -shared -o signal.dll signal.c

#remove .vo from prj
	set path_vo $path_work/fft/simulation/modelsim/fft.vo	
	project::addfile 	$path_vo
	project::removefile $path_vo

project::compileall

#simulate
	vsim -novopt -L altera_mf_ver -c fft_tb -sv_lib signal