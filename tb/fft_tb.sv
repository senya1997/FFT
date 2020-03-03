`timescale 1ns/1ns
`include "../fft_defines.v"
`include "../fft_defines_tb.v"

`define N 4096
`define N_bank (`N/4) // cause Radix-4 

// choose test signal:
	// `define SIN
	// `define AUDIO // from '.wav' file 
	`define BIAS // integer const 
	// `define NUM // default test signal, numbers 0..N (function 'y = x', x > 0)

`ifdef TEST_MIXER
	`undef SIN
	`undef AUDIO
	`undef BIAS
	
	`define NUM
`endif

`ifdef SIN
	`undef AUDIO
	`undef BIAS
	`undef NUM
	
	// SIN spec:
		`define AMP_1 10000
		`define AMP_2 5000
		
		`define FREQ_1 9000
		`define FREQ_2 4500
		
		`define PHASE_1 0
		`define PHASE_2 37
		
		`define BIAS `AMP_1
		`define TIME_STEP 0.0001
`elsif AUDIO
	`undef BIAS
	`undef NUM
	
	`define AUDIO_PATH "../../fft/matlab/impulses/g.wav"
`elsif BIAS
	`undef NUM
	
	`define CONST 100
`elsif
	`define NUM
`endif

module fft_tb;

bit clk;
bit reset;

shortint i, j;
real temp;
bit flag_en_save_ram = 0;

bit start;

`ifdef SIN
	real time_s = 0;
`endif

`ifdef NUM
	shortint k = 0;
`endif
	
bit signed [`D_BIT - 2 : 0] data_adc; // '-2' because data from ADC don't have bit expansion
bit [`A_BIT - 1 : 0] addr_rd [0 : 3];
bit [`A_BIT - 1 : 0] addr_wr [0 : 3];
bit [3 : 0] we;

wire RDY;

import "DPI-C" function real signal(input real f, input real t);

initial begin
	$timeformat(-6, 3, " us", 6);
	clk = 1;
	forever	#(`HALF_TACT) clk = ~clk;
end

initial begin
 	reset = 1'b1; #(2*`TACT);
	reset = 1'b0; #(`TACT);
	reset = 1'b1;
end

