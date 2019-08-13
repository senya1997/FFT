`define SCL_DAC 4'd12

module fft_dac( // AD5683
	input iCLK,
	input iRESET,
	
	input 	iEN,
	input [15:0] iDATA,
	
// DAC:
	output	oDAC_DATA,
	output	oDAC_CS,
	output	oDAC_CLK
);

reg cs, scl;
reg scl_delay;

reg [3:0] cnt_sw_scl;
reg [4:0] cnt_abs;

reg [19:0] req_data;

wire SW_SCL	   = 	(cnt_sw_scl == `SCL_DAC);
wire END_PACKET = (cnt_abs == 5'd20);
wire FRONT_SCL =	(!scl_delay & scl);

always@(posedge iCLK or negedge iRESET)begin
	if(!iRESET) cs <= 1'b1;
	else if(iEN & (cnt_abs == 5'd0)) cs <= 1'b0;
	else if(END_PACKET & (cnt_sw_scl == (`SCL_DAC - 1))) cs <= 1'b1;
end

always@(posedge iCLK or negedge iRESET)begin
	if(!iRESET) cnt_abs <= 5'd0;
	else if(!cs && FRONT_SCL) cnt_abs <= cnt_abs + 1'b1;
	else if(cs) cnt_abs <= 5'd0;
end

always@(posedge iCLK or negedge iRESET)begin
	if(!iRESET) cnt_sw_scl <= 3'd0;
	else if(!cs) 
		begin
			if(SW_SCL) cnt_sw_scl <= 3'd0;
			else cnt_sw_scl <= cnt_sw_scl + 1'b1;
		end
	else cnt_sw_scl <= 3'd0;
end

always@(posedge iCLK or negedge iRESET)begin
	if(!iRESET) scl_delay <= 1'b0;
	else scl_delay <= scl;
end

always@(posedge iCLK or negedge iRESET)begin
	if(!iRESET) scl <= 1'b1;
	else if(!cs && SW_SCL) scl <= ~scl;
	else if(cs) scl <= 1'b1;
end

always@(posedge iCLK or negedge iRESET)begin
	if(!iRESET) req_data <= 20'd0;
	else if(iEN) req_data <= {4'b0011, iDATA}; // mode - write in DAC: C3,C2,C1,C0 = 4'b0011 from datasheet
	else if(!cs & FRONT_SCL) req_data <= {req_data[18:0], 1'b0};
end

assign oDAC_DATA =	req_data[19];
assign oDAC_CS   = 	cs;
assign oDAC_CLK  = 	scl;

endmodule 