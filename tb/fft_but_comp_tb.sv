`timescale 1ns/1ns
`include "../fft_defines.v"
`include "../fft_defines_tb.v"

`define BIT_SIZE 17 // data - signed 
`define MAX_D 32768

`define NUM_OF_RPT_4DOT 30 // number of repeat test 

module fft_but_comp_tb;

bit clk;
bit reset;

bit signed [`BIT_SIZE - 1 : 0] x_re [0:3];
bit signed [`BIT_SIZE - 1 : 0] x_im [0:3];

wire signed [`BIT_SIZE - 1 : 0] Y_RE [0:3];
wire signed [`BIT_SIZE - 1 : 0] Y_IM [0:3];

// reference signals:
wire signed [`BIT_SIZE + 1 : 0] Y0_RE_4DOT = x_re[0] + x_re[1] + x_re[2] + x_re[3] + 3'sd2; // 4 dot
wire signed [`BIT_SIZE + 1 : 0] Y0_IM_4DOT = x_im[0] + x_im[1] + x_im[2] + x_im[3] + 3'sd2;

wire signed [`BIT_SIZE + 1 : 0] Y1_RE_4DOT = x_re[0] + x_im[1] - x_re[2] - x_im[3] + 3'sd2;
wire signed [`BIT_SIZE + 1 : 0] Y1_IM_4DOT = x_im[0] - x_re[1] - x_im[2] + x_re[3] + 3'sd2;

wire signed [`BIT_SIZE + 1 : 0] Y2_RE_4DOT = x_re[0] - x_re[1] + x_re[2] - x_re[3] + 3'sd2;
wire signed [`BIT_SIZE + 1 : 0] Y2_IM_4DOT = x_im[0] - x_im[1] + x_im[2] - x_im[3] + 3'sd2;

wire signed [`BIT_SIZE + 1 : 0] Y3_RE_4DOT = x_re[0] - x_im[1] - x_re[2] + x_im[3] + 3'sd2;
wire signed [`BIT_SIZE + 1 : 0] Y3_IM_4DOT = x_im[0] + x_re[1] - x_im[2] - x_re[3] + 3'sd2;

// compare output with reference:	
wire MATCH_4DOT = Y_RE[0] == Y0_RE_4DOT[`BIT_SIZE + 1 : 2] & Y_RE[1] == Y1_RE_4DOT[`BIT_SIZE + 1 : 2] & Y_RE[2] == Y2_RE_4DOT[`BIT_SIZE + 1 : 2] & Y_RE[3] == Y3_RE_4DOT[`BIT_SIZE + 1 : 2] &
				  Y_IM[0] == Y0_IM_4DOT[`BIT_SIZE + 1 : 2] & Y_IM[1] == Y1_IM_4DOT[`BIT_SIZE + 1 : 2] & Y_IM[2] == Y2_IM_4DOT[`BIT_SIZE + 1 : 2] & Y_IM[3] == Y3_IM_4DOT[`BIT_SIZE + 1 : 2];			  
	
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
	#(5*`TACT); // pause before start
	
	$display("\n\n\t\t\tSTART TEST ONE '4 DOT' COMPLEX BUTTERFLY\n");
	repeat(`NUM_OF_RPT_4DOT)
		begin
			GET_COMP_NUM(x_re[0], x_im[0]);
			GET_COMP_NUM(x_re[1], x_im[1]);
			GET_COMP_NUM(x_re[2], x_im[2]);
			GET_COMP_NUM(x_re[3], x_im[3]);
			
			DISP_INPUT_SIGN;
			
			#(`TACT);
			
			assert(MATCH_4DOT) $display("\tOK output signals:");
			else
				begin
					$display("\tERROR reference/output signals:");
					$display("\t\tRE: y0 = %6d", Y0_RE_4DOT[`BIT_SIZE + 1 : 2], "\ty1 = %6d", Y1_RE_4DOT[`BIT_SIZE + 1 : 2], "\ty2 = %6d", Y2_RE_4DOT[`BIT_SIZE + 1 : 2], "\ty3 = %6d", Y3_RE_4DOT[`BIT_SIZE + 1 : 2]);
					$display("\t\tIM: y0 = %6d", Y0_IM_4DOT[`BIT_SIZE + 1 : 2], "\ty1 = %6d", Y1_IM_4DOT[`BIT_SIZE + 1 : 2], "\ty2 = %6d", Y2_IM_4DOT[`BIT_SIZE + 1 : 2], "\ty3 = %6d", Y3_IM_4DOT[`BIT_SIZE + 1 : 2]);
				end
			DISP_OUTPUT_SIGN;
		end
		
	#(5*`TACT);
	$display("\n\n\t\t\t\tCOMPLETE\n");
	
	mti_fli::mti_Cmd("stop -sync");
end

task GET_COMP_NUM(
	output signed [`BIT_SIZE - 1 : 0] oRE,
	output signed [`BIT_SIZE - 1 : 0] oIM
);
	begin
		real temp;
		byte temp_byte;
		
		oRE = $signed($random)%(`MAX_D);
			temp_byte = $signed($random)%(2); // get random '1' or '-1' for imagine part of number
			temp = (temp_byte == 0) ? ($sqrt(`MAX_D*`MAX_D - oRE*oRE)) : ($sqrt(`MAX_D*`MAX_D - oRE*oRE) * temp_byte);
		// im = temp - 1; // for avoid overflow 
		oIM = temp;	
	end
endtask;

task DISP_INPUT_SIGN;
	$display("\n\tinput signals, time: %t", $time);
	$display("\t\tRE: x0 = %6d", x_re[0], "\tx1 = %6d", x_re[1], "\tx2 = %6d", x_re[2], "\tx3 = %6d", x_re[3]);
	$display("\t\tIM: x0 = %6d", x_im[0], "\tx1 = %6d", x_im[1], "\tx2 = %6d", x_im[2], "\tx3 = %6d", x_im[3]);
endtask;

task DISP_OUTPUT_SIGN;
	$display("\t\tRE: y0 = %6d", Y_RE[0], "\ty1 = %6d", Y_RE[1], "\ty2 = %6d", Y_RE[2], "\ty3 = %6d", Y_RE[3]);
	$display("\t\tIM: y0 = %6d", Y_IM[0], "\ty1 = %6d", Y_IM[1], "\ty2 = %6d", Y_IM[2], "\ty3 = %6d", Y_IM[3]);
endtask;

fft_but_comp #(.BIT(`BIT_SIZE)) BUT(
	.iCLK(clk),
	.iRESET(reset),
	
	.iX0_RE(x_re[0]),
	.iX0_IM(x_im[0]),
	.iX1_RE(x_re[1]),
	.iX1_IM(x_im[1]),
	.iX2_RE(x_re[2]),
	.iX2_IM(x_im[2]),
	.iX3_RE(x_re[3]),
	.iX3_IM(x_im[3]),
	
	.oY0_RE(Y_RE[0]),
	.oY0_IM(Y_IM[0]),
	.oY1_RE(Y_RE[1]),
	.oY1_IM(Y_IM[1]),
	.oY2_RE(Y_RE[2]),
	.oY2_IM(Y_IM[2]),
	.oY3_RE(Y_RE[3]),
	.oY3_IM(Y_IM[3])
);
	
endmodule