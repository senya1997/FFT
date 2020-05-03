clear;
clc;

a = [0,1,2,3,0,5,6,7];

out(1, :) = fht_but8(a, 8, 1);
out(2, :) = (real(fft(a,8)) - imag(fft(a,8)))/8;

%a = [1 + 1i*1, 1 + 1i*2, 4 + 1i*2, 0 + 1i*6];

%out(1, :) = fft_but4(a, 4, 4);
%out(2, :) = fft(a,4)/4;