clear;
clc;

N = 4096;
N_bank = N/4; % cause Radix-4 - coef corresponds to 1st stage of FFT
              % coef to mult: 1:1:(N/4), 1:2:(2*N/4), 1:3:(3*N/4)

fprintf('\n\tBegin\n');
fprintf('\n\t\tget and modify data...\n');

w_1_buf(1:N) = load('w_1.txt'); % 'N' twiddle coef from excel

w_1_buf = w_1_buf';
w_2_buf = w_1_buf(1:2:N);
w_3_buf = w_1_buf(1:3:N);

w_re(1:N_bank, 1:3) = [w_1_buf(1:N_bank), w_2_buf(1:N_bank), w_3_buf(1:N_bank)];

fprintf('\n\t\tadd data in ".txt"...\n');

file_w(1:3) = [fopen('w_1.txt', 'w'), fopen('w_2.txt', 'w'), fopen('w_3.txt', 'w')];

for i = 1:3
    fprintf(file_w(i), '%d\n', w_re(:, i));
    fclose(file_w(i)); 
end

figure;
subplot(3, 1, 1), plot(w_re(:, 1)); title('W 1:'); grid on;
subplot(3, 1, 2), plot(w_re(:, 2)); title('W 2:'); grid on;
subplot(3, 1, 3), plot(w_re(:, 3)); title('W 3:'); grid on;

fprintf('\n\tComplete\n');