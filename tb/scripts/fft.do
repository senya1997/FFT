transcript on

quit -sim

set work_pc 0

#remove .vo from prj
	set path_vo ../../fft/simulation/modelsim/fft.vo	
	project::addfile 	$path_vo
	project::removefile $path_vo

project::compileall
	
#compile .c to .dll
	file copy -force ../../fft/tb/scripts/signal.c ../../modelsim/fft
	if {![file exist signal.dll]} { file delete -force signal.dll }
	
	if {$work_pc} { exec c:/mingw/bin/gcc -shared -o signal.dll signal.c
	} else { exec "D:/Program Files/mingw-w64/x86_64-8.1.0-posix-seh-rt_v6-rev0/mingw64/bin/gcc" -shared -o signal.dll signal.c }
		
#simulate	
	#vlog fft_tb.sv
	vsim -L altera_mf_ver -c fft_tb -sv_lib signal -novopt
	
do ../../fft/tb/wave/wave.do
configure wave -timelineunits us