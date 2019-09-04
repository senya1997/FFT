module fft_output_mix #(parameter BIT = 17)(
	input iCLK,
	input iRESET,
	
	input [1 : 0] iSEL,
	
	input [BIT - 1 : 0] iX0_RE,
	input [BIT - 1 : 0] iX0_IM,
	input [BIT - 1 : 0] iX1_RE,
	input [BIT - 1 : 0] iX1_IM,
	input [BIT - 1 : 0] iX2_RE,
	input [BIT - 1 : 0] iX2_IM,
	input [BIT - 1 : 0] iX3_RE,
	input [BIT - 1 : 0] iX3_IM,
	
	output [BIT - 1 : 0] oY0_RE,
	output [BIT - 1 : 0] oY0_IM,
	output [BIT - 1 : 0] oY1_RE,
	output [BIT - 1 : 0] oY1_IM,
	output [BIT - 1 : 0] oY2_RE,
	output [BIT - 1 : 0] oY2_IM,
	output [BIT - 1 : 0] oY3_RE,
	output [BIT - 1 : 0] oY3_IM
);

reg signed [BIT - 1 : 0] re_buf [0 : 3];
reg signed [BIT - 1 : 0] im_buf [0 : 3];

always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) 
		begin
			re_buf[0] <= 0;
			im_buf[0] <= 0;
			re_buf[1] <= 0;
			im_buf[1] <= 0;
			re_buf[2] <= 0;
			im_buf[2] <= 0;
			re_buf[3] <= 0;
			im_buf[3] <= 0;
		end
	else
		case(iSEL)
			2'b00:
				begin
					re_buf[0] <= iX0_RE;
					im_buf[0] <= iX0_IM;
					re_buf[1] <= iX1_RE;
					im_buf[1] <= iX1_IM;
					re_buf[2] <= iX2_RE;
					im_buf[2] <= iX2_IM;
					re_buf[3] <= iX3_RE;
					im_buf[3] <= iX3_IM;
				end
			2'b01:
				begin
					re_buf[0] <= iX1_RE;
					im_buf[0] <= iX1_IM;
					re_buf[1] <= iX2_RE;
					im_buf[1] <= iX2_IM;
					re_buf[2] <= iX3_RE;
					im_buf[2] <= iX3_IM;
					re_buf[3] <= iX0_RE;
					im_buf[3] <= iX0_IM;
				end
			2'b10:
				begin
					re_buf[0] <= iX2_RE;
					im_buf[0] <= iX2_IM;
					re_buf[1] <= iX3_RE;
					im_buf[1] <= iX3_IM;
					re_buf[2] <= iX0_RE;
					im_buf[2] <= iX0_IM;
					re_buf[3] <= iX1_RE;
					im_buf[3] <= iX1_IM;
				end
			default:
				begin
					re_buf[0] <= iX3_RE;
					im_buf[0] <= iX3_IM;
					re_buf[1] <= iX0_RE;
					im_buf[1] <= iX0_IM;
					re_buf[2] <= iX1_RE;
					im_buf[2] <= iX1_IM;
					re_buf[3] <= iX2_RE;
					im_buf[3] <= iX2_IM;
				end
		endcase
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