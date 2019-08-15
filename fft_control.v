module fft_control(
	input iCLK,
	input iRESET,
	
	input iSTART,
	
	output [1 : 0] oBANK_RD_ROT,
	output [1 : 0] oBANK_WR_ROT,
	
	output [8 : 0] oADDR_RD_0,
	output [8 : 0] oADDR_RD_1,
	output [8 : 0] oADDR_RD_2,
	output [8 : 0] oADDR_RD_3,
	
	output [8 : 0] oADDR_WR,
	
	output [8 : 0] oADDR_COEF,
	
	output oBUT_TYPE, // "0" - 4 dot, "1" - 2 dot butterfly
	
	output oRDY,
	
	output oDEB
);

reg [1 : 0] bank_rd_rot;
reg [1 : 0] bank_wr_rot;

(* keep *) reg signed	[11 : 0] addr_rd_mask;
(* keep *) reg				[10 : 0] addr_rd	 [0 : 3];
reg			[8 : 0]  addr_rd_out [0 : 3];
reg [8 : 0] addr_coef;

reg [8 : 0] addr_wr;

reg [8 : 0] cnt_block_time;
reg [6 : 0] cnt_block_time_tw; // twice as often "cnt_block_time"

reg [9 : 0] cnt_stage_time;
reg [2 : 0] cnt_stage;

(* keep *) reg [8 : 0] block_mod;
(* keep *) reg [8 : 0] coef_mod;

reg [1 : 0] eof_block_delay;
reg [4 : 0] eof_block_tw_delay;

reg but_type;
reg rdy;

wire EOF_BLOCK = 		(cnt_block_time == block_mod); // end of block butterfly (1 stage - 511, 2 - 128, 3 - 32 etc.)
wire EOF_BLOCK_TW =	(cnt_block_time_tw == (block_mod >> 2)); // for write - bank must rotation 4 times faster

wire EOF_STAGE = 			(cnt_stage_time == 10'd511); // 511 addr in one RAM (4 RAM - 2048 dot FFT by Radix - 4) + 5 tacts wait last data write in RAM (delay from  but, mult ...)
wire EOF_STAGE_DELAY =	(cnt_stage_time == 10'd516);
wire LAST_STAGE =			(cnt_stage == 3'd5);

wire CNT_ST_513L = (cnt_stage_time > 10'd513);
wire CNT_ST_512S = (cnt_stage_time < 10'd512);

// *********** stage counters: *********** //

always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) cnt_stage_time <= 10'd0;
	else if(rdy | EOF_STAGE_DELAY) cnt_stage_time <= 10'd0;
	else cnt_stage_time <= cnt_stage_time + 1'b1; 
end

always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) cnt_stage <= 3'd0;
	else if((LAST_STAGE & EOF_STAGE_DELAY) | iSTART) cnt_stage <= 3'd0;
	else if(EOF_STAGE_DELAY) cnt_stage <= cnt_stage + 1'b1;
end

// ********** block butterfly: ********** //

always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) block_mod <= 9'b111_111_111;
	else if(iSTART) block_mod <= 9'b111_111_111; // mb don't requred because init is automatically through rotation (also "addr_rd")
	else if(EOF_STAGE_DELAY) block_mod <= block_mod >> 2;
end

always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) cnt_block_time <= 9'd0;
	else if(EOF_BLOCK | iSTART | EOF_STAGE_DELAY) cnt_block_time <= 9'd0; // mb required to zero after "EOF_STAGE"
	else cnt_block_time <= cnt_block_time + 1'b1;
end

// ************* choose bank: ************* //

// read:
always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) eof_block_delay <= 2'd0;
	else if(iSTART | CNT_ST_513L) eof_block_delay <= 2'd0;
	else eof_block_delay <= {eof_block_delay[0], EOF_BLOCK};
end

always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) bank_rd_rot <= 2'd0;
	else if(iSTART | CNT_ST_513L | rdy) bank_rd_rot <= 2'd0;
	else if(eof_block_delay[1]) bank_rd_rot <= bank_rd_rot + 1'b1;
end

// write:
always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) cnt_block_time_tw <= 7'd0;
	else if(EOF_BLOCK_TW | iSTART | EOF_STAGE_DELAY) cnt_block_time_tw <= 7'd0;
	else cnt_block_time_tw <= cnt_block_time_tw + 1'b1;
end

