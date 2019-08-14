set_current_revision fft;
execute_flow -compile;

set path_sdf 		D:/SS/fpga/fft/simulation/modelsim/fft_v.sdo
set path_modelsim D:/SS/fpga/modelsim/fft/
file copy -force $path_sdf $path_modelsim
file copy -force D:/SS/fpga/fft/tb/scripts/fft_sdf.do $path_modelsim
file copy -force D:/SS/fpga/fft/tb/scripts/fft.do $path_modelsim