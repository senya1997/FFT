module fft_mult_comp #(parameter D_BIT = 17, W_BIT = 12)(
	input iCLK,
	input iRESET,

	input signed [D_BIT - 1 : 0] iRE,
	input signed [D_BIT - 1 : 0] iIM,
	
	input signed [W_BIT - 1 : 0] iW_RE,
	input signed [W_BIT - 1 : 0] iW_IM,
	
	output signed [D_BIT - 1 : 0] oRE,
	output signed [D_BIT - 1 : 0] oIM
);

reg signed [D_BIT - 1 : 0] re_buf;
reg signed [D_BIT - 1 : 0] im_buf;

wire signed [D_BIT + W_BIT - 1 : 0] RE_EXT = iRE * iW_RE - iIM * iW_IM;
wire signed [D_BIT + W_BIT - 1 : 0] IM_EXT = iRE * iW_IM + iIM * iW_RE;

always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) 
		begin
			re_buf <= 0;
			im_buf <= 0;
		end
	else
		begin
			re_buf <= RE_EXT[D_BIT + W_BIT - 3 : W_BIT - 2];
			im_buf <= IM_EXT[D_BIT + W_BIT - 3 : W_BIT - 2];
		end
end

assign oRE = re_buf;
assign oIM = im_buf;

endmodule 