always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) eof_block_tw_delay <= 5'd0;
	else if(iSTART | EOF_STAGE_DELAY) eof_block_tw_delay <= 5'd0;
	else eof_block_tw_delay <= {eof_block_tw_delay[3 : 0], EOF_BLOCK_TW};
end

always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) bank_wr_rot <= 2'd0;
	else if(iSTART | EOF_STAGE_DELAY | rdy) bank_wr_rot <= 2'd0;
	else if(eof_block_tw_delay[4]) bank_wr_rot <= bank_wr_rot + 1'b1;
end

// ************* choose addr: ************* //

// read:
always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) addr_rd_mask <= 12'd0; // 12 bit - for msb filled up "1"
	else if(iSTART) addr_rd_mask <= 12'b100_111_111_111;
	else if(EOF_STAGE) addr_rd_mask <= addr_rd_mask >>> 2;
end

always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) 
		begin
			addr_rd[0] <= 11'd0;
			addr_rd[1] <= 11'd0;
			addr_rd[2] <= 11'd0;
			addr_rd[3] <= 11'd0;
		end
	else if(iSTART)
		begin
			addr_rd[0] <= 11'b00_000_000_000;
			addr_rd[1] <= 11'b01_000_000_000;
			addr_rd[2] <= 11'b10_000_000_000;
			addr_rd[3] <= 11'b11_000_000_000;
		end
	else if(EOF_STAGE)
		begin // rotation and shifting
			addr_rd[1] <= {2'b00, addr_rd[1][10 : 9], addr_rd[0][8 : 3], addr_rd[0][1]}; // during the transition from first stage to the second - 
			addr_rd[2] <= {2'b00, addr_rd[2][10 : 9], addr_rd[1][8 : 3], addr_rd[1][1]}; // rotation is off ("...2'b00, addr_rd[1][10 : 9]..."),
			addr_rd[3] <= {2'b00, addr_rd[3][10 : 9], addr_rd[2][8 : 3], addr_rd[2][1]}; // after - rotation is on ("...addr_rd[0][8 : 3],...") until
			addr_rd[0] <= {2'b00, addr_rd[0][10 : 9], addr_rd[3][8 : 3], addr_rd[3][1]}; // last stage, on last stage must be alternation 0,1,0,1 on "adde_rd"
		end																				 // (all example for "addr_rd[1]")
	else if(EOF_BLOCK & CNT_ST_512S)
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
			addr_rd_out[0] <= 9'd0;
			addr_rd_out[1] <= 9'd0;
			addr_rd_out[2] <= 9'd0;
			addr_rd_out[3] <= 9'd0;
		end
	else if(CNT_ST_512S)
		begin
			addr_rd_out[0] <= (cnt_stage_time[8 : 0] & addr_rd_mask[8 : 0]) | addr_rd[0][8 : 0];
			addr_rd_out[1] <= (cnt_stage_time[8 : 0] & addr_rd_mask[8 : 0]) | addr_rd[1][8 : 0];
			addr_rd_out[2] <= (cnt_stage_time[8 : 0] & addr_rd_mask[8 : 0]) | addr_rd[2][8 : 0];
			addr_rd_out[3] <= (cnt_stage_time[8 : 0] & addr_rd_mask[8 : 0]) | addr_rd[3][8 : 0];
		end
end

// write:
always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) addr_wr <= 9'd0;
	else if(cnt_stage_time < 10'd6) addr_wr <= 9'd0;
	else addr_wr <= addr_wr + 1'b1;
end

// coef:
always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) coef_mod <= 9'd0;
	else if(iSTART) coef_mod <= 9'd1;
	else if(EOF_STAGE_DELAY) coef_mod <= coef_mod << 2;
end

always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) addr_coef <= 9'd0;
	else if(iSTART | (cnt_stage_time < 10'd3) | CNT_ST_513L) addr_coef <= 9'd0;
	else addr_coef <= addr_coef + coef_mod;
end

// ************** others: ************** //

always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) but_type <= 1'b0;
	else if(LAST_STAGE) but_type <= 1'b1;
	else but_type <= 1'b0;
end

always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) rdy <= 1'b1;
	else if(iSTART) rdy <= 1'b0;
	else if(LAST_STAGE & EOF_STAGE_DELAY) rdy <= 1'b1;
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

assign oBUT_TYPE = but_type;

assign oRDY = rdy;

(* keep *) reg debug;
always@(posedge iCLK or negedge iRESET) begin
	if(!iRESET) debug <= 1'b0;
	else if(eof_block_tw_delay[4]) debug <= ~debug;
end
assign oDEB = debug;

endmodule 