`include "fft_defines.v"

module fft_top(
	input	iCLK,
	input	iRESET,
	
	input iSTART,
	
	input [15 : 0] iDATA,
	
	input [8 : 0] iADDR_RD_0,
	input [8 : 0] iADDR_RD_1,
	input [8 : 0] iADDR_RD_2,
	input [8 : 0] iADDR_RD_3,

	input [8 : 0] iADDR_WR_0,
	input [8 : 0] iADDR_WR_1,
	input [8 : 0] iADDR_WR_2,
	input [8 : 0] iADDR_WR_3,
	
	input iWE_0,
	input iWE_1,
	input iWE_2,
	input iWE_3,	
	
	output oRDY
);

reg start;

wire [1 : 0] BANK_RD_ROT;
wire [1 : 0] BANK_WR_ROT;

wire [16 : 0] DATA_RE_IN [0 : 3];
	assign DATA_RE_IN[0] = start ?  : {1'b0, iDATA};
	assign DATA_RE_IN[1] = start ?  : {1'b0, iDATA};
	assign DATA_RE_IN[2] = start ?  : {1'b0, iDATA};
	assign DATA_RE_IN[3] = start ?  : {1'b0, iDATA};

wire [8 : 0] ADDR_RD_CTRL [0 : 3];
wire [8 : 0] ADDR_RD [0 : 3];
	assign ADDR_RD[0] = start ? ADDR_RD_CTRL[0] : iADDR_RD_0;
	assign ADDR_RD[1] = start ? ADDR_RD_CTRL[1] : iADDR_RD_1;
	assign ADDR_RD[2] = start ? ADDR_RD_CTRL[2] : iADDR_RD_2;
	assign ADDR_RD[3] = start ? ADDR_RD_CTRL[3] : iADDR_RD_3;

wire [8 : 0] ADDR_WR_CTRL;	
wire [8 : 0] ADDR_WR [0 : 3];
	assign ADDR_WR[0] = start ? ADDR_WR_CTRL : iADDR_WR_0;
	assign ADDR_WR[1] = start ? ADDR_WR_CTRL : iADDR_WR_1;
	assign ADDR_WR[2] = start ? ADDR_WR_CTRL : iADDR_WR_2;
	assign ADDR_WR[3] = start ? ADDR_WR_CTRL : iADDR_WR_3;

wire WE_A_CTRL;
wire WE_B_CTRL;
wire [3 : 0] WE;
	assign WE[0] = start ? WE_A_CTRL : iWE_0;
	assign WE[1] = start ? WE_A_CTRL : iWE_1;
	assign WE[2] = start ? WE_A_CTRL : iWE_2;
	assign WE[3] = start ? WE_A_CTRL : iWE_3;
	
wire [8 : 0] ADDR_COEF;
wire [11 : 0] W_RE [1 : 3];
wire [11 : 0] W_IM [1 : 3];

always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) start <= 1'b0;
	else if(iSTART) start <= 1'b1;
	else if(oRDY) start <= 1'b0;
end

wire [16 : 0] DATA_RE_RAM_A [0 : 3];
wire [16 : 0] DATA_IM_RAM_A [0 : 3];
wire [16 : 0] DATA_RE_RAM_B [0 : 3];
wire [16 : 0] DATA_IM_RAM_B [0 : 3];

wire SOURCE_DATA;
	

// =================   control   ===================

fft_control CONTROL(
	.iCLK(iCLK),
	.iRESET(iRESET),
	
	.iSTART(iSTART),
	
	.oBANK_RD_ROT(BANK_RD_ROT),
	.oBANK_WR_ROT(BANK_WR_ROT),
	
	.oADDR_RD_0(ADDR_RD_CTRL[0]),
	.oADDR_RD_1(ADDR_RD_CTRL[1]),
	.oADDR_RD_2(ADDR_RD_CTRL[2]),
	.oADDR_RD_3(ADDR_RD_CTRL[3]),
	
	.oADDR_WR(ADDR_WR_CTRL),
	
	.oADDR_COEF(ADDR_COEF),
	
	.oWE_A(WE_A_CTRL),
	.oWE_B(WE_B_CTRL),
	
	.oSOURCE_DATA(SOURCE_DATA),
	.oSOURCE_CONT(),
	
	.oBUT_TYPE(),
	
	.oRDY(oRDY)
);

// =================   rotator   ===================

	fft_input_mix INPUT_MIX(
		.iCLK(iCLK),
		.iRESET(iRESET),
		
		.iSEL(BANK_RD_ROT),
		
		.iX0_RE(),
		.iX0_IM(),
		.iX1_RE(),
		.iX1_IM(),
		.iX2_RE(),
		.iX2_IM(),
		.iX3_RE(),
		.iX3_IM(),
		
		.oY0_RE(),
		.oY0_IM(),
		.oY1_RE(),
		.oY1_IM(),
		.oY2_RE(),
		.oY2_IM(),
		.oY3_RE(),
		.oY3_IM()
	);
	
	fft_output_mix OUTPUT_MIX(
		.iCLK(iCLK),
		.iRESET(iRESET),
		
		.iSEL(BANK_WR_ROT),
		
		.iX0_RE(),
		.iX0_IM(),
		.iX1_RE(),
		.iX1_IM(),
		.iX2_RE(),
		.iX2_IM(),
		.iX3_RE(),
		.iX3_IM(),
		
		.oY0_RE(),
		.oY0_IM(),
		.oY1_RE(),
		.oY1_IM(),
		.oY2_RE(),
		.oY2_IM(),
		.oY3_RE(),
		.oY3_IM()
	);
	
// =================   memory   ===================

// ==================== RAM: ======================

	fft_ram_block RAM_A(
		.iCLK(iCLK),
		
		.iDATA_RE_0(DATA_RE_IN[0]),
		.iDATA_IM_0(),
		.iDATA_RE_1(DATA_RE_IN[1]),
		.iDATA_IM_1(),
		.iDATA_RE_2(DATA_RE_IN[2]),
		.iDATA_IM_2(),
		.iDATA_RE_3(DATA_RE_IN[3]),
		.iDATA_IM_3(),
		
		.iADDR_RD_0(ADDR_RD[0]),
		.iADDR_RD_1(ADDR_RD[1]),
		.iADDR_RD_2(ADDR_RD[2]),
		.iADDR_RD_3(ADDR_RD[3]),
		
		.iADDR_WR_0(ADDR_WR[0]),
		.iADDR_WR_1(ADDR_WR[1]),
		.iADDR_WR_2(ADDR_WR[2]),
		.iADDR_WR_3(ADDR_WR[3]),

		.iWE_0(WE[0]),
		.iWE_1(WE[1]),
		.iWE_2(WE[2]),
		.iWE_3(WE[3]),
		
		.oDATA_RE_0(),
		.oDATA_IM_0(),
		.oDATA_RE_1(),
		.oDATA_IM_1(),
		.oDATA_RE_2(),
		.oDATA_IM_2(),
		.oDATA_RE_3(),
		.oDATA_IM_3()
	);
	
	fft_ram_block RAM_B(
		.iCLK(iCLK),
		
		.iDATA_RE_0(),
		.iDATA_IM_0(),
		.iDATA_RE_1(),
		.iDATA_IM_1(),
		.iDATA_RE_2(),
		.iDATA_IM_2(),
		.iDATA_RE_3(),
		.iDATA_IM_3(),
		
		.iADDR_RD_0(ADDR_RD_CTRL[0]),
		.iADDR_RD_1(ADDR_RD_CTRL[1]),
		.iADDR_RD_2(ADDR_RD_CTRL[2]),
		.iADDR_RD_3(ADDR_RD_CTRL[3]),
		
		.iADDR_WR_0(ADDR_WR_CTRL),
		.iADDR_WR_1(ADDR_WR_CTRL),
		.iADDR_WR_2(ADDR_WR_CTRL),
		.iADDR_WR_3(ADDR_WR_CTRL),

		.iWE_0(WE_B_CTRL),
		.iWE_1(WE_B_CTRL),
		.iWE_2(WE_B_CTRL),
		.iWE_3(WE_B_CTRL),
		
		.oDATA_RE_0(),
		.oDATA_IM_0(),
		.oDATA_RE_1(),
		.oDATA_IM_1(),
		.oDATA_RE_2(),
		.oDATA_IM_2(),
		.oDATA_RE_3(),
		.oDATA_IM_3()
	);	

// ==================== ROM: ======================

	fft_rom #(.MIF("./matlab/rom_1.mif")) ROM_1(
		.address(ADDR_COEF),
		.clock(iCLK),
		.q({W_RE[1], W_IM[1]})
	);

	fft_rom #(.MIF("./matlab/rom_2.mif")) ROM_2(
		.address(ADDR_COEF),
		.clock(iCLK),
		.q({W_RE[2], W_IM[2]})
	);

	fft_rom #(.MIF("./matlab/rom_3.mif")) ROM_3(
		.address(ADDR_COEF),
		.clock(iCLK),
		.q({W_RE[3], W_IM[3]})
	);

endmodule 