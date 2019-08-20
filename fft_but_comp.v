module fft_but_comp #(parameter BIT = 17)(
	input iCLK,
	input iRESET,
	
	input iBUT_SEL, // "0" - 4 dot butterfly, "1" - 2 dot inputs: "x0-x1" and "x2-x3"

	input signed [BIT - 1 : 0] iX0_RE,
	input signed [BIT - 1 : 0] iX0_IM,
	input signed [BIT - 1 : 0] iX1_RE,
	input signed [BIT - 1 : 0] iX1_IM,
	input signed [BIT - 1 : 0] iX2_RE,
	input signed [BIT - 1 : 0] iX2_IM,
	input signed [BIT - 1 : 0] iX3_RE,
	input signed [BIT - 1 : 0] iX3_IM,
	
	output signed [BIT - 1 : 0] oY0_RE,
	output signed [BIT - 1 : 0] oY0_IM,
	output signed [BIT - 1 : 0] oY1_RE,
	output signed [BIT - 1 : 0] oY1_IM,
	output signed [BIT - 1 : 0] oY2_RE,
	output signed [BIT - 1 : 0] oY2_IM,
	output signed [BIT - 1 : 0] oY3_RE,
	output signed [BIT - 1 : 0] oY3_IM
);

reg signed [BIT - 1 : 0] re_buf [0 : 3];
reg signed [BIT - 1 : 0] im_buf [0 : 3];

/*
wire signed [BIT + 1 : 0] Y0_RE_2DOT = {iX0_RE, 1'b1} + {iX1_RE, 1'b1}; // 2 dot butterfly
wire signed [BIT + 1 : 0] Y0_IM_2DOT = {iX0_IM, 1'b1} + {iX1_IM, 1'b1};

wire signed [BIT : 0] Y1_RE_2DOT = iX0_RE - iX1_IM + 2'sd1;
wire signed [BIT : 0] Y1_IM_2DOT = iX0_IM - iX1_RE + 2'sd1;

wire signed [BIT + 1 : 0] Y2_RE_2DOT = {iX2_RE, 1'b1} + {iX3_RE, 1'b1};
wire signed [BIT + 1 : 0] Y2_IM_2DOT = {iX2_IM, 1'b1} + {iX3_IM, 1'b1};

wire signed [BIT : 0] Y3_RE_2DOT = iX2_RE - iX3_IM + 2'sd1;
wire signed [BIT : 0] Y3_IM_2DOT = iX2_IM - iX3_RE + 2'sd1;



wire signed [BIT + 2 : 0] Y0_RE_4DOT = Y0_RE_2DOT + Y2_RE_2DOT; // extended
wire signed [BIT + 2 : 0] Y0_IM_4DOT = Y0_IM_2DOT + Y2_IM_2DOT;

wire signed [BIT + 1 : 0] Y1_RE_4DOT = iX0_RE + iX1_IM - Y3_RE_2DOT + 3'sd3;
wire signed [BIT + 1 : 0] Y1_IM_4DOT = Y1_IM_2DOT - Y3_IM_2DOT + 3'sd2;

wire signed [BIT + 1 : 0] Y2_RE_4DOT = iX0_RE - iX1_RE + iX2_RE - iX3_RE + 3'sd2;
wire signed [BIT + 1 : 0] Y2_IM_4DOT = iX0_IM - iX1_IM + iX2_IM - iX3_IM + 3'sd2;

wire signed [BIT + 1 : 0] Y3_RE_4DOT = Y1_RE_2DOT - Y3_RE_2DOT + 3'sd2;
wire signed [BIT + 1 : 0] Y3_IM_4DOT = iX0_IM + iX1_RE - iX2_IM - iX3_RE + 3'sd2;





wire signed [BIT : 0] Y0_RE_2DOT = iX0_RE + iX1_RE + 2'sd1; // 2 dot butterfly
wire signed [BIT : 0] Y0_IM_2DOT = iX0_IM + iX1_IM + 2'sd1;

wire signed [BIT : 0] Y1_RE_2DOT = iX0_RE - iX1_IM + 2'sd1;
wire signed [BIT : 0] Y1_IM_2DOT = iX0_IM - iX1_RE + 2'sd1;

wire signed [BIT : 0] Y2_RE_2DOT = iX2_RE + iX3_RE + 2'sd1;
wire signed [BIT : 0] Y2_IM_2DOT = iX2_IM + iX3_IM + 2'sd1;

wire signed [BIT : 0] Y3_RE_2DOT = iX2_RE - iX3_IM + 2'sd1;
wire signed [BIT : 0] Y3_IM_2DOT = iX2_IM - iX3_RE + 2'sd1;



wire signed [BIT + 1 : 0] Y0_RE_4DOT = iX0_RE + iX1_RE + iX2_RE + iX3_RE + 3'sd2; // extended
wire signed [BIT + 1 : 0] Y0_IM_4DOT = iX0_IM + iX1_IM + iX2_IM + iX3_IM + 3'sd2;

wire signed [BIT + 1 : 0] Y1_RE_4DOT = iX0_RE + iX1_IM - iX2_RE - iX3_IM + 3'sd2;
wire signed [BIT + 1 : 0] Y1_IM_4DOT = iX0_IM - iX1_RE - iX2_IM + iX3_RE + 3'sd2;

wire signed [BIT + 1 : 0] Y2_RE_4DOT = iX0_RE - iX1_RE + iX2_RE - iX3_RE + 3'sd2;
wire signed [BIT + 1 : 0] Y2_IM_4DOT = iX0_IM - iX1_IM + iX2_IM - iX3_IM + 3'sd2;

wire signed [BIT + 1 : 0] Y3_RE_4DOT = iX0_RE - iX1_IM - iX2_RE + iX3_IM + 3'sd2;
wire signed [BIT + 1 : 0] Y3_IM_4DOT = iX0_IM + iX1_RE - iX2_IM - iX3_RE + 3'sd2;
*/


