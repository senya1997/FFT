module fft_ram_block #(parameter D_BIT = 17, A_BIT = 9)(
	input iCLK,
	
	input [D_BIT - 1 : 0] iDATA_RE_0,
	input [D_BIT - 1 : 0] iDATA_IM_0,
	input [D_BIT - 1 : 0] iDATA_RE_1,
	input [D_BIT - 1 : 0] iDATA_IM_1,
	input [D_BIT - 1 : 0] iDATA_RE_2,
	input [D_BIT - 1 : 0] iDATA_IM_2,
	input [D_BIT - 1 : 0] iDATA_RE_3,
	input [D_BIT - 1 : 0] iDATA_IM_3,
	
	input [A_BIT - 1 : 0] iADDR_RD_0,
	input [A_BIT - 1 : 0] iADDR_RD_1,
	input [A_BIT - 1 : 0] iADDR_RD_2,
	input [A_BIT - 1 : 0] iADDR_RD_3,
	
	input [A_BIT - 1 : 0] iADDR_WR_0,
	input [A_BIT - 1 : 0] iADDR_WR_1,
	input [A_BIT - 1 : 0] iADDR_WR_2,
	input [A_BIT - 1 : 0] iADDR_WR_3,

	input iWE_0,
	input iWE_1,
	input iWE_2,
	input iWE_3,
	
	output [D_BIT - 1 : 0] oDATA_RE_0,
	output [D_BIT - 1 : 0] oDATA_IM_0,
	output [D_BIT - 1 : 0] oDATA_RE_1,
	output [D_BIT - 1 : 0] oDATA_IM_1,
	output [D_BIT - 1 : 0] oDATA_RE_2,
	output [D_BIT - 1 : 0] oDATA_IM_2,
	output [D_BIT - 1 : 0] oDATA_RE_3,
	output [D_BIT - 1 : 0] oDATA_IM_3
);

wire [D_BIT - 1 : 0] DATA_RE_IN [0 : 3];
	assign DATA_RE_IN[0] = iDATA_RE_0;
	assign DATA_RE_IN[1] = iDATA_RE_1;
	assign DATA_RE_IN[2] = iDATA_RE_2;
	assign DATA_RE_IN[3] = iDATA_RE_3;

wire [D_BIT - 1 : 0] DATA_IM_IN [0 : 3];
	assign DATA_IM_IN[0] = iDATA_IM_0;
	assign DATA_IM_IN[1] = iDATA_IM_1;
	assign DATA_IM_IN[2] = iDATA_IM_2;
	assign DATA_IM_IN[3] = iDATA_IM_3;

wire [A_BIT - 1 : 0] ADDR_RD [0 : 3];
	assign ADDR_RD[0] = iADDR_RD_0;
	assign ADDR_RD[1] = iADDR_RD_1;
	assign ADDR_RD[2] = iADDR_RD_2;
	assign ADDR_RD[3] = iADDR_RD_3;

wire [A_BIT - 1 : 0] ADDR_WR [0 : 3];
	assign ADDR_WR[0] = iADDR_WR_0;
	assign ADDR_WR[1] = iADDR_WR_1;
	assign ADDR_WR[2] = iADDR_WR_2;
	assign ADDR_WR[3] = iADDR_WR_3;

wire [3 : 0] WE = {iWE_3, iWE_2, iWE_1, iWE_0};

wire [D_BIT - 1 : 0] DATA_RE_OUT [0 : 3];
	assign oDATA_RE_0 = DATA_RE_OUT[0];
	assign oDATA_RE_1 = DATA_RE_OUT[1];
	assign oDATA_RE_2 = DATA_RE_OUT[2];
	assign oDATA_RE_3 = DATA_RE_OUT[3];
	
wire [D_BIT - 1 : 0] DATA_IM_OUT [0 : 3];
	assign oDATA_IM_0 = DATA_IM_OUT[0];
	assign oDATA_IM_1 = DATA_IM_OUT[1];
	assign oDATA_IM_2 = DATA_IM_OUT[2];
	assign oDATA_IM_3 = DATA_IM_OUT[3];
	
genvar k;
generate 
	for(k = 0; k < 4; k = k + 1)
		begin: ram_bank
		
			fft_ram_fast RAM_RE(
				.clock(iCLK),
				.data(DATA_RE_IN[k]),
				.rdaddress(ADDR_RD[k]),
				.wraddress(ADDR_WR[k]),
				.wren(WE[k]),
				.q(DATA_RE_OUT[k])
			);	
		
			fft_ram_fast RAM_IM(
				.clock(iCLK),
				.data(DATA_IM_IN[k]),
				.rdaddress(ADDR_RD[k]),
				.wraddress(ADDR_WR[k]),
				.wren(WE[k]),
				.q(DATA_IM_OUT[k])
			);	
			
		end
endgenerate

endmodule 