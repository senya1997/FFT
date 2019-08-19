`include "fft_defines.v"

module fft_top(
	input	iCLK,
	input	iRESET,
	
	input [15 : 0] iDATA
);

wire [8 : 0] ADDR_COEF;
wire [11 : 0] W_RE [0 : 2];
wire [11 : 0] W_IM [0 : 2];

fft_control CONTROL(
	.iCLK(iCLK),
	.iRESET(iRESET),
	
	.iSTART(),
	
	.oBANK_RD_ROT(),
	.oBANK_WR_ROT(),
	
	.oADDR_RD_0(),
	.oADDR_RD_1(),
	.oADDR_RD_2(),
	.oADDR_RD_3(),
	
	.oADDR_WR(),
	
	.oADDR_COEF(ADDR_COEF),
	
	.oWE_A(),
	.oWE_B(),
	
	.oSOURCE_DATA(),
	.oSOURCE_CONT(),
	
	.oBUT_TYPE(),
	
	.oRDY()
);

// =================   memory   ===================

// ==================== RAM: ======================

	fft_ram_block RAM_A(
		.iCLK(iCLK),
	//	.iRESET(),
		
		.iDATA_RE_0(),
		.iDATA_IM_0(),
		.iDATA_RE_1(),
		.iDATA_IM_1(),
		.iDATA_RE_2(),
		.iDATA_IM_2(),
		.iDATA_RE_3(),
		.iDATA_IM_3(),
		
		.iADDR_RD_0(),
		.iADDR_RD_1(),
		.iADDR_RD_2(),
		.iADDR_RD_3(),
		
		.iADDR_WR_0(),
		.iADDR_WR_1(),
		.iADDR_WR_2(),
		.iADDR_WR_3(),

		.iWE_0(),
		.iWE_1(),
		.iWE_2(),
		.iWE_3(),
		
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
		.q({W_RE[0], W_IM[0]})
	);

/*	fft_rom #(.MIF("./matlab/rom_2.mif")) ROM_2(
		.address(ADDR_COEF),
		.clock(iCLK),
		.q({W_RE[1], W_IM[1]})
	);

	fft_rom #(.MIF("./matlab/rom_3.mif")) ROM_3(
		.address(ADDR_COEF),
		.clock(iCLK),
		.q({W_RE[2], W_IM[2]})
	); */

endmodule 