wire signed [BIT : 0] Y0_RE_2DOT = {iX0_RE, 1'b1} + {iX1_RE, 1'b1}; // 2 dot butterfly
wire signed [BIT : 0] Y0_IM_2DOT = {iX0_IM, 1'b1} + {iX1_IM, 1'b1};

// wire signed [BIT : 0] Y0_RE_2DOT = iX0_RE + iX1_RE + 2'sd1; // 2 dot butterfly
// wire signed [BIT : 0] Y0_IM_2DOT = iX0_IM + iX1_IM + 2'sd1;

wire signed [BIT : 0] Y1_RE_2DOT = iX0_RE - iX1_IM + 2'sd1;
wire signed [BIT : 0] Y1_IM_2DOT = iX0_IM - iX1_RE + 2'sd1;

wire signed [BIT : 0] Y2_RE_2DOT = iX2_RE + iX3_RE + 2'sd1;
wire signed [BIT : 0] Y2_IM_2DOT = iX2_IM + iX3_IM + 2'sd1;

wire signed [BIT : 0] Y3_RE_2DOT = iX2_RE - iX3_IM + 2'sd1;
wire signed [BIT : 0] Y3_IM_2DOT = iX2_IM - iX3_RE + 2'sd1;



wire signed [BIT + 1 : 0] Y0_RE_4DOT = Y0_RE_2DOT + Y2_RE_2DOT;
wire signed [BIT + 1 : 0] Y0_IM_4DOT = Y0_IM_2DOT + Y2_IM_2DOT;

wire signed [BIT + 1 : 0] Y1_RE_4DOT = iX0_RE + iX1_IM - iX2_RE - iX3_IM + 3'sd2;
wire signed [BIT + 1 : 0] Y1_IM_4DOT = Y1_IM_2DOT - iX2_IM + iX3_RE + 3'sd1;

wire signed [BIT + 1 : 0] Y2_RE_4DOT = iX0_RE - iX1_RE + iX2_RE - iX3_RE + 3'sd2;
wire signed [BIT + 1 : 0] Y2_IM_4DOT = iX0_IM - iX1_IM + iX2_IM - iX3_IM + 3'sd2;

wire signed [BIT + 1 : 0] Y3_RE_4DOT = Y1_RE_2DOT - iX2_RE + iX3_IM + 3'sd1;
wire signed [BIT + 1 : 0] Y3_IM_4DOT = iX0_IM + iX1_RE - iX2_IM - iX3_RE + 3'sd2;



always@(posedge iCLK or negedge iRESET)begin
	if(!iRESET)
		begin
			re_buf[0] = 0;
			im_buf[0] = 0;
			re_buf[1] = 0;
			im_buf[1] = 0;
			re_buf[2] = 0;
			im_buf[2] = 0;
			re_buf[3] = 0;
			im_buf[3] = 0;
		end
	else if(iBUT_SEL)
		begin
			// re_buf[0] = Y0_RE_2DOT[BIT + 1 : 2];
			// im_buf[0] = Y0_IM_2DOT[BIT + 1 : 2];
			re_buf[0] = Y0_RE_2DOT[BIT : 1];
			im_buf[0] = Y0_IM_2DOT[BIT : 1];
			re_buf[1] = Y1_RE_2DOT[BIT : 1];
			im_buf[1] = Y1_IM_2DOT[BIT : 1];
			// re_buf[2] = Y2_RE_2DOT[BIT + 1 : 2];
			// im_buf[2] = Y2_IM_2DOT[BIT + 1 : 2];
			re_buf[2] = Y2_RE_2DOT[BIT : 1];
			im_buf[2] = Y2_IM_2DOT[BIT : 1];
			re_buf[3] = Y3_RE_2DOT[BIT : 1];
			im_buf[3] = Y3_IM_2DOT[BIT : 1];
		end
	else
		begin
			re_buf[0] = Y0_RE_4DOT[BIT + 1 : 2];
			im_buf[0] = Y0_IM_4DOT[BIT + 1 : 2];
			// re_buf[0] = Y0_RE_4DOT[BIT + 2 : 3];
			// im_buf[0] = Y0_IM_4DOT[BIT + 2 : 3];
			re_buf[1] = Y1_RE_4DOT[BIT + 1 : 2];
			im_buf[1] = Y1_IM_4DOT[BIT + 1 : 2];
			re_buf[2] = Y2_RE_4DOT[BIT + 1 : 2];
			im_buf[2] = Y2_IM_4DOT[BIT + 1 : 2];
			re_buf[3] = Y3_RE_4DOT[BIT + 1 : 2];
			im_buf[3] = Y3_IM_4DOT[BIT + 1 : 2];
		end
end

assign oY0_RE = re_buf[0];
assign oY0_IM = im_buf[0];
assign oY1_RE = re_buf[1];
assign oY1_IM = im_buf[1];
assign oY2_RE = re_buf[2];
assign oY2_IM = im_buf[2];
assign oY3_RE = re_buf[3];
assign oY3_IM = im_buf[3];

endmodule 