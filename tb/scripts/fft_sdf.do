transcript on

quit -sim
project::addfile "D:/SS/fpga/fft/simulation/modelsim/fft.vo"
project::compileall
vsim -novopt work.fft_control_tb -L altera_mf_ver -L altera_prim_ver -L cycloneiv_ver -L cycloneive_ver -sdftyp /fft_control_tb/CONTROL=D:/SS/fpga/modelsim/fft/fft_v.sdo

do D:/SS/fpga/fft/tb/wave/control_sdf.do
configure wave -timelineunits us