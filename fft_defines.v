// for testbench:
`define TACT 20
`define HALF_TACT `TACT/2

`define D_BIT 17 // data bit size with bit 
`define W_BIT 12 // rotation coefficient bit analog data

// for RTL:
`define DUR_ONCE_PACK	11'd1133	// max possible duration conversion in fft with a little margin (determined by the FPGA perfomance)
`define AMNT_PACK		9'd441		// amount of input data in 10 ms (determined by the sampling rate: 44.1 kHz)
`define DUR_REM			9'd347		// equal: ((10 ms/`TACT) - (`AMNT_PACK * `DUR_ONCE_PACK))
									// its mean remainder of time after get "AMNT_PACK" input data
									// it is made for save freq 44.1 kHz
// `define PER_ADC_EN		11'd549		// bias in issue enabler for adc: "ONCE_PACK" from "ADC_RDY" to "ADC_RDY"