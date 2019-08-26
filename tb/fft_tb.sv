`timescale 1ns/1ns
`include "fft_defines.v"
  
module fft_tb;

bit clk;
bit reset;

real temp;
real time_s;

bit start;

bit signed [15 : 0] data_adc;
bit [8 : 0] addr_rd [0 : 3];
bit [8 : 0] addr_wr [0 : 3];
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
	shortint i, j;
	
	int f_ram_a_re, f_ram_a_im;
	int f_ram_b_re, f_ram_b_im;
	bit signed [16 : 0] buf_signed;
	
	$display("\n\n\t\t\tSTART TEST FFT\n");
	
	start = 1'b0;
	#(10*`TACT);
	
	$display("\twrite adc data point in ram, time: %t", $time);
	time_s = 0;
	
	for(i = 0; i <= 3; i = i + 1)
		for(j = 0; j < 512; j = j + 1)
			begin
				temp = 32767*(signal(1_000_000, time_s) + signal(400_000, time_s))/2;
				// temp = 32767*signal(2_000, time_s);
				
				data_adc = temp;
				// data_adc = $unsigned($random)%(65535);
				// data_adc = 16'd100;
				
				addr_wr[i] = j;
				
				we[i] = 1'b1;
					#(`TACT);
				we[i] = 1'b0;
				
				time_s = time_s + 1;
			end
		
	#(10*`TACT);
	
	$display("\tlaunch FFT, time: %t", $time);
	start = 1'b1;
		#(`TACT);
	start = 1'b0;
		#(`TACT);
	wait(RDY);
	
	#(10*`TACT);
	$display("\twrite data from RAM in files for matlab, time: %t", $time);
	
	f_ram_a_re = $fopen("ram_a_re.txt", "w");
	f_ram_a_im = $fopen("ram_a_im.txt", "w");
	f_ram_b_re = $fopen("ram_b_re.txt", "w");
	f_ram_b_im = $fopen("ram_b_im.txt", "w");
	
	for(j = 0; j < 512; j = j + 1)
		begin
			buf_signed = FFT.RAM_A.ram_bank[0].RAM_RE.altsyncram_component.m_non_arria10.altsyncram_inst.mem_data[j];
				$fwrite(f_ram_a_re, "%1d", buf_signed, "\n");
			buf_signed = FFT.RAM_A.ram_bank[1].RAM_RE.altsyncram_component.m_non_arria10.altsyncram_inst.mem_data[j];
				$fwrite(f_ram_a_re, "%1d", buf_signed, "\n");
			buf_signed = FFT.RAM_A.ram_bank[2].RAM_RE.altsyncram_component.m_non_arria10.altsyncram_inst.mem_data[j];
				$fwrite(f_ram_a_re, "%1d", buf_signed, "\n");
			buf_signed = FFT.RAM_A.ram_bank[3].RAM_RE.altsyncram_component.m_non_arria10.altsyncram_inst.mem_data[j];
				$fwrite(f_ram_a_re, "%1d", buf_signed, "\n");
		
			buf_signed = FFT.RAM_A.ram_bank[0].RAM_IM.altsyncram_component.m_non_arria10.altsyncram_inst.mem_data[j];
				$fwrite(f_ram_a_im, "%1d", buf_signed, "\n");
			buf_signed = FFT.RAM_A.ram_bank[1].RAM_IM.altsyncram_component.m_non_arria10.altsyncram_inst.mem_data[j];
				$fwrite(f_ram_a_im, "%1d", buf_signed, "\n");
			buf_signed = FFT.RAM_A.ram_bank[2].RAM_IM.altsyncram_component.m_non_arria10.altsyncram_inst.mem_data[j];
				$fwrite(f_ram_a_im, "%1d", buf_signed, "\n");
			buf_signed = FFT.RAM_A.ram_bank[3].RAM_IM.altsyncram_component.m_non_arria10.altsyncram_inst.mem_data[j];
				$fwrite(f_ram_a_im, "%1d", buf_signed, "\n");
			
			buf_signed = FFT.RAM_B.ram_bank[0].RAM_RE.altsyncram_component.m_non_arria10.altsyncram_inst.mem_data[j];
				$fwrite(f_ram_b_re, "%1d", buf_signed, "\n");
			buf_signed = FFT.RAM_B.ram_bank[1].RAM_RE.altsyncram_component.m_non_arria10.altsyncram_inst.mem_data[j];
				$fwrite(f_ram_b_re, "%1d", buf_signed, "\n");
			buf_signed = FFT.RAM_B.ram_bank[2].RAM_RE.altsyncram_component.m_non_arria10.altsyncram_inst.mem_data[j];
				$fwrite(f_ram_b_re, "%1d", buf_signed, "\n");
			buf_signed = FFT.RAM_B.ram_bank[3].RAM_RE.altsyncram_component.m_non_arria10.altsyncram_inst.mem_data[j];
				$fwrite(f_ram_b_re, "%1d", buf_signed, "\n");
			
			buf_signed = FFT.RAM_B.ram_bank[0].RAM_IM.altsyncram_component.m_non_arria10.altsyncram_inst.mem_data[j];
				$fwrite(f_ram_b_im, "%1d", buf_signed, "\n");
			buf_signed = FFT.RAM_B.ram_bank[1].RAM_IM.altsyncram_component.m_non_arria10.altsyncram_inst.mem_data[j];
				$fwrite(f_ram_b_im, "%1d", buf_signed, "\n");
			buf_signed = FFT.RAM_B.ram_bank[2].RAM_IM.altsyncram_component.m_non_arria10.altsyncram_inst.mem_data[j];
				$fwrite(f_ram_b_im, "%1d", buf_signed, "\n");
			buf_signed = FFT.RAM_B.ram_bank[3].RAM_IM.altsyncram_component.m_non_arria10.altsyncram_inst.mem_data[j];
				$fwrite(f_ram_b_im, "%1d", buf_signed, "\n");
		end
	
	
	$fclose(f_ram_a_re);
	$fclose(f_ram_a_im);
	$fclose(f_ram_b_re);
	$fclose(f_ram_b_im);
	
	$display("\n\t\t\tCOMPLETE\n");
	// mti_fli::mti_Cmd("stop -sync");
end

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

// package math_pkg;
  //// import dpi task      C Name = SV function name
  // import "DPI" pure function real cos (input real rTheta);
  // import "DPI" pure function real sin (input real rTheta);
  // import "DPI" pure function real log (input real rVal);
  // import "DPI" pure function real log10 (input real rVal);
// endpackage : math_pkg

// function real GET_SIN(input real time_s);
  // import math_pkg::*;
  
  // GET_SIN = `OFFSET + (`AMPL * sin(2*`PI*`FREQ*time_s));
// endfunction

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