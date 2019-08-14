`timescale 1ns/1ns
`include "../fft_defines.v"

`define D_SIZE 17 // data - signed
`define W_SIZE 12 // rotation coefficients - signed

`define MAX_D 32768
`define MAX_W 1024

`define NUM_OF_RPT 30 // number of repeat test

module fft_mult_comp_tb;

bit clk;
bit reset;

real temp;
byte temp_byte;

real re_buf, im_buf;
real w_re_buf, w_im_buf;

real d_ang, w_ang, res_ang, mult_ang;

bit signed [`D_SIZE - 1 : 0] re;
bit signed [`D_SIZE - 1 : 0] im;

bit signed [`W_SIZE - 1 : 0] w_re;
bit signed [`W_SIZE - 1 : 0] w_im;

wire signed [`D_SIZE - 1 : 0] RE;
wire signed [`D_SIZE - 1 : 0] IM;

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
	shortint i, j;
	
	#(5*`TACT); // pause before start
	
	$display("\n\n\t\t\tSTART TEST COMPLEX MULTIPILER\n");
	$display("\t'd_ang' - argument of data complex number\n\t'w_ang' - argument of rotation coefficient");
	$display("\t'res_ang' - theory argument of result data\n\t'mult_ang' - actually recieved argument of data by complex multipieler\n");
	
	repeat(`NUM_OF_RPT)
		begin
			re = $signed($random)%(`MAX_D);
				temp_byte = $signed($random)%(2); // get random '1' or '-1' for imagine part of number
				temp = (temp_byte == 0) ? ($sqrt(`MAX_D*`MAX_D - re*re)) : ($sqrt(`MAX_D*`MAX_D - re*re) * temp_byte);
			im = temp - 1; // for avoid overflow 
			// im = temp;
			
			w_re = $signed($random)%(`MAX_W);
				temp_byte = $signed($random)%(2);
				temp = (temp_byte == 0) ? ($sqrt(`MAX_W*`MAX_W - w_re*w_re)) : ($sqrt(`MAX_W*`MAX_W - w_re*w_re) * temp_byte);
			w_im = temp - 1;
			
				re_buf = re;
				im_buf = im;
				
				w_re_buf = w_re;
				w_im_buf = w_im;
			
			d_ang = GET_ANG(re_buf, im_buf, `MAX_D); // angle in grad counterclock-wise
			w_ang = GET_ANG(w_re_buf, w_im_buf, `MAX_W);
			
			res_ang = d_ang + w_ang;
			if(res_ang >= 360) res_ang = res_ang - 360;
		
			#(`TACT);
				re_buf = RE;
				im_buf = IM;
			mult_ang = GET_ANG(re_buf, im_buf, `MAX_D);			
			
			$display("\n\td_ang = %6.2f", d_ang, "\t\tw_ang = %6.2f", w_ang, "\t\ttime = %t", $time,
					 "\n\t\tres_ang =  \t%6.2f", res_ang,
					 "\n\t\tmult_ang = \t%6.2f\n", mult_ang);
		end
	
	$display("\n\t\tTEST ON SPEC ANGLES\n");
	for(i = 0; i < 8; i++)
		begin
			for(j = 0; j < 8; j++)
				begin
					GET_SPEC_ANG(i, `MAX_D, re_buf, im_buf);
						re = re_buf;
						im = im_buf;
			
					GET_SPEC_ANG(j, `MAX_W, w_re_buf, w_im_buf);
						w_re = w_re_buf;
						w_im = w_im_buf;
					
					d_ang = GET_ANG(re_buf, im_buf, `MAX_D);
					w_ang = GET_ANG(w_re_buf, w_im_buf, `MAX_W);
					
					res_ang = d_ang + w_ang;
					if(res_ang >= 360) res_ang = res_ang - 360;
					
					#(`TACT);
						re_buf = RE;
						im_buf = IM;
					mult_ang = GET_ANG(re_buf, im_buf, `MAX_D);
					
					$display("\n\td_ang = %6.2f", d_ang, "\t\tw_ang = %6.2f", w_ang, "\t\ttime = %t", $time,
					 "\n\t\tres_ang =  \t%6.2f", res_ang,
					 "\n\t\tmult_ang = \t%6.2f\n", mult_ang);
				end 
		end
	
	#(5*`TACT);
	$display("\n\t\t\tCOMPLETE\n");
	
	mti_fli::mti_Cmd("stop -sync");
end

function real GET_ANG(input real re, im, int hypo); // "hypo" - hypotenuse between "re" and "im" on complex plane
	if		(im >= 0 & re >  0) GET_ANG = $asin(im/hypo)  * 180/3.14;		// 1 
	else if (im >  0 & re <= 0) GET_ANG = $asin(-re/hypo) * 180/3.14 + 90;	// 2
	else if (im <= 0 & re <  0) GET_ANG = $asin(-im/hypo) * 180/3.14 + 180;	// 3
	else if (im <  0 & re >= 0) GET_ANG = $asin(re/hypo)  * 180/3.14 + 270;	// 4
endfunction

task GET_SPEC_ANG(
	input shortint i,
	input int hypo,
	output real re,
	output real im
);
	case(i)
		0:	begin
				re = hypo;
				im = 0;
			end
		1:	begin
				re = hypo/$sqrt(2);
				im = hypo/$sqrt(2);
			end			
		2:	begin
				re = 0;
				im = hypo;
			end	
		3:	begin
				re = -hypo/$sqrt(2);
				im = hypo/$sqrt(2);
			end	
		4:	begin
				re = -hypo;
				im = 0;
			end	
		5:	begin
				re = -hypo/$sqrt(2);
				im = -hypo/$sqrt(2);
			end	
		6:	begin
				re = 0;
				im = -hypo;
			end	
		7:	begin
				re = hypo/$sqrt(2);
				im = -hypo/$sqrt(2);
			end	
	endcase
endtask

fft_mult_comp  #(.D_BIT(`D_SIZE), .W_BIT(`W_SIZE)) MULT(
	.iCLK(clk),
	.iRESET(reset),
	
	.iRE(re),
    .iIM(im),
	
    .iW_RE(w_re),
    .iW_IM(w_im),
    
	.oRE(RE),
    .oIM(IM)
);
	
endmodule