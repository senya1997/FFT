//`define MIF_1 "./matlab/rom_1.mif"
//`define MIF_2 "./matlab/rom_2.mif"
//`define MIF_3 "./matlab/rom_3.mif"

`define MIF_1 "D:/SS/fpga/fft/matlab/rom_1.mif"
`define MIF_2 "D:/SS/fpga/fft/matlab/rom_2.mif"
`define MIF_3 "D:/SS/fpga/fft/matlab/rom_3.mif"

`define D_BIT 17 // data bit size with bit expansion for avoid overflow from 'max_negative_num*(-1)' 
`define W_BIT 12 // twiddle coefficient bit analog data with bit expansion for use shift operating on division 
`define A_BIT 10 // depth of memory