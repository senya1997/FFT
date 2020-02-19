clear;
clc;

N = 16;
Fd = 44100;

%mode = 'home';
mode = 'work';

%% coef:
if(strcmp(mode, 'work'))
    temp_re(1:226) = load('D:\work\fft\matlab\w_re16.txt');
    temp_im(1:226) = load('D:\work\fft\matlab\w_im16.txt');
elseif(strcmp(mode, 'home'))
    temp_re(1:226) = load('D:\SS\fpga\fft\matlab\w_re16.txt');
    temp_im(1:226) = load('D:\SS\fpga\fft\matlab\w_im16.txt');
else
    error('"mode" is wrong');
end

w(1:16, 1:16) = zeros;
inc = 1;

for k = 1:16
    for j = 1:16
        w(k, j) = temp_re(j*(k - 1) + inc) + 1i*temp_im(j*(k - 1) + inc); % complex
    end
    inc = inc - 1;
end

clear temp_re; clear temp_im; clear inc;

%% signal + DFT:
amp_1 = 10000; % 16 bit ADC
amp_2 = 0;

freq_1 = 9000;  % Hz
freq_2 = 4500;

phase_1 = 0; % grad
phase_2 = 37;

bias = amp_1; 
time = 0 : 1/Fd : (N - 1)/Fd; % sec

signal = bias + amp_1*sind((freq_1*360).* time + phase_1) + amp_2*sind((freq_2*360).* time + phase_2);
signal = round(signal');

dft(1:16, 1) = w * signal; % complex multiple

dft_re = real(dft./(2047*16));
dft_im = imag(dft./(2047*16));

afc = sqrt(real(dft./(2047*16)).^2 + imag(dft./(2047*16)).^2);

%% graphics:
figure;
plot(time, signal);
title('Signal:');
xlabel('Time, sec');
grid on;

freq = 0 : Fd/N : Fd - 1;

figure;
plot(freq, afc);
title('AFC:');
xlabel('Freq, Hz');
grid on;