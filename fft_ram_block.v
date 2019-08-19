module fft_ram_block(
	input iCLK,
//	input iRESET,
	
	input [15 : 0] iDATA_RE_0,
	input [15 : 0] iDATA_IM_0,
	input [15 : 0] iDATA_RE_1,
	input [15 : 0] iDATA_IM_1,
	input [15 : 0] iDATA_RE_2,
	input [15 : 0] iDATA_IM_2,
	input [15 : 0] iDATA_RE_3,
	input [15 : 0] iDATA_IM_3,
	
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
	
	output [15 : 0] oDATA_RE_0,
	output [15 : 0] oDATA_IM_0,
	output [15 : 0] oDATA_RE_1,
	output [15 : 0] oDATA_IM_1,
	output [15 : 0] oDATA_RE_2,
	output [15 : 0] oDATA_IM_2,
	output [15 : 0] oDATA_RE_3,
	output [15 : 0] oDATA_IM_3
);

wire [15 : 0] DATA_RE_IN [0 : 3] = {iDATA_RE_0, iDATA_RE_1, iDATA_RE_2, iDATA_RE_3};
wire [15 : 0] DATA_IM_IN [0 : 3];

wire [8 : 0] ADDR_RD [0 : 3];
wire [8 : 0] ADDR_WR [0 : 3];

wire [3 : 0] WE = {iWE_3, iWE_2, iWE_1, iWE_0};

wire [15 : 0] DATA_RE_OUT [0 : 3];
wire [15 : 0] DATA_IM_OUT [0 : 3];
	
genvar k;
generate 
	for(k = 0; k < 4; k = k + 1)
		begin: ram_bank
		
			fft_ram RAM_RE(
				clock(iCLK),
				data(DATA_RE_IN[k]),
				rdaddress(ADDR_RD[k]),
				wraddress(ADDR_WR[k]),
				wren(WE[k]),
				q(DATA_RE_OUT[k])
			);	
		
			fft_ram RAM_IM(
				clock(iCLK),
				data(DATA_IM_IN[k]),
				rdaddress(ADDR_RD[k]),
				wraddress(ADDR_WR[k]),
				wren(WE[k]),
				q(DATA_IM_OUT[k])
			);	
			
		end
endgenerate


endmodule 