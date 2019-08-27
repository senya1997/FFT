transcript on
set work_pc 1

quit -sim

if {$work_pc} { set path_work D:/work 
} else { 		set path_work D:/SS/fpga }

#remove .vo from prj
	set path_vo $path_work/fft/simulation/modelsim/fft.vo	
	project::addfile 	$path_vo
	project::removefile $path_vo

project::compileall

	file copy -force $path_work/fft/tb/fft_tb.sv $path_work/modelsim/fft
	file copy -force $path_work/fft/fft_defines.v $path_work/modelsim/fft
	
#compile .c to .dll
	file copy -force $path_work/fft/tb/scripts/signal.c $path_work/modelsim/fft
	if {![file exist signal.dll]} { file delete -force signal.dll }
	
	if {$work_pc} { exec c:\mingw\bin\gcc -shared -o signal.dll signal.c
	} else { exec "D:/Program Files/mingw-w64/x86_64-8.1.0-posix-seh-rt_v6-rev0/mingw64/bin/gcc" -shared -o signal.dll signal.c }
		
#simulate	
	vlog fft_tb.sv
	vsim -L altera_mf_ver -c fft_tb -sv_lib signal -novopt