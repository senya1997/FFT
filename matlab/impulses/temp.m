clear; clc;
%{
[d_1,       f_1] =      getDataHex('orang.hex');
[d_1_16,	f_16_1] =	getDataHex('orang_16bit.hex');

[d_1_cut] =     filCut(d_1, 3);
[d_1_16_cut] =	filCut(d_1_16, 3);

figure;
plot(d_1); hold on;
plot(d_1_16*max(d_1)/max(d_1_16)); grid on;
legend('24', '16');
title('Compare norm imp:');

figure;
plot(d_1_cut); hold on;
plot(d_1_16_cut*max(d_1_cut)/max(d_1_16_cut)); grid on;
legend('24', '16');
title('Compare cut imp:');

[d_2,       f_2] =      getDataHex('c1000.hex');
[d_2_16,	f_2_16] =	getDataHex('c1000_16bit.hex');

[d_2_cut] =     filCut(d_2, 5);
[d_2_16_cut] =	filCut(d_2_16, 5);

figure;
plot(d_2); hold on;
plot(d_2_16*max(d_2)/max(d_2_16)); grid on;
legend('24', '16');
title('Compare norm imp:');

figure;
plot(d_2_cut); hold on;
plot(d_2_16_cut*max(d_2_cut)/max(d_2_16_cut)); grid on;
legend('24', '16');
title('Compare cut imp:');
%}

Fd = 44100; % Hz
N = 4096;

a_min = 5000;
a_max = 10000;

f_min = 100; % Hz
f_max = 4000;

phase = 0; % grad
bias = 32767; % e.g. mid value from "0xFFFF" 16 bit ADC

f_step = (f_max - f_min)*15/N;
a_step = (a_max - a_min)*15/N;

f = f_min;
a = a_min;

time = 0;
time_local = 0; % for calc period of currnt sin with current freq (i)
time_step = 1/Fd;
signal(1:N) = zeros;

for i = 1:N
   signal(i) = bias + a*sind(360*f*time + phase);
   
   time = time + time_step;
   time_local = time_local + time_step;
   
   if(time_local > 1/f)
     time_local = 0;
       
     f = f + f_step;
     a = a + a_step;
   end
end

clear time;
time = 0 : 1/Fd : (N - 1)/Fd;
a_noise = ((a_max - a_min)/2);

noise = a_noise * randn(1, length(time));

%signal = bias + A1*sind((F1*360).* time + Phi1) + A2*sind((F2*360).* time + Phi2) + noise;
%signal(1:length(signal)) = 100;
%signal(1:length(signal)) = (1:length(signal)) - 1;

[y, Fs] = audioread('g.wav');
signal(1:N) = y(1:N);

%% FFT:
fft_comp = fft(signal, N); % Амплитуды преобразования Фурье сигнала

fft_re = (real(fft_comp)')./(N/4*4);
fft_im = (imag(fft_comp)')./(N/4*4);

fft_abs = abs(fft_comp)./(N/4*4);

%FftS = 2*FftS./FftL; % Нормировка спектра по амплитуде
%FftS(1) = FftS(1)/2; % Нормировка постоянной составляющей в спектре

%FftSh = abs(fft(Signal+Noise, FftL)); % Амплитуды преобразования Фурье смеси сигнал+шум
%FftSh = 2*FftSh./FftL; % Нормировка спектра по амплитуде
%FftSh(1) = FftSh(1)/2; % Нормировка постоянной составляющей в спектре

%% graphics:
figure;
plot(time, signal);
title('Сигнал');
xlabel('Время (с)');
ylabel('Амплитуда');
grid on;

F = 0 : Fd/N : Fd - 1; % Массив частот вычисляемого спектра Фурье

figure;
plot(F, fft_abs);
%for j = 1:N
%    hold on;
%    plot([F(j), F(j)], [0, fft_abs(j)], 'c--');
%end
title('Спектр сигнала');
xlabel('Частота (Гц)');
ylabel('Амплитуда');
grid on;