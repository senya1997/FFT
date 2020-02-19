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

Fd = 44100;   % Частота дискретизации (Гц)

A1 = 10000; % Амплитуда первой синусоиды
A2 = 0; % Амплитуда второй синусоиды
Ak = A1; % Постоянная составляющая

F1 = 9000;  % Частота первой синусоиды (Гц)
F2 = 4500;  % Частота второй синусоиды (Гц)

Phi1 = 0;     % Начальная фаза первой синусоиды (Градусов)
Phi2 = 37;    % Начальная фаза второй синусоиды (Градусов)

An = 0.5*A1;    % Дисперсия шума
FftL = 16;  % Количество линий Фурье спектра

T = 0 : 1/Fd : (FftL - 1)/Fd; % Массив отсчетов времени

Noise = An*randn(1, length(T));
Signal = Ak + A1*sind((F1*360).* T + Phi1) + A2*sind((F2*360).* T + Phi2);

%% БПФ
FftS = abs(fft(Signal, FftL)); % Амплитуды преобразования Фурье сигнала
%FftS = 2*FftS./FftL; % Нормировка спектра по амплитуде
%FftS(1) = FftS(1)/2; % Нормировка постоянной составляющей в спектре

FftSh = abs(fft(Signal+Noise, FftL)); % Амплитуды преобразования Фурье смеси сигнал+шум
%FftSh = 2*FftSh./FftL; % Нормировка спектра по амплитуде
%FftSh(1) = FftSh(1)/2; % Нормировка постоянной составляющей в спектре

%% Графики
figure;
subplot(2,1,1);
plot(T, Signal);
title('Сигнал');
xlabel('Время (с)');
ylabel('Амплитуда');
grid on;

subplot(2,1,2);
plot(T, Signal+Noise);
title('Сигнал + шум');
xlabel('Время (с)');
ylabel('Амплитуда');
grid on;

F = 0 : Fd/FftL : Fd - 1; % Массив частот вычисляемого спектра Фурье

figure;
subplot(2,1,1);
plot(F, FftS);
title('Спектр сигнала');
xlabel('Частота (Гц)');
ylabel('Амплитуда');
grid on;

subplot(2,1,2);
plot(F, FftSh);
title('Спектр сигнала');
xlabel('Частота (Гц)');
ylabel('Амплитуда');
grid on;