initial begin
	`ifdef TEST_FFT
		$display("\n\n\t\tSTART TEST FFT\n");
	`elsif TEST_MIXER
		$display("\n\n\t\tSTART TEST DATA MIXERS WITH CONTROL\n");
	`endif
	
	start = 1'b0;
	#(10*`TACT);
	
	`ifdef SIN
		$display("\ttest signal: sine wave with next config");
		$display("\tamp = %d, %d, freq = %d, %d, phase = %d, %d, bias = %d\n", 
				 `AMP_1, `AMP_2, `FREQ_1, `FREQ_2, `PHASE_1, `PHASE_2, `BIAS);
	`elsif AUDIO
		$display("\ttest signal: audio from path - ", `AUDIO_PATH, "\n");
	`elsif BIAS
		$display("\ttest signal: const = %d\n", `CONST);
	`elsif NUM
		$display("\ttest signal: numbers (function 'y = x')\n");
	`endif
	
	$display("\twrite ADC data point in RAM, time: %t", $time);
	
	for(i = 0; i <= 3; i = i + 1)
		for(j = 0; j < `N_bank; j = j + 1)
			begin
				`ifdef SIN
					// temp = 20000*signal(48.828125, time_s);
					// temp = $unsigned($random)%(65535);
					temp = `BIAS + `AMP_1*(signal(`FREQ_1, time_s) + `AMP_2*signal(`FREQ_2, time_s))/2;
					time_s = time_s + `TIME_STEP;
				`elsif AUDIO
				
				`elsif BIAS
					temp = `CONST;
				`elsif NUM
					temp = k;
					k = k + 1;
				`endif
				
				data_adc = temp;
				
				addr_wr[i] = j;
				
				we[i] = 1'b1;
					#(`TACT);
				we[i] = 1'b0;
			end
			
	SAVE_RAM_DATA("1st_ram_a_re.txt", "1st_ram_a_im.txt", 0);
	flag_en_save_ram = 1;	
	#(10*`TACT);
	
	$display("\tlaunch FFT, time: %t", $time);
	start = 1'b1;
		#(`TACT);
	start = 1'b0;
		#(`TACT);
	wait(RDY);
	
	#(10*`TACT);
	SAVE_RAM_DATA("ram_a_re.txt", "ram_a_im.txt", 0);
	
	$display("\n\t\t\tCOMPLETE\n");
	mti_fli::mti_Cmd("stop -sync");
end

always@(FFT.CONTROL.cnt_stage) begin
	if(flag_en_save_ram)
		case(FFT.CONTROL.cnt_stage)
			// 1: #(2*`TACT) SAVE_RAM_DATA("1st_ram_b_re.txt", "1st_ram_b_im.txt", 1);
			2: #(2*`TACT) SAVE_RAM_DATA("2st_ram_b_re.txt", "2st_ram_b_im.txt", 1);
			3: #(2*`TACT) SAVE_RAM_DATA("3st_ram_a_re.txt", "3st_ram_a_im.txt", 0);
			4: #(2*`TACT) SAVE_RAM_DATA("4st_ram_b_re.txt", "4st_ram_b_im.txt", 1);
			5: #(2*`TACT) SAVE_RAM_DATA("5st_ram_a_re.txt", "5st_ram_a_im.txt", 0);
			0: #(2*`TACT) SAVE_RAM_DATA("6st_ram_b_re.txt", "6st_ram_b_im.txt", 1);
		endcase	
end

task SAVE_RAM_DATA(string name_re, name_im, bit ram_sel); // 0 - RAM A, 1 - RAM B
	bit signed [`D_BIT - 1 : 0] buf_re_signed;
	bit signed [`D_BIT - 1 : 0] buf_im_signed;
	
	int f_ram_re;
	int f_ram_im;
	
	$display("\t* save data from RAM in files %s, time: %t", name_re, $time);
	
	f_ram_re = $fopen(name_re, "w");
	f_ram_im = $fopen(name_im, "w");
	
	for(j = 0; j < `N_bank; j = j + 1)
		begin
			for(i = 0; i < 4; i = i + 1)
				begin
					if(ram_sel == 0)
						begin
							buf_re_signed = FFT.RAM_A.ram_bank[i].RAM_RE.altsyncram_component.m_non_arria10.altsyncram_inst.mem_data[j];
							buf_im_signed = FFT.RAM_A.ram_bank[i].RAM_IM.altsyncram_component.m_non_arria10.altsyncram_inst.mem_data[j];
						end
					else if(ram_sel == 1)
						begin
							buf_re_signed = FFT.RAM_B.ram_bank[i].RAM_RE.altsyncram_component.m_non_arria10.altsyncram_inst.mem_data[j];
							buf_im_signed = FFT.RAM_B.ram_bank[i].RAM_IM.altsyncram_component.m_non_arria10.altsyncram_inst.mem_data[j];
						end
						
					$fwrite(f_ram_re, "%d", buf_re_signed, "\t\t");
					$fwrite(f_ram_im, "%d", buf_im_signed, "\t\t");
				end
				
			$fwrite(f_ram_re, "\n");
			$fwrite(f_ram_im, "\n");
		end
		
	$fclose(f_ram_re);
	$fclose(f_ram_im);
endtask

/*
real f, t, h_t; //frequency, time, time step 
real fmin,fmax,h; //minimum frequency, maximum frequency, frequency step
real out;

initial begin

	fmin = 50_000; //Hz
	fmax = 1_000_000; //Hz
	h = 1_000; //Hz
	h_t = 0.000_000_01; //step time = 1/(time scale) (sec)
	
	for (f = fmin; f <= fmax; f = f + h) begin
		for (t = 0; t <= 1/f; t = t + h_t) begin
			#10 out = signal(f,t);
			//$display (signal(f,t));			
		end
	end
end
*/

/*
package math_pkg;
  // import dpi task      C Name = SV function name
  import "DPI" pure function real cos (input real rTheta);
  import "DPI" pure function real sin (input real rTheta);
  import "DPI" pure function real log (input real rVal);
  import "DPI" pure function real log10 (input real rVal);
endpackage : math_pkg

function real GET_SIN(input real time_s);
  import math_pkg::*;
  
  GET_SIN = `OFFSET + (`AMPL * sin(2*`PI*`FREQ*time_s));
endfunction
*/

fft_top FFT(
	.iCLK(clk),
	.iRESET(reset),
	
	.iSTART(start),
	
	.iDATA(data_adc),
	
	.iADDR_RD_0(addr_rd[0]),
	.iADDR_RD_1(addr_rd[1]),
	.iADDR_RD_2(addr_rd[2]),
	.iADDR_RD_3(addr_rd[3]),

	.iADDR_WR_0(addr_wr[0]),
	.iADDR_WR_1(addr_wr[1]),
	.iADDR_WR_2(addr_wr[2]),
	.iADDR_WR_3(addr_wr[3]),
	
	.iWE_0(we[0]),
	.iWE_1(we[1]),
	.iWE_2(we[2]),
	.iWE_3(we[3]),	
	
	.oDATA_RE_0(),
	.oDATA_RE_1(),
	.oDATA_RE_2(),
	.oDATA_RE_3(),
	
	.oRDY(RDY)
);

endmodule