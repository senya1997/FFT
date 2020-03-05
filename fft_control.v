module fft_control#(parameter A_BIT = 10)(
	input iCLK,
	input iRESET,
	
	input iSTART,
	
	output [1 : 0] oBANK_RD_ROT,
	output [1 : 0] oBANK_WR_ROT,
	
	output [A_BIT - 1 : 0] oADDR_RD_0,
	output [A_BIT - 1 : 0] oADDR_RD_1,
	output [A_BIT - 1 : 0] oADDR_RD_2,
	output [A_BIT - 1 : 0] oADDR_RD_3,
	
	output [A_BIT - 1 : 0] oADDR_WR,
	
	output [A_BIT - 1 : 0] oADDR_COEF,
	
	output oWE_A,
	output oWE_B,
	
	output oSOURCE_DATA,
	output oSOURCE_CONT,
	
	output oRDY
);

reg [1 : 0] bank_rd_rot;
reg [1 : 0] bank_wr_rot;

(* keep *) reg signed	[12 : 0] addr_rd_mask;
(* keep *) reg				[11 : 0] addr_rd	 [0 : 3];

reg [A_BIT - 1 : 0] addr_rd_out [0 : 3];
reg [A_BIT - 1 : 0] addr_coef;
reg [A_BIT - 1 : 0] addr_wr;

reg [9 : 0] cnt_block_time;
reg [7 : 0] cnt_block_time_tw; // twice as often "cnt_block_time"

reg [10 : 0] cnt_stage_time;
reg [2 : 0] cnt_stage;

(* keep *) reg [9 : 0] block_mod;
(* keep *) reg [9 : 0] coef_mod;

reg [1 : 0] eof_block_delay;
reg [4 : 0] eof_block_tw_delay;

reg we_a;
reg we_b;

reg source_data;
reg source_cont;

reg rdy;

wire EOF_BLOCK = 		(cnt_block_time == block_mod); // end of block butterfly (1 stage - 511, 2 - 128, 3 - 32 etc.)
wire EOF_BLOCK_TW =	(cnt_block_time_tw == (block_mod >> 2)); // for write - bank must rotation 4 times faster

wire EOF_STAGE = 			(cnt_stage_time == 11'd1023); // 511 addr in one RAM (4 RAM - 2048 dot FFT by Radix - 4) + 5 tacts wait last data write in RAM (delay from  but, mult ...)
wire EOF_STAGE_DELAY =	(cnt_stage_time == 11'd1028);
wire LAST_STAGE =			(cnt_stage == 3'd5);

wire CNT_ST_L = (cnt_stage_time > 11'd1025);
wire CNT_ST_S = (cnt_stage_time < 11'd1024);

// *********** stage counters: *********** //

always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) cnt_stage_time <= 11'd0;
	else if(rdy | EOF_STAGE_DELAY) cnt_stage_time <= 11'd0;
	else cnt_stage_time <= cnt_stage_time + 1'b1; 
end

always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) cnt_stage <= 3'd0;
	else if((LAST_STAGE & EOF_STAGE_DELAY) | iSTART) cnt_stage <= 3'd0;
	else if(EOF_STAGE_DELAY) cnt_stage <= cnt_stage + 1'b1;
end

// ********** block butterfly: ********** //

always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) block_mod <= 10'b111_111_1111;
	else if(iSTART) block_mod <= 10'b111_111_1111; // mb don't requred because init is automatically through rotation (also "addr_rd")
	else if(EOF_STAGE_DELAY) block_mod <= block_mod >> 2;
end

always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) cnt_block_time <= 10'd0;
	else if(EOF_BLOCK | iSTART | EOF_STAGE_DELAY) cnt_block_time <= 10'd0; // mb required to zero after "EOF_STAGE"
	else cnt_block_time <= cnt_block_time + 1'b1;
end

// ************* choose bank: ************* //

// read:
always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) eof_block_delay <= 2'd0;
	else if(iSTART | CNT_ST_L) eof_block_delay <= 2'd0;
	else eof_block_delay <= {eof_block_delay[0], EOF_BLOCK};
end

always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) bank_rd_rot <= 2'd0;
	else if(iSTART | CNT_ST_L | rdy) bank_rd_rot <= 2'd0;
	else if(eof_block_delay[1]) bank_rd_rot <= bank_rd_rot + 1'b1;
end

// write:
always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) cnt_block_time_tw <= 8'd0;
	else if(EOF_BLOCK_TW | iSTART | EOF_STAGE_DELAY) cnt_block_time_tw <= 8'd0;
	else cnt_block_time_tw <= cnt_block_time_tw + 1'b1;
end

always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) eof_block_tw_delay <= 5'd0;
	else if(iSTART | EOF_STAGE_DELAY) eof_block_tw_delay <= 5'd0;
	else eof_block_tw_delay <= {eof_block_tw_delay[3 : 0], EOF_BLOCK_TW};
end

always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) bank_wr_rot <= 2'd0;
	else if(iSTART | EOF_STAGE_DELAY | rdy | LAST_STAGE) bank_wr_rot <= 2'd0;
	else if(eof_block_tw_delay[4]) bank_wr_rot <= bank_wr_rot + 1'b1;
end

// ************* choose addr: ************* //

// read:
always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) addr_rd_mask <= 13'd0; // 13 bit - for msb filled up "1"
	else if(iSTART) addr_rd_mask <= 13'b100_111_111_1111;
	else if(EOF_STAGE) addr_rd_mask <= addr_rd_mask >>> 2;
