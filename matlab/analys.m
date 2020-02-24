clear;
clc;

mode = 'home';
%mode = 'work';

%moodel = 'fpga';
moodel = 'math';

%% load files
if(strcmp(mode, 'work'))
    if(strcmp(moodel, 'math'))
        file_a_re = load('D:\work\fft\matlab\ram_a_re.txt');
        file_a_im = load('D:\work\fft\matlab\ram_a_im.txt');
    elseif(strcmp(moodel, 'fpga'))
        file_a_re = load('D:\work\modelsim\fft\ram_a_re.txt');
        file_a_im = load('D:\work\modelsim\fft\ram_a_im.txt');
        file_b_re = load('D:\work\modelsim\fft\ram_b_re.txt');
        file_b_im = load('D:\work\modelsim\fft\ram_b_im.txt');
    else
        error('"func" is wrong');
    end
elseif(strcmp(mode, 'home'))
    if(strcmp(moodel, 'math'))
        file_a_re = load('D:\SS\fpga\fft\matlab\ram_a_re.txt');
        file_a_im = load('D:\SS\fpga\fft\matlab\ram_a_im.txt');
    elseif(strcmp(moodel, 'fpga'))
        file_a_re = load('D:\SS\fpga\modelsim\fft\ram_a_re.txt');
        file_a_im = load('D:\SS\fpga\modelsim\fft\ram_a_im.txt');
        file_b_re = load('D:\SS\fpga\modelsim\fft\ram_b_re.txt');
        file_b_im = load('D:\SS\fpga\modelsim\fft\ram_b_im.txt');
    else
        error('"func" is wrong');
    end
else
    error('"mode" is wrong');
end

for i = 1:4
    file_a_re(1:1024, i) = digitrevorder(file_a_re(1:1024, i), 4);
    file_a_im(1:1024, i) = digitrevorder(file_a_im(1:1024, i), 4);
end

ram_a_re(1:1024)	= file_a_re(1:1024, 1); ram_a_im(1:1024)	= file_a_im(1:1024, 1);
ram_a_re(1025:2048)	= file_a_re(1:1024, 2); ram_a_im(1025:2048)	= file_a_im(1:1024, 2);
ram_a_re(2049:3072) = file_a_re(1:1024, 3); ram_a_im(2049:3072)	= file_a_im(1:1024, 3);
ram_a_re(3073:4096) = file_a_re(1:1024, 4); ram_a_im(3073:4096)	= file_a_im(1:1024, 4);

if(strcmp(moodel, 'fpga'))
    ram_b_re(1:512)     = file_b_re(1:512, 1); ram_b_im(1:512)     = file_b_im(1:512, 1);
    ram_b_re(513:1024)  = file_b_re(1:512, 2); ram_b_im(513:1024)  = file_b_im(1:512, 2);
    ram_b_re(1025:1536) = file_b_re(1:512, 3); ram_b_im(1025:1536) = file_b_im(1:512, 3);
    ram_b_re(1537:2048) = file_b_re(1:512, 4); ram_b_im(1537:2048) = file_b_im(1:512, 4);
end

%{
for i = 1:16
    ram_a_re(1, (1 + (i-1)*4) : (i*4)) = file_a_re(i, 1:4);
    ram_a_im(1, (1 + (i-1)*4) : (i*4)) = file_a_im(i, 1:4);
end
%}

ram_a_re = ram_a_re';
ram_a_im = ram_a_im';

%% bit reverse change to normal
%{
a_re = digitrevorder(ram_a_re, 4);
a_im = digitrevorder(ram_a_im, 4);

if(strcmp(moodel, 'fpga'))
    b_re = digitrevorder(ram_b_re, 4);
    b_im = digitrevorder(ram_b_im, 4);
end

a_re = a_re';
a_im = a_im';

if(strcmp(moodel, 'fpga'))
    b_re = b_re';
    b_im = b_im';
end
%}

%% AFC from "A" RAM
ram_afc_a = sqrt(ram_a_re.^2 + ram_a_im.^2);

%afc_a = sqrt(a_re.^2 + a_im.^2);
%afc_b = sqrt(b_re.^2 + b_im.^2);

%% subtraction first half from second, mirror left and right part of AFC
%{
half_afc_a_1 = afc_a(1:1024);
half_afc_a_2 = afc_a(1025:2048);

sub(1:1024) = zeros;
for i = 1:1024
	sub(i) = half_afc_a_1(i) - half_afc_a_2(i);
end
sub = sub';
%}

%% graphics
N = 4096;
Fd = 44100;
F = 0 : Fd/N : Fd - 1;

figure;    
plot(F, ram_afc_a);
%for j = 1:N
%    hold on;
%    plot([F(j), F(j)], [0, ram_afc_a(j)], 'c--');
%end
title('FFT from RAM "A" without change position harm:');
grid on;

%{
figure;    
plot(F, afc_a);
title('AFC from RAM "A":');
grid on;

figure;
plot(sub);
title('subtraction:');
grid on;
%}