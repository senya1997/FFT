clear;
clc;

N = 4096;
N_bank = N/4; % cause Radix-4 - coef corresponds to 1st stage of FFT
              % coef to mult: 1:1:(N/4), 1:2:(2*N/4), 1:3:(3*N/4)

fprintf('\n\tBegin\n');
fprintf('\n\t\tget and modify data...\n');

%% read files:
w_re1_buf(1:N) = load('w_re_1.txt'); % 'N' twiddle coef from excel
w_im1_buf(1:N) = load('w_im_1.txt');

%% get coef:
w_re1_buf = w_re1_buf';
w_im1_buf = w_im1_buf';

w_re2_buf = w_re1_buf(1:2:N);
w_im2_buf = w_im1_buf(1:2:N);

w_re3_buf = w_re1_buf(1:3:N);
w_im3_buf = w_im1_buf(1:3:N);

w_re(1:N_bank, 1:3) = [w_re1_buf(1:N_bank), w_re2_buf(1:N_bank), w_re3_buf(1:N_bank)];
w_im(1:N_bank, 1:3) = [w_im1_buf(1:N_bank), w_im2_buf(1:N_bank), w_im3_buf(1:N_bank)];

%% graphics:
figure;
	subplot(3, 1, 1), plot(w_re(:, 1)); title('W re 1:'); grid on;
    subplot(3, 1, 2), plot(w_re(:, 2)); title('W re 2:'); grid on;
	subplot(3, 1, 3), plot(w_re(:, 3)); title('W re 3:'); grid on;
figure;
	subplot(3, 1, 1), plot(w_im(:, 1)); title('W im 1:'); grid on;
    subplot(3, 1, 2), plot(w_im(:, 2)); title('W im 2:'); grid on;
	subplot(3, 1, 3), plot(w_im(:, 3)); title('W im 3:'); grid on;
fprintf('\n\t\tadd data in ".txt"...\n');

%% save files:
file_re(1:3) = [fopen('w_re_1.txt', 'w'), fopen('w_re_2.txt', 'w'), fopen('w_re_3.txt', 'w')];
file_im(1:3) = [fopen('w_im_1.txt', 'w'), fopen('w_im_2.txt', 'w'), fopen('w_im_3.txt', 'w')];

for i = 1:3
    fprintf(file_re(i), '%d\n', w_re(:, i));
    fprintf(file_im(i), '%d\n', w_im(:, i));
end

for i = 1:3   
    fclose(file_re(i)); 
    fclose(file_im(i));
end

fprintf('\n\tComplete\n');