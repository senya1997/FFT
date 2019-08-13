`timescale 10ns/1ns
`include "../fft_defines.v"

`define NUM_OF_RPT 10 // number of repeat test

module fft_dac_tb; // AD5683

bit clk;
bit reset;
shortint i = 0;

bit dac_en;
bit [15:0] dac_data;
wire DAC_DATA, DAC_CS, DAC_SCL;

logic [19:0] resp_data = 20'b0;

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
	dac_en = 1'b0;
	
	#(100*`TACT); // pause before start
	
	$display("\n\n\t\tSTART SEND TO DAC\n");
	repeat(`NUM_OF_RPT)
		begin
			dac_data = $unsigned($random)%65535;
			if(i == (`NUM_OF_RPT - 2)) dac_data = 16'hAAAA; // check on "...101010..." data line
			if(i == (`NUM_OF_RPT - 1)) dac_data = 16'hFFFF; // -//- "...1111..."
			
			dac_en = 1'b1;
			#(`TACT);
			dac_en = 1'b0;
			#(`TACT);
			
			wait(DAC_CS);
				assert(resp_data == {4'b0011, dac_data}) 
					$display("\tOK:\tcontrol bits = 0b%b, data = 0b%b, 0d%d, 0x%h, %t", 
								resp_data[19:16], resp_data[15:0], resp_data[15:0], resp_data[15:0], $time);
				else 
					$display("\tER:\trec control bits = 0b%b, data = 0b%b, 0d%d, 0x%h,\n    \ttrans = 0b%b, 0d%d, 0x%h, %t", 
								resp_data[19:16], resp_data[15:0], resp_data[15:0], resp_data[15:0], 
								dac_data, dac_data, dac_data, $time);
			#(100*`TACT);
			
			resp_data = 20'b0;
			i = i + 1;
		end
	
	#(100*`TACT);
	$display("\n\t\tCOMPLETE\n");
	
	mti_fli::mti_Cmd("stop -sync");
end

// responce data for check in "assert":
always@(posedge dac_en) begin
	i = 19;
	wait(!DAC_CS);
	
	repeat(20)
		begin
			wait(!DAC_SCL);
			resp_data[i] = DAC_DATA;
			wait(DAC_SCL);
			
			i = i - 1;
		end
end

fft_dac DAC_AD5683(
	.iCLK(clk),
	.iRESET(reset),
	
	.iEN(dac_en),
	.iDATA(dac_data),
	
	.oDAC_DATA(DAC_DATA),
	.oDAC_CS(DAC_CS),
	.oDAC_CLK(DAC_SCL)
);

endmodule