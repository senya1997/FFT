//`define MIF_1 "./matlab/rom_1.mif"
//`define MIF_2 "./matlab/rom_2.mif"
//`define MIF_3 "./matlab/rom_3.mif"

`define MIF_1 "D:/SS/fpga/fft/matlab/rom_1.mif"
`define MIF_2 "D:/SS/fpga/fft/matlab/rom_2.mif"
`define MIF_3 "D:/SS/fpga/fft/matlab/rom_3.mif"

`define D_BIT 17 // data bit size with bit expansion for avoid overflow from 'max_negative_num*(-1)' 
`define W_BIT 12 // twiddle coefficient bit analog data with bit expansion for use shift operating on division 
`define A_BIT 10 // depth of memory 

`define DUR_ONCE_PACK	11'd1133	// max possible duration conversion in fft with a little margin (determined by the FPGA perfomance)
`define AMNT_PACK			9'd441	// amount of input data in 10 ms (determined by the sampling rate: 44.1 kHz) 
`define DUR_REM			9'd347	// equal: ((10 ms/`TACT) - (`AMNT_PACK * `DUR_ONCE_PACK)) 
											// its mean remainder of time after get "AMNT_PACK" input data 
											// it is made for save freq 44.1 kHz 
											
`define PER_ADC_EN		11'd549	// bias in issue enabler for adc: "ONCE_PACK" from "ADC_RDY" to "ADC_RDY" 