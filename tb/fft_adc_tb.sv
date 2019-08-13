`timescale 10ns/1ns
`include "../fft_defines.v"

`define NUM_OF_RPT 10 // number of repeat test

module fft_adc_tb; // ADS8320

bit clk;
bit reset;

bit adc_en;

logic adc_ser_data = 1'b0;
bit [15:0] adc_par_data;

wire [15:0] ADC_OUT_DATA;
wire ADC_CS, ADC_SCL;
wire ADC_RDY;

initial begin
	$timeformat(-9,0," ns",1);
	clk = 1;
	forever	#(`HALF_TACT) clk = ~clk;
end

initial begin
	reset = 1'b1; #(2*`TACT);
	reset = 1'b0; #(`TACT);
	reset = 1'b1;
end

initial begin
	shortint i = 0;
	adc_en = 1'b0;
	
	#(100*`TACT); // pause before start
	
	$display("\n\n\t\tSTART SEND FROM ADC\n");
	repeat(`NUM_OF_RPT)
		begin
			adc_par_data = $unsigned($random)%65535;
			if(i == (`NUM_OF_RPT - 2)) adc_par_data = 16'hAAAA; // check on "...101010..." data line
			if(i == (`NUM_OF_RPT - 1)) adc_par_data = 16'hFFFF; // -//- "...1111..."
			
			adc_en = 1'b1;
			#(`TACT);
			adc_en = 1'b0;
			
			wait(ADC_RDY);
				assert(adc_par_data == ADC_OUT_DATA) 
					$display("OK:\t0b%b, 0d%d, 0x%h, %t", 
								ADC_OUT_DATA, ADC_OUT_DATA, ADC_OUT_DATA, $time);
				else 
					$display("ER:\trec   = 0b%b, 0d%d, 0x%h,\n   \ttrans = 0b%b, 0d%d, 0x%h, %t", 
								adc_par_data, adc_par_data, adc_par_data, 
								ADC_OUT_DATA, ADC_OUT_DATA, ADC_OUT_DATA, $time);
			#(100*`TACT);
			
			i = i + 1;
		end
	
	#(100*`TACT);
	$display("\n\t\tCOMPLETE\n");
	
	mti_fli::mti_Cmd("stop -sync");
end

// issue data in ADC:
always@(posedge adc_en) begin
	adc_ser_data = 1'bz;
	#(4*`TACT);
	
	wait(ADC_ADS8320.cnt_abs == 5);
	wait(!ADC_SCL);
	
	adc_ser_data = 1'b0;
	
	wait(ADC_SCL);
	wait(!ADC_SCL);
	
	repeat(16)
		begin
			if(ADC_ADS8320.cnt_abs <= 22)
				begin
					wait(!ADC_SCL);
					adc_ser_data = adc_par_data[21 - ADC_ADS8320.cnt_abs];
					wait(ADC_SCL);
				end
			else break;
		end
	
	wait(ADC_CS);
	#(4*`TACT);
end

fft_adc ADC_ADS8320(
	.iCLK(clk),
	.iRESET(reset),
	
	.iEN(adc_en),
	
	.iADC_DATA(adc_ser_data),
	.oADC_CS(ADC_CS),
	.oADC_SCL(ADC_SCL),
	
	.oDATA(ADC_OUT_DATA),
	.oRDY(ADC_RDY)
);

endmodule