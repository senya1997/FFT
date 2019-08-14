`timescale 1ns/1ns
`include "../fft_defines.v"

module fft_control_tb;
 
reg clk;
reg reset;

reg start;

wire RDY;

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
	$display("\t*                 START TEST CONTROL FFT                  *");
	$display("\t***********************************************************\n");
	
	start = 1'b0;	
		#(100*`TACT);
		#1;
	start = 1'b1;
		#(`TACT);
	start = 1'b0;
		#(`TACT);
	wait(RDY);
	
		#(1000*`TACT);
		#1;	
	start = 1'b1;
		#(`TACT);
	start = 1'b0;
		#(`TACT);
	wait(RDY);
	
		#(100*`TACT);
		
	$display("\n\t***********************************************************");	
	$display("\t*                         COMPLETE                        *");
	$display("\t***********************************************************\n");
	
	mti_fli::mti_Cmd("stop -sync");
end

fft_control CONTROL(
	.iCLK(clk),
	.iRESET(reset),
	
	.iSTART(start),
	
	.oBANK_RD_ROT(),
	.oBANK_WR_ROT(),
	
	.oADDR_RD_0(),
	.oADDR_RD_1(),
	.oADDR_RD_2(),
	.oADDR_RD_3(),
	
	.oADDR_WR(),
	
	.oADDR_COEF(),
	
	.oBUT_TYPE(),
	
	.oRDY(RDY)
);

FFT_Control_vhdl CONTROL_VHDL(
	.CLK(clk),
	.RESETsn(reset),
		   
	.START_i(start),                    
	.STOP_ro(),
	.READY_ro(),

	.SOURCE_OF_CONTROL_ro(),

	.BUTTERFLY_MODE_ro(),
	.SOURCE_OF_DATA_ro(),

	.ADDR_RD_ro(),

	.ADDR_WR_ro(),

	.WRITE_EN_A_ro(),
	.WRITE_EN_B_ro(),

	.ADDR_COEF_ro(),

	.INPUT_ROTATION_ro(),
	.OUTPUT_ROTATION_ro()
);

endmodule