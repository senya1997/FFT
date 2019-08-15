set_current_revision fft;
set path_prj		D:/SS/fpga/fft

set path_sdf 		$path_prj/simulation/modelsim/fft_v.sdo
set path_script	$path_prj/tb/scripts

set script_0 fft.do
set script_1 fft_sdf.do

set path_modelsim D:/SS/fpga/modelsim/fft/

puts "compiling..."
execute_flow -compile;

puts "copy sdf..."
file copy -force $path_sdf $path_modelsim

puts "copy scripts..."
file copy -force $path_script/$script_0 $path_modelsim
file copy -force $path_script/$script_1 $path_modelsim
