set_current_revision fft;
set work_pc 1

if {$work_pc} { set path_work D:/work 
} else { set path_work D:/SS/fpga }

#set path_prj		$path_work/fft

set path_sdf 		./simulation/modelsim/fft_v.sdo
set path_script	./tb/scripts

set script_0 fft.do
set script_1 fft_sdf.do

set path_modelsim $path_work/modelsim/fft/

puts "compiling..."
execute_flow -compile;

puts "copy sdf..."
file copy -force $path_sdf $path_modelsim

puts "copy scripts..."
file copy -force $path_script/$script_0 $path_modelsim
file copy -force $path_script/$script_1 $path_modelsim
