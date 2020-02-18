clear;
clc;

temp_re(1:226) = load('D:\work\fft\matlab\w_re16.txt');
temp_im(1:226) = load('D:\work\fft\matlab\w_im16.txt');

w(1:16, 1:16) = zeros;
inc = 1;

for k = 1:16
    for j = 1:16
        w(k, j) = temp_re(j*(k - 1) + inc) + 1i*temp_im(j*(k - 1) + inc);
    end
    inc = inc - 1;
end

ram_re(1:4, 1:4) = zeros;
ram_im(1:4, 1:4) = zeros;

N = 16;
Fd = 44100;

A1 = 10000; % ��������� ������ ���������
A2 = 0; % ��������� ������ ���������
Ak = A1; % ���������� ������������

F1 = 9000;  % ������� ������ ��������� (��)
F2 = 4200;  % ������� ������ ��������� (��)

Phi1 = 0;     % ��������� ���� ������ ��������� (��������)
Phi2 = 37;    % ��������� ���� ������ ��������� (��������)

T = 0 : 1/Fd : (N - 1)/Fd; % ������ �������� �������

Signal = Ak + A1*sind((F1*360).* T + Phi1) + A2*sind((F2*360).* T + Phi2);
Signal = Signal';

figure;
plot(T, Signal);
title('Signal:');
xlabel('Time, sec');
grid on;

C(1:16, 1) = w*Signal; % DFT

F = 0 : Fd/N : Fd - 1;

figure;
plot(F, sqrt(real(C).^2 + imag(C).^2)); % AFC
title('AFC:');
xlabel('Freq, Hz');
grid on;