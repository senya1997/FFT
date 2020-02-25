clc;
close all;
clear;

%mode = 'home';
mode = 'work';

N = 4096;
N_bank = N/4; % cause Radix-4 - coef corresponds to 1st stage of FFT
              % coef to mult: 1:1:(N/4), 1:2:(2*N/4), 1:3:(3*N/4)

fprintf('\n\tBegin\n');
fprintf('\n\t\tget and modify data...\n');

%% read files:
if(strcmp(mode, 'work'))
    w_re_buf(1:N) = load('D:\work\fft\matlab\w_re_1.txt'); % 'N' twiddle coef from excel
    w_im_buf(1:N) = load('D:\work\fft\matlab\w_im_1.txt');
elseif(strcmp(mode, 'home'))
    w_re_buf(1:N) = load('D:\SS\fpga\fft\matlab\w_re_1.txt');
    w_im_buf(1:N) = load('D:\SS\fpga\fft\matlab\w_im_1.txt');
else
    error('"mode" is wrong');
end

%% get coef:
w_re_buf = w_re_buf';
w_im_buf = w_im_buf';

w_re2_buf = w_re_buf(1:2:N);
w_im2_buf = w_im_buf(1:2:N);

w_re3_buf = w_re_buf(1:3:N);
w_im3_buf = w_im_buf(1:3:N);

w_re_1(1:N_bank) = w_re_buf(1:N_bank);
w_re_2(1:N_bank) = w_re2_buf(1:N_bank);
w_re_3(1:N_bank) = w_re3_buf(1:N_bank);

w_im_1(1:N_bank) = w_im_buf(1:N_bank);
w_im_2(1:N_bank) = w_im2_buf(1:N_bank);
w_im_3(1:N_bank) = w_im3_buf(1:N_bank);

%% graphics:
figure; 
    subplot(3, 1, 1), plot(w_re_1); title('W re 1:'); grid on;
    subplot(3, 1, 2), plot(w_re_2); title('W re 2:'); grid on;
    subplot(3, 1, 3), plot(w_re_3); title('W re 3:'); grid on;

figure; 
    subplot(3, 1, 1), plot(w_im_1); title('W im 1:'); grid on;
    subplot(3, 1, 2), plot(w_im_2); title('W im 2:'); grid on;
    subplot(3, 1, 3), plot(w_im_3); title('W im 3:'); grid on;

fprintf('\n\t\tadd data in ".txt"...\n');

%% save files:
if(strcmp(mode, 'work'))
    file_re_1 = fopen('D:\work\fft\matlab\w_re_1.txt', 'w');
    file_re_2 = fopen('D:\work\fft\matlab\w_re_2.txt', 'w');
    file_re_3 = fopen('D:\work\fft\matlab\w_re_3.txt', 'w');

    file_im_1 = fopen('D:\work\fft\matlab\w_im_1.txt', 'w');
    file_im_2 = fopen('D:\work\fft\matlab\w_im_2.txt', 'w');
    file_im_3 = fopen('D:\work\fft\matlab\w_im_3.txt', 'w');
elseif(strcmp(mode, 'home'))
    file_re_1 = fopen('D:\SS\fpga\fft\matlab\w_re_1.txt', 'w');
    file_re_2 = fopen('D:\SS\fpga\fft\matlab\w_re_2.txt', 'w');
    file_re_3 = fopen('D:\SS\fpga\fft\matlab\w_re_3.txt', 'w');

    file_im_1 = fopen('D:\SS\fpga\fft\matlab\w_im_1.txt', 'w');
    file_im_2 = fopen('D:\SS\fpga\fft\matlab\w_im_2.txt', 'w');
    file_im_3 = fopen('D:\SS\fpga\fft\matlab\w_im_3.txt', 'w');
end

    fprintf(file_re_1, '%d\n', w_re_1);
    fprintf(file_re_2, '%d\n', w_re_2);
    fprintf(file_re_3, '%d\n', w_re_3);

    fprintf(file_im_1, '%d\n', w_im_1);
    fprintf(file_im_2, '%d\n', w_im_2);
    fprintf(file_im_3, '%d\n', w_im_3);
    
fclose(file_re_1); fclose(file_re_2); fclose(file_re_3);
fclose(file_im_1); fclose(file_im_2); fclose(file_im_3);
    
fprintf('\n\tComplete\n');