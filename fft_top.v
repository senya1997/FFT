`include "fft_defines.v"

//`define WORK

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
	
	output [16 : 0] oDATA_RE_0,
	output [16 : 0] oDATA_RE_1,
	output [16 : 0] oDATA_RE_2,
	output [16 : 0] oDATA_RE_3,
	
	output oRDY
);

wire SOURCE_CONT;

wire [1 : 0] BANK_RD_ROT;
wire [1 : 0] BANK_WR_ROT;

wire [16 : 0] RE_RAM_A [0 : 3];
wire [16 : 0] RE_OUTMIX [0 : 3];
	assign RE_RAM_A[0] = SOURCE_CONT ? {1'b0, iDATA} : RE_OUTMIX[0];
	assign RE_RAM_A[1] = SOURCE_CONT ? {1'b0, iDATA} : RE_OUTMIX[1];
	assign RE_RAM_A[2] = SOURCE_CONT ? {1'b0, iDATA} : RE_OUTMIX[2];
	assign RE_RAM_A[3] = SOURCE_CONT ? {1'b0, iDATA} : RE_OUTMIX[3];

wire [8 : 0] ADDR_RD_CTRL [0 : 3];
wire [8 : 0] ADDR_RD [0 : 3];
	assign ADDR_RD[0] = SOURCE_CONT ? iADDR_RD_0 : ADDR_RD_CTRL[0];
	assign ADDR_RD[1] = SOURCE_CONT ? iADDR_RD_1 : ADDR_RD_CTRL[1];
	assign ADDR_RD[2] = SOURCE_CONT ? iADDR_RD_2 : ADDR_RD_CTRL[2];
	assign ADDR_RD[3] = SOURCE_CONT ? iADDR_RD_3 : ADDR_RD_CTRL[3];

wire [8 : 0] ADDR_WR_CTRL;	
wire [8 : 0] ADDR_WR [0 : 3];
	assign ADDR_WR[0] = SOURCE_CONT ? iADDR_WR_0 : ADDR_WR_CTRL;
	assign ADDR_WR[1] = SOURCE_CONT ? iADDR_WR_1 : ADDR_WR_CTRL;
	assign ADDR_WR[2] = SOURCE_CONT ? iADDR_WR_2 : ADDR_WR_CTRL;
	assign ADDR_WR[3] = SOURCE_CONT ? iADDR_WR_3 : ADDR_WR_CTRL;

wire WE_A_CTRL;
wire WE_B_CTRL;
wire [3 : 0] WE;
	assign WE[0] = SOURCE_CONT ? iWE_0 : WE_A_CTRL;
	assign WE[1] = SOURCE_CONT ? iWE_1 : WE_A_CTRL;
	assign WE[2] = SOURCE_CONT ? iWE_2 : WE_A_CTRL;
	assign WE[3] = SOURCE_CONT ? iWE_3 : WE_A_CTRL;
	
wire [8 : 0] ADDR_COEF;
wire [11 : 0] W_RE [1 : 3];
wire [11 : 0] W_IM [1 : 3];

// syntax: RE_"FROM"_"TO", IM_"FROM"_"TO"

wire [16 : 0] RE_RAM_A_INMIX [0 : 3];
wire [16 : 0] IM_RAM_A_INMIX [0 : 3];
wire [16 : 0] RE_RAM_B_INMIX [0 : 3];
wire [16 : 0] IM_RAM_B_INMIX [0 : 3];

wire [16 : 0] RE_INMIX [0 : 3];
wire [16 : 0] IM_INMIX [0 : 3];

wire SOURCE_DATA;
	assign RE_INMIX[0] = SOURCE_DATA ? RE_RAM_B_INMIX[0] : RE_RAM_A_INMIX[0];
	assign IM_INMIX[0] = SOURCE_DATA ? IM_RAM_B_INMIX[0] : IM_RAM_A_INMIX[0];
	assign RE_INMIX[1] = SOURCE_DATA ? RE_RAM_B_INMIX[1] : RE_RAM_A_INMIX[1];
	assign IM_INMIX[1] = SOURCE_DATA ? IM_RAM_B_INMIX[1] : IM_RAM_A_INMIX[1];
	assign RE_INMIX[2] = SOURCE_DATA ? RE_RAM_B_INMIX[2] : RE_RAM_A_INMIX[2];
	assign IM_INMIX[2] = SOURCE_DATA ? IM_RAM_B_INMIX[2] : IM_RAM_A_INMIX[2];
	assign RE_INMIX[3] = SOURCE_DATA ? RE_RAM_B_INMIX[3] : RE_RAM_A_INMIX[3];
	assign IM_INMIX[3] = SOURCE_DATA ? IM_RAM_B_INMIX[3] : IM_RAM_A_INMIX[3];

wire BUT_TYPE;
	
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
		.oSOURCE_CONT(SOURCE_CONT),
		
		.oBUT_TYPE(BUT_TYPE),
		
		.oRDY(oRDY)
	);

// =================   rotator   ===================

wire [16 : 0] RE_INMIX_BUT [0 : 3];
wire [16 : 0] IM_INMIX_BUT [0 : 3];

wire [16 : 0] RE_MULT_OUTMIX [0 : 3];
wire [16 : 0] IM_MULT_OUTMIX [0 : 3];

wire [16 : 0] IM_OUTMIX [0 : 3];

	fft_input_mix INPUT_MIX(
		.iCLK(iCLK),
		.iRESET(iRESET),
		
		.iSEL(BANK_RD_ROT),
		
		.iX0_RE(RE_INMIX[0]),
		.iX0_IM(IM_INMIX[0]),
		.iX1_RE(RE_INMIX[1]),
		.iX1_IM(IM_INMIX[1]),
		.iX2_RE(RE_INMIX[2]),
		.iX2_IM(IM_INMIX[2]),
		.iX3_RE(RE_INMIX[3]),
		.iX3_IM(IM_INMIX[3]),
		
		.oY0_RE(RE_INMIX_BUT[0]),
		.oY0_IM(IM_INMIX_BUT[0]),
		.oY1_RE(RE_INMIX_BUT[1]),
		.oY1_IM(IM_INMIX_BUT[1]),
		.oY2_RE(RE_INMIX_BUT[2]),
		.oY2_IM(IM_INMIX_BUT[2]),
		.oY3_RE(RE_INMIX_BUT[3]),
		.oY3_IM(IM_INMIX_BUT[3])
	);
	
	fft_output_mix OUTPUT_MIX(
		.iCLK(iCLK),
		.iRESET(iRESET),
		
		.iSEL(BANK_WR_ROT),
		
		.iX0_RE(RE_MULT_OUTMIX[0]),
		.iX0_IM(IM_MULT_OUTMIX[0]),
		.iX1_RE(RE_MULT_OUTMIX[1]),
		.iX1_IM(IM_MULT_OUTMIX[1]),
		.iX2_RE(RE_MULT_OUTMIX[2]),
		.iX2_IM(IM_MULT_OUTMIX[2]),
		.iX3_RE(RE_MULT_OUTMIX[3]),
		.iX3_IM(IM_MULT_OUTMIX[3]),
		
		.oY0_RE(RE_OUTMIX[0]),
		.oY0_IM(IM_OUTMIX[0]),
		.oY1_RE(RE_OUTMIX[1]),
		.oY1_IM(IM_OUTMIX[1]),
		.oY2_RE(RE_OUTMIX[2]),
		.oY2_IM(IM_OUTMIX[2]),
		.oY3_RE(RE_OUTMIX[3]),
		.oY3_IM(IM_OUTMIX[3])
	);

// =================   butterfly and multipiler   ===================

wire [16 : 0] RE_BUT_MULT [0 : 3];
wire [16 : 0] IM_BUT_MULT [0 : 3];

	fft_but_comp BUTTER(
		.iCLK(iCLK),
		.iRESET(iRESET),
		
		.iBUT_SEL(BUT_TYPE),

		.iX0_RE(RE_INMIX_BUT[0]),
		.iX0_IM(IM_INMIX_BUT[0]),
		.iX1_RE(RE_INMIX_BUT[1]),
		.iX1_IM(IM_INMIX_BUT[1]),
		.iX2_RE(RE_INMIX_BUT[2]),
		.iX2_IM(IM_INMIX_BUT[2]),
		.iX3_RE(RE_INMIX_BUT[3]),
		.iX3_IM(IM_INMIX_BUT[3]),
		
		.oY0_RE(RE_BUT_MULT[0]),
		.oY0_IM(IM_BUT_MULT[0]),
		.oY1_RE(RE_BUT_MULT[1]),
		.oY1_IM(IM_BUT_MULT[1]),
		.oY2_RE(RE_BUT_MULT[2]),
		.oY2_IM(IM_BUT_MULT[2]),
		.oY3_RE(RE_BUT_MULT[3]),
		.oY3_IM(IM_BUT_MULT[3])
	);
	
	fft_mult_block MULT_BLOCK(
		.iCLK(iCLK),
		.iRESET(iRESET),
		
		.iX0_RE(RE_BUT_MULT[0]),
		.iX0_IM(IM_BUT_MULT[0]),
		.iX1_RE(RE_BUT_MULT[1]),
		.iX1_IM(IM_BUT_MULT[1]),
		.iX2_RE(RE_BUT_MULT[2]),
		.iX2_IM(IM_BUT_MULT[2]),
		.iX3_RE(RE_BUT_MULT[3]),
		.iX3_IM(IM_BUT_MULT[3]),
		
		.iW1_RE(W_RE[1]),
		.iW1_IM(W_IM[1]),
		.iW2_RE(W_RE[2]),
		.iW2_IM(W_IM[2]),
		.iW3_RE(W_RE[3]),
		.iW3_IM(W_IM[3]),
		
		.oY0_RE(RE_MULT_OUTMIX[0]),
		.oY0_IM(IM_MULT_OUTMIX[0]),
		.oY1_RE(RE_MULT_OUTMIX[1]),
		.oY1_IM(IM_MULT_OUTMIX[1]),
		.oY2_RE(RE_MULT_OUTMIX[2]),
		.oY2_IM(IM_MULT_OUTMIX[2]),
		.oY3_RE(RE_MULT_OUTMIX[3]),
		.oY3_IM(IM_MULT_OUTMIX[3])
	);	
	
// =================   memory   ===================

// ==================== RAM: ======================

wire [16 : 0] IM_RAM_A [0 : 3];
	assign IM_RAM_A[0] = SOURCE_CONT ? 17'd0 : IM_OUTMIX[0];
	assign IM_RAM_A[1] = SOURCE_CONT ? 17'd0 : IM_OUTMIX[1];
	assign IM_RAM_A[2] = SOURCE_CONT ? 17'd0 : IM_OUTMIX[2];
	assign IM_RAM_A[3] = SOURCE_CONT ? 17'd0 : IM_OUTMIX[3];	

	fft_ram_block RAM_A(
		.iCLK(iCLK),
		
		.iDATA_RE_0(RE_RAM_A[0]),
		.iDATA_IM_0(IM_RAM_A[0]),
		.iDATA_RE_1(RE_RAM_A[1]),
		.iDATA_IM_1(IM_RAM_A[1]),
		.iDATA_RE_2(RE_RAM_A[2]),
		.iDATA_IM_2(IM_RAM_A[2]),
		.iDATA_RE_3(RE_RAM_A[3]),
		.iDATA_IM_3(IM_RAM_A[3]),
		
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
		
		.oDATA_RE_0(RE_RAM_A_INMIX[0]),
		.oDATA_IM_0(IM_RAM_A_INMIX[0]),
		.oDATA_RE_1(RE_RAM_A_INMIX[1]),
		.oDATA_IM_1(IM_RAM_A_INMIX[1]),
		.oDATA_RE_2(RE_RAM_A_INMIX[2]),
		.oDATA_IM_2(IM_RAM_A_INMIX[2]),
		.oDATA_RE_3(RE_RAM_A_INMIX[3]),
		.oDATA_IM_3(IM_RAM_A_INMIX[3])
	);
	
	fft_ram_block RAM_B(
		.iCLK(iCLK),
		
		.iDATA_RE_0(RE_OUTMIX[0]),
		.iDATA_IM_0(IM_OUTMIX[0]),
		.iDATA_RE_1(RE_OUTMIX[1]),
		.iDATA_IM_1(IM_OUTMIX[1]),
		.iDATA_RE_2(RE_OUTMIX[2]),
		.iDATA_IM_2(IM_OUTMIX[2]),
		.iDATA_RE_3(RE_OUTMIX[3]),
		.iDATA_IM_3(IM_OUTMIX[3]),
		
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
		
		.oDATA_RE_0(RE_RAM_B_INMIX[0]),
		.oDATA_IM_0(IM_RAM_B_INMIX[0]),
		.oDATA_RE_1(RE_RAM_B_INMIX[1]),
		.oDATA_IM_1(IM_RAM_B_INMIX[1]),
		.oDATA_RE_2(RE_RAM_B_INMIX[2]),
		.oDATA_IM_2(IM_RAM_B_INMIX[2]),
		.oDATA_RE_3(RE_RAM_B_INMIX[3]),
		.oDATA_IM_3(IM_RAM_B_INMIX[3])
	);	

// ==================== ROM: ======================

`ifdef WORK
	fft_rom #(.MIF("D:/work/fft/matlab/rom_1.mif")) ROM_1(
		.address(ADDR_COEF),
		.clock(iCLK),
		.q({W_RE[1], W_IM[1]})
	);

	fft_rom #(.MIF("D:/work/fft/matlab/rom_2.mif")) ROM_2(
		.address(ADDR_COEF),
		.clock(iCLK),
		.q({W_RE[2], W_IM[2]})
	);

	fft_rom #(.MIF("D:/work/fft/matlab/rom_3.mif")) ROM_3(
		.address(ADDR_COEF),
		.clock(iCLK),
		.q({W_RE[3], W_IM[3]})
	);
`else
	fft_rom #(.MIF("D:/SS/fpga/fft/matlab/rom_1.mif")) ROM_1(
		.address(ADDR_COEF),
		.clock(iCLK),
		.q({W_RE[1], W_IM[1]})
	);

	fft_rom #(.MIF("D:/SS/fpga/fft/matlab/rom_2.mif")) ROM_2(
		.address(ADDR_COEF),
		.clock(iCLK),
		.q({W_RE[2], W_IM[2]})
	);

	fft_rom #(.MIF("D:/SS/fpga/fft/matlab/rom_3.mif")) ROM_3(
		.address(ADDR_COEF),
		.clock(iCLK),
		.q({W_RE[3], W_IM[3]})
	);
`endif

assign oDATA_RE_0 = RE_RAM_A_INMIX[0];
assign oDATA_RE_1 = RE_RAM_A_INMIX[1];
assign oDATA_RE_2 = RE_RAM_A_INMIX[2];
assign oDATA_RE_3 = RE_RAM_A_INMIX[3];
	
endmodule 