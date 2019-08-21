`timescale 1ns/1ns
`include "../fft_defines.v"

module fft_tb;

bit clk;
bit reset;

bit start;

bit [15 : 0] data_adc;
bit [8 : 0] addr_rd [0 : 3];
bit [8 : 0] addr_wr [0 : 3];
bit [3 : 0] we;

wire RDY;

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
	
	$display("\n\n\t\t\tSTART TEST FFT\n\n");
	
	start = 1'b0;
	
	addr_rd[0] = 9'd0;
	addr_rd[1] = 9'd0;
	addr_rd[2] = 9'd0;
	addr_rd[3] = 9'd0;
	
	addr_wr[0] = 9'd0;
	addr_wr[1] = 9'd0;
	addr_wr[2] = 9'd0;
	addr_wr[3] = 9'd0;
	
	we = 4'd0;
	
	#(10*`TACT);
		
	for(i = 0; i <= 3; i = i + 1)
		for(j = 0; j < 512; j = j + 1)
			begin
				data_adc = $unsigned($random)%(65535);
				addr_wr[i] = j;
				
				we[i] = 1'b1;
					#(`TACT);
				we[i] = 1'b0;
			end
		
	#(10*`TACT);
		
	start = 1'b1;
		#(`TACT);
	start = 1'b0;
		#(`TACT);
	wait(RDY);
	
	#(100*`TACT);
	
	$display("\n\t\t\tCOMPLETE\n");
	mti_fli::mti_Cmd("stop -sync");
end

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