clc;
clear;

w_re(1:3070) = load('D:\SS\fpga\fft\matlab\w_re4096_1.txt'); % 3070 dots from excel
w_im(1:3070) = load('D:\SS\fpga\fft\matlab\w_im4096_1.txt');

w_re = w_re';
w_im = w_im';

w_re2 = w_re(1:2:3070);
w_re3 = w_re(1:3:3070);

w_im2 = w_im(1:2:3070);
w_im3 = w_im(1:3:3070);

fin_w_re_1(1:1024) = w_re(1:1024);
fin_w_re_2(1:1024) = w_re2(1:1024);
fin_w_re_3(1:1024) = w_re3(1:1024);

fin_w_im_1(1:1024) = w_im(1:1024);
fin_w_im_2(1:1024) = w_im2(1:1024);
fin_w_im_3(1:1024) = w_im3(1:1024);

file_re_1 = fopen('D:\SS\fpga\fft\matlab\w_re4096_1.txt', 'w');
file_re_2 = fopen('D:\SS\fpga\fft\matlab\w_re4096_2.txt', 'w');
file_re_3 = fopen('D:\SS\fpga\fft\matlab\w_re4096_3.txt', 'w');

file_im_1 = fopen('D:\SS\fpga\fft\matlab\w_im4096_1.txt', 'w');
file_im_2 = fopen('D:\SS\fpga\fft\matlab\w_im4096_2.txt', 'w');
file_im_3 = fopen('D:\SS\fpga\fft\matlab\w_im4096_3.txt', 'w');

fprintf(file_re_1, '%d', fin_w_re_1);
fprintf(file_re_2, '%d', fin_w_re_2);
fprintf(file_re_3, '%d', fin_w_re_3);

fprintf(file_im_1, '%d', fin_w_im_1);
fprintf(file_im_2, '%d', fin_w_im_2);
fprintf(file_im_3, '%d', fin_w_im_3);