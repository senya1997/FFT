`define SCL_ADC 4'd12

module fft_adc( // ADS8320
	input iCLK,
	input iRESET,
	
	input 	iEN,

// ADC:
	input		iADC_DATA,
	output	oADC_CS,
	output	oADC_SCL,

// CONTROL:
	output [15:0] oDATA,
	output oRDY
);

reg cs, scl;
reg scl_delay;

reg [3:0] cnt_sw_scl;
reg [4:0] cnt_abs;

reg [15:0] req_data;

wire SW_SCL	   = 	(cnt_sw_scl == `SCL_ADC);
wire END_PACKET = (cnt_abs == 5'd22);
wire RDY 	   = 	(END_PACKET && cs);
wire GET_DATA  =	(cnt_abs >= 5'd6 && cnt_abs <= 5'd22);
wire FRONT_SCL =	(!scl_delay & scl);

always@(posedge iCLK or negedge iRESET)begin
	if(!iRESET) cs <= 1'b1;
	else if(iEN & (cnt_abs == 5'd0)) cs <= 1'b0;
	else if(END_PACKET & (cnt_sw_scl == (`SCL_ADC - 1))) cs <= 1'b1;
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
	if(!iRESET) req_data <= 16'd0;
	else if(!cs & FRONT_SCL & GET_DATA) req_data <= {req_data[14:0], iADC_DATA}; 
	else if(cs) req_data <= 16'd0;
end

assign oADC_CS   = 	cs;
assign oADC_SCL  = 	scl;

assign oDATA  =  	req_data[15:0];
assign oRDY   = 	RDY;

endmodule 