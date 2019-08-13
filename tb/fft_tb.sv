`timescale 1ns/1ns
`include "../fft_defines.v"

module fft_tb;

bit clk;
bit reset;

logic adc_ser_data = 1'b0;
bit [15:0] adc_par_data;
wire ADC_CS, ADC_SCL;

initial begin
	$timeformat(-3, 3, " ms", 6);
	clk = 1;
	forever	#(`HALF_TACT) clk = ~clk;
end

initial begin
 	reset = 1'b1; #(2*`TACT);
	reset = 1'b0; #(`TACT);
	reset = 1'b1;
end

initial begin
	$display("\n\n\t***********************************************************");
	$display("\t*                          START                          *");
	$display("\t***********************************************************\n");
	
		#(10*`TACT);
	wait(FFT.FULL_PACK);
	wait(!FFT.FULL_PACK);
	
	wait(FFT.FULL_PACK);
	wait(!FFT.FULL_PACK);
	
	wait(FFT.FULL_PACK);
	wait(!FFT.FULL_PACK);
		#(10*`TACT);
		
	$display("\n\t***********************************************************");	
	$display("\t*                         COMPLETE                        *");
	$display("\t***********************************************************\n");
	mti_fli::mti_Cmd("stop -sync");
end

always@(posedge FFT.ADC_EN) begin
	adc_ser_data = 1'bz;
	#(4*`TACT);
	
	wait(FFT.ADC.cnt_abs == 5);
	wait(!ADC_SCL);
	
	adc_ser_data = 1'b0;
	adc_par_data =  $unsigned($random)%65535;
	
	wait(ADC_SCL);
	wait(!ADC_SCL);
	
	repeat(16)
		begin
			if(FFT.ADC.cnt_abs <= 22)
				begin
					wait(!ADC_SCL);
					adc_ser_data = adc_par_data[21 - FFT.ADC.cnt_abs];
					wait(ADC_SCL);
				end
			else break;
		end
	
	wait(ADC_CS);
	#(4*`TACT);
end

always@(posedge FFT.ADC_RDY) begin
	assert(FFT.ADC_DATA == adc_par_data) //$display("	OK: ADC data = 0b%b, 0d%d, 0x%h, %t", 
													//FFT.ADC_DATA, FFT.ADC_DATA, FFT.ADC_DATA, $time);
	else $display("	ER: ADC data = 0b%b, 0d%d, 0x%h,\n		trans data = 0b%b, 0d%d, 0x%h, %t", 
					FFT.ADC_DATA, FFT.ADC_DATA, FFT.ADC_DATA, 
					adc_par_data, adc_par_data, adc_par_data, $time);
end

fft_top FFT(
	.iCLK(clk),
	.iRESET(reset),
	
	// ADC:
	.iADC_DATA(adc_ser_data),
	.oADC_CS(ADC_CS),
	.oADC_SCL(ADC_SCL),
	
	// DAC:	
	.oDAC_DATA(),
	.oDAC_CS(),
	.oDAC_CLK()
);

endmodule