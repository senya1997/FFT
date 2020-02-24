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

Fd = 44100;   % ������� ������������� (��)

A1 = 10000; % ��������� ������ ���������
A2 = 000; % ��������� ������ ���������
Ak = A1; % ���������� ������������

F1 = 9000;  % ������� ������ ��������� (��)
F2 = 4500;  % ������� ������ ��������� (��)

Phi1 = 0;     % ��������� ���� ������ ��������� (��������)
Phi2 = 37;    % ��������� ���� ������ ��������� (��������)

An = 0.5*A1;    % ��������� ����
FftL = 4096;  % ���������� ����� ����� �������

T = 0 : 1/Fd : (FftL - 1)/Fd; % ������ �������� �������

Noise = An*randn(1, length(T));
Signal = Ak + A1*sind((F1*360).* T + Phi1) + A2*sind((F2*360).* T + Phi2);
Signal(1:length(Signal)) = 100;
%% ���
FftS = fft(Signal, FftL); % ��������� �������������� ����� �������

fft_re = real(FftS)';
fft_im = imag(FftS)';

FftS = abs(FftS);

%FftS = 2*FftS./FftL; % ���������� ������� �� ���������
%FftS(1) = FftS(1)/2; % ���������� ���������� ������������ � �������

%FftSh = abs(fft(Signal+Noise, FftL)); % ��������� �������������� ����� ����� ������+���
%FftSh = 2*FftSh./FftL; % ���������� ������� �� ���������
%FftSh(1) = FftSh(1)/2; % ���������� ���������� ������������ � �������

%% �������
figure;
plot(T, Signal);
title('������');
xlabel('����� (�)');
ylabel('���������');
grid on;

F = 0 : Fd/FftL : Fd - 1; % ������ ������ ������������ ������� �����

figure;
plot(F, FftS);
for j = 1:FftL
    hold on;
    plot([F(j), F(j)], [0, FftS(j)], 'c--');
end
title('������ �������');
xlabel('������� (��)');
ylabel('���������');
grid on;