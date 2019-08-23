transcript on
set work_pc 0

quit -sim

if {$work_pc} { set path_work D:/work 
} else { 		set path_work D:/SS/fpga }

set path_vo $path_work/fft/simulation/modelsim/fft.vo

if {![file exist $path_vo]} { project::addfile $path_vo }

project::compileall

vsim -novopt fft_control_tb\
 -L altera_mf_ver -L altera_prim_ver -L cycloneiv_ver -L cycloneive_ver\
 -sdftyp /fft_control_tb/CONTROL=$path_work/modelsim/fft/fft_v.sdo

do $path_work/fft/tb/wave/control_sdf.do
configure wave -timelineunits us