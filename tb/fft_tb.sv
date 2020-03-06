`timescale 1ns/1ns
`include "../fft_defines.v"
`include "../fft_defines_tb.v"

`define N 4096
`define N_bank (`N/4) // cause Radix-4 

`ifdef TEST_MIXER
	`define NUM
`else
// choose test signal:
	`define SIN
	// `define AUDIO // from '.wav' file 
	// `define BIAS // integer const 
	// `define NUM // default test signal, numbers 0..N (function 'y = x', x > 0)
`endif

`ifdef SIN
	`undef AUDIO
	`undef BIAS
	`undef NUM
	
	// SIN spec:
		`define AMP_1 10000 // integer [`D_BIT - 2 : 0]
		`define AMP_2 5000
		`define AMP_NOISE 15000
		
		`define FREQ_1 9000 // integer Hz
		`define FREQ_2 4500
		
		`define PHASE_1 0 // float Rad
		`define PHASE_2 0.645
		
		`define BIAS 0 // integer ~ MAX_AMP/2 if use unsigned (by default - decimal format)
		`define TIME_STEP 2.267e-5 // = 1/Freq_desc
`elsif AUDIO
	`undef BIAS
	`undef NUM
	
	`define AUDIO_PATH "../../fft/matlab/impulses/g.wav"
`elsif BIAS
	`undef NUM
	
	`define CONST 100
`endif

module fft_tb;

bit clk;
bit reset;

shortint i, j;
real temp;

bit start;

`ifdef SIN
	real time_s = 0;
	real noise = 0;
`endif

`ifdef NUM
	shortint k = 0;
`endif
	
bit signed [`D_BIT - 2 : 0] data_adc; // '-2' because data from ADC don't have bit expansion
bit [`A_BIT - 1 : 0] addr_rd [0 : 3];
bit [`A_BIT - 1 : 0] addr_wr [0 : 3];
bit [3 : 0] we;

wire RDY;

import "DPI-C" function real signal(input real f, input real t, input real p);

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
		$display("\n\n\t\t\tSTART TEST FFT\n");
	`elsif TEST_MIXER
		$display("\n\n\t\tSTART TEST DATA MIXERS WITH CONTROL\n");
	`endif
	
	start = 1'b0;
	#(10*`TACT);
	
	`ifdef SIN
		$display("\ttest signal: sine wave with next config:");
		$display("\t  amp\t=\t%6d, %6d\n\t  freq\t=\t%6d, %6d Hz\n\t  phase\t=\t%6.3f, %6.3f Rad\n\t  bias\t=\t%6d\n\t  noise\t=\t%6d\n", 
				 `AMP_1, `AMP_2, `FREQ_1, `FREQ_2, `PHASE_1, `PHASE_2, `BIAS, `AMP_NOISE);
	`elsif AUDIO
		$display("\ttest signal: audio from path - ", `AUDIO_PATH, "\n");
	`elsif BIAS
		$display("\ttest signal: const = %d\n", `CONST);
	`elsif NUM
		$display("\ttest signal: numbers (function 'y = x')\n");
	`endif
	
	$display("\twrite ADC data point in RAM, time: %t\n", $time);
	
	for(i = 0; i <= 3; i = i + 1)
		for(j = 0; j < `N_bank; j = j + 1)
			begin
				`ifdef SIN
					noise = $unsigned($random)%(`AMP_NOISE);

					temp = `BIAS + `AMP_1*(signal(`FREQ_1, time_s, `PHASE_1)) + 
								   `AMP_2*(signal(`FREQ_2, time_s, `PHASE_2)) + noise;
								   
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
		
	#(10*`TACT);
	
	SAVE_RAM_DATA("start_ram_a_re.txt", "start_ram_a_im.txt", 0);
	
	$display("\n\tlaunch FFT, time: %t\n", $time);
	start = 1'b1;
		#(`TACT);
	start = 1'b0;
		#(`TACT);
	wait(RDY);
	
	#(10*`TACT);
	SAVE_RAM_DATA("ram_a_re.txt", "ram_a_im.txt", 0); // name must not change, this use in matlab 'analys'
	SAVE_RAM_DATA("ram_b_re.txt", "ram_b_im.txt", 0);
	
	$display("\n\t\t\tCOMPLETE\n");
	mti_fli::mti_Cmd("stop -sync");
end

