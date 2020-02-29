transcript on

quit -sim

set path_vo ../../fft/simulation/modelsim/fft.vo

if {![file exist $path_vo]} { project::addfile $path_vo }

project::compileall

vsim -novopt fft_control_tb\
 -L altera_mf_ver -L altera_prim_ver -L cycloneiv_ver -L cycloneive_ver\
 -sdftyp /fft_control_tb/CONTROL=../../modelsim/fft/fft_v.sdo

do ../../fft/tb/wave/control_sdf.do
configure wave -timelineunits us