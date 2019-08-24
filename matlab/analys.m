clear;
clc;

fprintf('reading file...\n');

ram_a_re = load('D:\SS\fpga\modelsim\fft\ram_a_re.txt');
ram_a_im = load('D:\SS\fpga\modelsim\fft\ram_a_im.txt');
ram_b_re = load('D:\SS\fpga\modelsim\fft\ram_b_re.txt');
ram_b_im = load('D:\SS\fpga\modelsim\fft\ram_b_im.txt');

a_re(1:2048) = zeros;
a_im(1:2048) = zeros;
b_re(1:2048) = zeros;
b_im(1:2048) = zeros;

for i = 1:2048
   ind =  bitget(i - 1, 11)*2^10 + bitget(i - 1, 10)*2^9 + bitget(i - 1, 9)*2^8 +...
        + bitget(i - 1, 8)*2^7 + bitget(i - 1, 7)*2^6 + bitget(i - 1, 6)*2^5 +...
        + bitget(i - 1, 5)*2^4 + bitget(i - 1, 4)*2^3 + bitget(i - 1, 3)*2^2 +...
        + bitget(i - 1, 2)*2^1 + bitget(i - 1, 1)*2^0;
    
   a_re(i) = ram_a_re(ind + 1);
   a_im(i) = ram_a_im(ind + 1);
   b_re(i) = ram_b_re(ind + 1);
   b_im(i) = ram_b_im(ind + 1);
end

a_re = a_re';
a_im = a_im';
b_re = b_re';
b_im = b_im';

afc_a = sqrt(ram_a_re.^2 + ram_a_im.^2);
afc_b = sqrt(ram_b_re.^2 + ram_b_im.^2);



fprintf('\ncomplete\n');