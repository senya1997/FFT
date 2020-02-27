module fft_mult_block #(parameter D_BIT = 17, W_BIT = 12)(
	input iCLK,
	input iRESET,
	
	input signed [D_BIT - 1 : 0] iX0_RE,
	input signed [D_BIT - 1 : 0] iX0_IM,
	input signed [D_BIT - 1 : 0] iX1_RE,
	input signed [D_BIT - 1 : 0] iX1_IM,
	input signed [D_BIT - 1 : 0] iX2_RE,
	input signed [D_BIT - 1 : 0] iX2_IM,
	input signed [D_BIT - 1 : 0] iX3_RE,
	input signed [D_BIT - 1 : 0] iX3_IM,
	
	input signed [W_BIT - 1 : 0] iW1_RE,
	input signed [W_BIT - 1 : 0] iW1_IM,
	input signed [W_BIT - 1 : 0] iW2_RE,
	input signed [W_BIT - 1 : 0] iW2_IM,
	input signed [W_BIT - 1 : 0] iW3_RE,
	input signed [W_BIT - 1 : 0] iW3_IM,
	
	output signed [D_BIT - 1 : 0] oY0_RE,
	output signed [D_BIT - 1 : 0] oY0_IM,
	output signed [D_BIT - 1 : 0] oY1_RE,
	output signed [D_BIT - 1 : 0] oY1_IM,
	output signed [D_BIT - 1 : 0] oY2_RE,
	output signed [D_BIT - 1 : 0] oY2_IM,
	output signed [D_BIT - 1 : 0] oY3_RE,
	output signed [D_BIT - 1 : 0] oY3_IM
);

reg signed [D_BIT - 1 : 0] y0_re_align;
reg signed [D_BIT - 1 : 0] y0_im_align;

always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) 
		begin
			y0_re_align <= 0;
			y0_im_align <= 0;
		end
	else
		begin
			y0_re_align <= iX0_RE;
			y0_im_align <= iX0_IM;
		end
end

assign oY0_RE = y0_re_align;
assign oY0_IM = y0_im_align;

fft_mult_comp #(.D_BIT(`D_BIT), .W_BIT(`W_BIT)) MULT_1(
	.iCLK(iCLK),
	.iRESET(iRESET),

	.iRE(iX1_RE),
	.iIM(iX1_IM),
	
	.iW_RE(iW1_RE),
	.iW_IM(iW1_IM),
	
	.oRE(oY1_RE),
	.oIM(oY1_IM)
);

fft_mult_comp #(.D_BIT(`D_BIT), .W_BIT(`W_BIT)) MULT_2(
	.iCLK(iCLK),
	.iRESET(iRESET),
	
	.iRE(iX2_RE),
	.iIM(iX2_IM),
	
	.iW_RE(iW2_RE),
	.iW_IM(iW2_IM),
	
	.oRE(oY2_RE),
	.oIM(oY2_IM)
);

fft_mult_comp #(.D_BIT(`D_BIT), .W_BIT(`W_BIT)) MULT_3(
	.iCLK(iCLK),
	.iRESET(iRESET),
	
	.iRE(iX3_RE),
	.iIM(iX3_IM),
	
	.iW_RE(iW3_RE),
	.iW_IM(iW3_IM),
	
	.oRE(oY3_RE),
	.oIM(oY3_IM)
);

endmodule 