end

always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) 
		begin
			addr_rd[0] <= 12'd0;
			addr_rd[1] <= 12'd0;
			addr_rd[2] <= 12'd0;
			addr_rd[3] <= 12'd0;
		end
	else if(iSTART)
		begin
			addr_rd[0] <= 12'b00_00_0000_0000;
			addr_rd[1] <= 12'b01_00_0000_0000;
			addr_rd[2] <= 12'b10_00_0000_0000;
			addr_rd[3] <= 12'b11_00_0000_0000;
		end
	else if(EOF_STAGE)
		begin // rotation and shifting
			addr_rd[1] <= {2'b00, addr_rd[1][11 : 10], addr_rd[0][9 : 2]}; // during the transition from first stage to the second - 
			addr_rd[2] <= {2'b00, addr_rd[2][11 : 10], addr_rd[1][9 : 2]}; // rotation is off ("...2'b00, addr_rd[1][10 : 9]..."),
			addr_rd[3] <= {2'b00, addr_rd[3][11 : 10], addr_rd[2][9 : 2]}; // after - rotation is on ("...addr_rd[0][8 : 3],...") until
			addr_rd[0] <= {2'b00, addr_rd[0][11 : 10], addr_rd[3][9 : 2]}; // last stage, on last stage must be alternation 0,1,0,1 on "addr_rd"
		end																				 	// (all example for "addr_rd[1]")
	else if(EOF_BLOCK & CNT_ST_S)
		begin // rotation only
			addr_rd[1] <= addr_rd[0];
			addr_rd[2] <= addr_rd[1];
			addr_rd[3] <= addr_rd[2];
			addr_rd[0] <= addr_rd[3];
		end
end

always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) 
		begin
			addr_rd_out[0] <= 0;
			addr_rd_out[1] <= 0;
			addr_rd_out[2] <= 0;
			addr_rd_out[3] <= 0;
		end
	else if(CNT_ST_S)
		begin
			addr_rd_out[0] <= (cnt_stage_time[9 : 0] & addr_rd_mask[9 : 0]) | addr_rd[0][9 : 0];
			addr_rd_out[1] <= (cnt_stage_time[9 : 0] & addr_rd_mask[9 : 0]) | addr_rd[1][9 : 0];
			addr_rd_out[2] <= (cnt_stage_time[9 : 0] & addr_rd_mask[9 : 0]) | addr_rd[2][9 : 0];
			addr_rd_out[3] <= (cnt_stage_time[9 : 0] & addr_rd_mask[9 : 0]) | addr_rd[3][9 : 0];
		end
end

// write:
always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) addr_wr <= 0;
	else if(cnt_stage_time < 11'd6) addr_wr <= 0;
	else addr_wr <= addr_wr + 1'b1;
end

// coef:
always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) coef_mod <= 10'd0;
	else if(iSTART) coef_mod <= 10'd1;
	else if(EOF_STAGE_DELAY) coef_mod <= coef_mod << 2;
end

always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) addr_coef <= 0;
	else if(iSTART | (cnt_stage_time < 11'd3) | CNT_ST_L) addr_coef <= 0;
	else addr_coef <= addr_coef + coef_mod;
end

// ************** others: ************** //

wire CNT_ST_0EQ = (cnt_stage_time == 11'd0);
wire CNT_ST_4L	= (cnt_stage_time > 11'd4);

wire STAGE_ODD	= (cnt_stage[0] == 1'b1);
wire STAGE_EVEN = (cnt_stage[0] == 1'b0);

always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) we_a <= 1'b0;
	else if(CNT_ST_0EQ) we_a <= 1'b0;
	else if(STAGE_ODD & CNT_ST_4L) we_a <= 1'b1;
end

always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) we_b <= 1'b0;
	else if(CNT_ST_0EQ) we_b <= 1'b0;
	else if(STAGE_EVEN & CNT_ST_4L) we_b <= 1'b1;
end

/*
always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) source_cont <= 1'b0;
	else if(iSTART) source_cont <= 1'b0;
	else if(LAST_STAGE & EOF_STAGE_DELAY) source_cont <= 1'b1;
end
*/

always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) source_data <= 1'b0;
	else if(iSTART) source_data <= 1'b0;
	else if(EOF_STAGE_DELAY) source_data <= ~source_data;
end

always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) rdy <= 1'b1;
	else if(iSTART) rdy <= 1'b0;
	else if(LAST_STAGE & EOF_STAGE_DELAY) rdy <= 1'b1;
end

always@(posedge iCLK or negedge iRESET)begin
	if(!iRESET) source_cont <= 1'b0;
	else if(iSTART) source_cont <= 1'b0;
	else source_cont <= rdy;
end

// ************ output ports: ************ //

assign oBANK_RD_ROT = bank_rd_rot;
assign oBANK_WR_ROT = bank_wr_rot;

assign oADDR_RD_0 = addr_rd_out[0];
assign oADDR_RD_1 = addr_rd_out[1];
assign oADDR_RD_2 = addr_rd_out[2];
assign oADDR_RD_3 = addr_rd_out[3];

assign oADDR_WR = addr_wr;
assign oADDR_COEF = addr_coef;

assign oWE_A = we_a;
assign oWE_B = we_b;

assign oSOURCE_DATA = source_data;
assign oSOURCE_CONT = source_cont;

assign oRDY = rdy;

endmodule 