always@(FFT.CONTROL.cnt_stage) begin
	case(FFT.CONTROL.cnt_stage)
		1: #(2*`TACT) SAVE_RAM_DATA("before_2st_ram_a_re.txt", "before_2st_ram_a_im.txt", 0);
		2: #(2*`TACT) SAVE_RAM_DATA("before_3st_ram_b_re.txt", "before_3st_ram_b_im.txt", 1);
		3: #(2*`TACT) SAVE_RAM_DATA("before_4st_ram_a_re.txt", "before_4st_ram_a_im.txt", 0);
		4: #(2*`TACT) SAVE_RAM_DATA("before_5st_ram_b_re.txt", "before_5st_ram_b_im.txt", 1);
		5: #(2*`TACT) SAVE_RAM_DATA("before_6st_ram_a_re.txt", "before_6st_ram_a_im.txt", 0);
	endcase	
end

task SAVE_RAM_DATA(string name_re, name_im, bit ram_sel); // 0 - RAM A, 1 - RAM B
	bit signed [`D_BIT - 1 : 0] buf_re_signed [0 : 3];
	bit signed [`D_BIT - 1 : 0] buf_im_signed [0 : 3];
	
	int f_ram_re;
	int f_ram_im;
	
	$display("\t *** save data from RAM in files: '%s', '%s', time: %t", name_re, name_im, $time);
	
	f_ram_re = $fopen(name_re, "w");
	f_ram_im = $fopen(name_im, "w");
	
	for(j = 0; j < `N_bank; j = j + 1)
		begin
		// cycle 'for' impossible to use because expression
		// '...RAM_A.ram_bank[i].RAM_RE...' provide to error in modelsim
		// number of bank memory must be the 'integer number', not a 'variable'
			if(ram_sel == 0)
				begin
					buf_re_signed[0] = FFT.RAM_A.ram_bank[0].RAM_RE.altsyncram_component.m_non_arria10.altsyncram_inst.mem_data[j];
					buf_im_signed[0] = FFT.RAM_A.ram_bank[0].RAM_IM.altsyncram_component.m_non_arria10.altsyncram_inst.mem_data[j];
					buf_re_signed[1] = FFT.RAM_A.ram_bank[1].RAM_RE.altsyncram_component.m_non_arria10.altsyncram_inst.mem_data[j];
					buf_im_signed[1] = FFT.RAM_A.ram_bank[1].RAM_IM.altsyncram_component.m_non_arria10.altsyncram_inst.mem_data[j];
					buf_re_signed[2] = FFT.RAM_A.ram_bank[2].RAM_RE.altsyncram_component.m_non_arria10.altsyncram_inst.mem_data[j];
					buf_im_signed[2] = FFT.RAM_A.ram_bank[2].RAM_IM.altsyncram_component.m_non_arria10.altsyncram_inst.mem_data[j];
					buf_re_signed[3] = FFT.RAM_A.ram_bank[3].RAM_RE.altsyncram_component.m_non_arria10.altsyncram_inst.mem_data[j];
					buf_im_signed[3] = FFT.RAM_A.ram_bank[3].RAM_IM.altsyncram_component.m_non_arria10.altsyncram_inst.mem_data[j];
				end
			else if(ram_sel == 1)
				begin
					buf_re_signed[0] = FFT.RAM_B.ram_bank[0].RAM_RE.altsyncram_component.m_non_arria10.altsyncram_inst.mem_data[j];
					buf_im_signed[0] = FFT.RAM_B.ram_bank[0].RAM_IM.altsyncram_component.m_non_arria10.altsyncram_inst.mem_data[j];
					buf_re_signed[1] = FFT.RAM_B.ram_bank[1].RAM_RE.altsyncram_component.m_non_arria10.altsyncram_inst.mem_data[j];
					buf_im_signed[1] = FFT.RAM_B.ram_bank[1].RAM_IM.altsyncram_component.m_non_arria10.altsyncram_inst.mem_data[j];
					buf_re_signed[2] = FFT.RAM_B.ram_bank[2].RAM_RE.altsyncram_component.m_non_arria10.altsyncram_inst.mem_data[j];
					buf_im_signed[2] = FFT.RAM_B.ram_bank[2].RAM_IM.altsyncram_component.m_non_arria10.altsyncram_inst.mem_data[j];
					buf_re_signed[3] = FFT.RAM_B.ram_bank[3].RAM_RE.altsyncram_component.m_non_arria10.altsyncram_inst.mem_data[j];
					buf_im_signed[3] = FFT.RAM_B.ram_bank[3].RAM_IM.altsyncram_component.m_non_arria10.altsyncram_inst.mem_data[j];
				end
			
			for(i = 0; i < 4; i = i + 1)
				begin
					$fwrite(f_ram_re, "%d", buf_re_signed[i], "\t\t");
					$fwrite(f_ram_im, "%d", buf_im_signed[i], "\t\t");
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