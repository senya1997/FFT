`include "fft_defines.v"

module fft_top(
	input		iCLK,
	input		iRESET,
	
// ADC:
	input		iADC_DATA,
	output	oADC_CS,
	output	oADC_SCL,
	
// DAC:	
	output	oDAC_DATA,
	output	oDAC_CS,
	output	oDAC_CLK
	
`ifndef MODEL_TECH
	,
	output oLED
`endif	
);

`ifndef MODEL_TECH
	reg [23:0] cnt_led;
	reg led_stand_by;
	
	wire SPARK = (cnt_led == 24'hFF_FF_FF);
`endif

reg [10:0] cnt_once_pack;
reg [8:0] cnt_pack;
reg [8:0] cnt_rem;

wire ONCE_PACK = (cnt_once_pack == `DUR_ONCE_PACK);
wire FULL_PACK = (cnt_pack == `AMNT_PACK);
wire ONCE_SMPL = (cnt_rem == `DUR_REM); // once sample <=> 441 data on 10 ms <=> 44.1 kHz sampling frequency

wire ADC_EN = ONCE_PACK;
wire ADC_RDY;
wire [15:0] ADC_DATA;

// main counters:
always@(posedge iCLK or negedge iRESET)begin
	if(!iRESET) cnt_once_pack <= 11'b0;
	else if(ONCE_PACK | FULL_PACK) cnt_once_pack <= 11'b0;
	else cnt_once_pack <= cnt_once_pack + 1'b1;
end

always@(posedge iCLK or negedge iRESET)begin
	if(!iRESET) cnt_pack <= 9'b0;
	else if(ADC_RDY & !FULL_PACK) cnt_pack <= cnt_pack + 1'b1;
	else if(ONCE_SMPL) cnt_pack <= 9'b0;
end

always@(posedge iCLK or negedge iRESET)begin
	if(!iRESET) cnt_rem <= 9'b0;
	else if(FULL_PACK) cnt_rem <= cnt_rem + 1'b1;
	else cnt_rem <= 9'b0;
end

`ifndef MODEL_TECH
	always@(posedge iCLK or negedge iRESET)begin
		if(!iRESET) cnt_led <= 24'd0;
		else cnt_led <= cnt_led + 24'd1;
	end

	always@(posedge iCLK or negedge iRESET)begin
		if(!iRESET) led_stand_by <= 1'b0;
		else if(SPARK) led_stand_by <= ~led_stand_by;
	end
`endif

// ========== analog part: ==========
	fft_adc ADC(
		.iCLK(iCLK),
		.iRESET(iRESET),
		
		.iEN(ADC_EN),

	// ADC:
		.iADC_DATA(iADC_DATA),
		.oADC_CS(oADC_CS),
		.oADC_SCL(oADC_SCL),

	// CONTROL:
		.oDATA(ADC_DATA),
		.oRDY(ADC_RDY)
	);

	fft_dac DAC(
		.iCLK(iCLK),
		.iRESET(iRESET),
		
		.iEN(ADC_RDY),
		.iDATA(),
		
	// DAC:
		.oDAC_DATA(oDAC_DATA),
		.oDAC_CS(oDAC_CS),
		.oDAC_CLK(oDAC_CLK)
	);

// ========== memory: ==========


	
	
`ifndef MODEL_TECH
	assign oLED = led_stand_by;
`endif

endmodule 