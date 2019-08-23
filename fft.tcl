set_current_revision fft;
set work_pc 0
set compile 0
set upd_script 1

puts "**********   start   ***********"
puts " "

if {$work_pc} { set path_work D:/work 
} else { set path_work D:/SS/fpga }
	
set path_script	./tb/scripts
set path_modelsim $path_work/modelsim/fft/

if {$compile} {
	puts "compiling..."
	execute_flow -compile;
	
	puts "copy sdf..."
	file copy -force ./simulation/modelsim/fft_v.sdo $path_modelsim
}

if {$upd_script} {
	puts "copy scripts..."
	file copy -force $path_script/fft_control.do $path_modelsim
	file copy -force $path_script/fft_control_sdf.do $path_modelsim
	file copy -force $path_script/fft.do $path_modelsim
}
puts " "
puts "**********  complete  **********"