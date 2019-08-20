`timescale 1ns/1ns
`include "../fft_defines.v"

`define COMP_PER 50 // period of compare output signals "VHDL" and "DUT" in tact
`define NUM_OF_RPT 3 // number of repeat test

module fft_control_tb;
 
reg clk;
reg reset;

reg start;
reg start_d;

wire [1 : 0] BANK_RD_ROT [0 : 1]; // 0 - DUT, 1 - vhdl original
wire [1 : 0] BANK_WR_ROT [0 : 1];

wire [8 : 0] ADDR_WR_DUT;
wire [8 : 0] ADDR_WR_VHDL [0 : 3]; // 0..3 addr write is match

wire [8 : 0] ADDR_COEF [0 : 1];

wire [8 : 0] ADDR_RD_DUT [0 : 3];
wire [8 : 0] ADDR_RD_VHDL [0 : 3];

// wire WE_A,
// wire WE_B,

// wire SOURCE_DATA,
// wire SOURCE_CONT,

// wire BUT_TYPE,
	
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
	bit flag_er = 1'b0;
	
	start = 1'b0;
	start_d = 1'b0;
	
	#(100*`TACT);
	$display("\n\n\t\t\tSTART TEST CONTROL FFT\n\n");
	
	repeat(`NUM_OF_RPT)
		begin
				#1; // if "sdf" is turn off
			start = 1'b1;
				#(`TACT);
			start = 1'b0;
			
			start_d = 1'b1;
				#(`TACT);
			start_d = 1'b0;
				#(`TACT - 1); // compensetion "#1" 
	
			while(!RDY)
				begin
					if(BANK_RD_ROT[0] != BANK_RD_ROT[1]) begin	$display("\tinput rotation	does't match, time: %t", $time); flag_er = 1'b1; end
					if(BANK_WR_ROT[0] != BANK_WR_ROT[1]) begin	$display("\toutput rotation	does't match, time: %t", $time); flag_er = 1'b1; end
					
					if( ADDR_RD_DUT[0] != ADDR_RD_VHDL[0] | 
						ADDR_RD_DUT[1] != ADDR_RD_VHDL[1] |
						ADDR_RD_DUT[2] != ADDR_RD_VHDL[2] | 
						ADDR_RD_DUT[3] != ADDR_RD_VHDL[3])begin $display("\taddr read		does't match, time: %t", $time); flag_er = 1'b1; end
					
					if(ADDR_COEF[0] != ADDR_COEF[1]) begin 		$display("\taddr coef		does't match, time: %t", $time); flag_er = 1'b1; end
					if(ADDR_WR_DUT != ADDR_WR_VHDL[0]) begin	$display("\taddr write		does't match, time: %t", $time); flag_er = 1'b1; end
					
					if(flag_er) $display();
					flag_er = 1'b0;
					#(`COMP_PER * `TACT);
				end
				
			#(100*`TACT);
		end
		
	$display("\n\t\t\t\tCOMPLETE\n");
	mti_fli::mti_Cmd("stop -sync");
end

fft_control CONTROL(
	.iCLK(clk),
	.iRESET(reset),
	
	.iSTART(start_d), // there is delay between output signals "DUT control" and "vhdl" in 1 tact
	
	.oBANK_RD_ROT(BANK_RD_ROT[0]),
	.oBANK_WR_ROT(BANK_WR_ROT[0]),
	
	.oADDR_RD_0(ADDR_RD_DUT[0]),
	.oADDR_RD_1(ADDR_RD_DUT[1]),
	.oADDR_RD_2(ADDR_RD_DUT[2]),
	.oADDR_RD_3(ADDR_RD_DUT[3]),
	
	.oADDR_WR(ADDR_WR_DUT),
	
	.oADDR_COEF(ADDR_COEF[0]),
	
	.oWE_A(),
	.oWE_B(),
	
	.oSOURCE_DATA(),
	.oSOURCE_CONT(),
	
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

	.ADDR_RD_ro(ADDR_RD_VHDL),

	.ADDR_WR_ro(ADDR_WR_VHDL),

	.WRITE_EN_A_ro(),
	.WRITE_EN_B_ro(),

	.ADDR_COEF_ro(ADDR_COEF[1]),

	.INPUT_ROTATION_ro(BANK_RD_ROT[1]),
	.OUTPUT_ROTATION_ro(BANK_WR_ROT[1])
);

endmodule