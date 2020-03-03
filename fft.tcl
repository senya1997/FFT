set_current_revision fft;

set compile 1
set upd_script 1

puts " "
puts "******************   START   *******************"
puts " "

set path_script	./tb/scripts
set path_modelsim ../modelsim/fft/

set test_mixer_str_num 189

if {$compile} {
	# check testbench defines for define TEST_MIXER which turn off part of RTL	
	set f_def [open ./fft_defines_tb.v r]
		seek $f_def $test_mixer_str_num
		set temp_str [gets $f_def] 
		set bool [string first // $temp_str]
		
		if {$bool != 0} {
			puts "\tWARNING: TEST_MIXER is enabled"
			post_message -type warning "TEST_MIXER is enabled"
		}
	close $f_def
	
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
puts "******************  COMPLETE  ******************"
puts " "