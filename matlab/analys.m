clear;
clc;

moodel = 'math'; % for analys files from matlab model FFT
%moodel = 'fpga'; % for analys files from modelsim with 2nd 'B' RAM

N = 4096;
N_bank = N/4; % cause Radix-4

lines = 0; % if '= 1' - plot vertical lines which corresponds FFT dots 

fprintf('\n\tBegin\n');
fprintf('\n\t\tread ".txt" RAM...\n');

%% read files:
if(strcmp(moodel, 'math'))
    file_a_re = load('ram_a_re.txt');
    file_a_im = load('ram_a_im.txt');
elseif(strcmp(moodel, 'fpga'))
    file_a_re = load('..\..\modelsim\fft\ram_a_re.txt');
    file_a_im = load('..\..\modelsim\fft\ram_a_im.txt');
    file_b_re = load('..\..\modelsim\fft\ram_b_re.txt');
    file_b_im = load('..\..\modelsim\fft\ram_b_im.txt');
else
    error('"moodel" is wrong');
end

%% bit reverse change to normal by banks:
fprintf('\n\t\tbit reverse change to normal...\n');
a_re_buf(1:N_bank, 1:4) = zeros;
a_im_buf(1:N_bank, 1:4) = zeros;

if(strcmp(moodel, 'fpga'))
    b_re_buf(1:N_bank, 1:4) = zeros;
    b_im_buf(1:N_bank, 1:4) = zeros;
end
    
for i = 1:4
    a_re_buf(1:N_bank, i) = digitrevorder(file_a_re(1:N_bank, i), 4); % every banks need to digit reverse
    a_im_buf(1:N_bank, i) = digitrevorder(file_a_im(1:N_bank, i), 4); % 2nd param '= 4', cause Radix-4
    
    if(strcmp(moodel, 'fpga'))
        b_re_buf = digitrevorder(file_b_re(1:N_bank, i), 4);
        b_im_buf = digitrevorder(file_b_im(1:N_bank, i), 4);
    end
end

a_re(1 : N_bank)                = a_re_buf(1:N_bank, 1); a_im(1 : (N_bank))              = a_im_buf(1:N_bank, 1);
a_re((1*N_bank + 1):(2*N_bank)) = a_re_buf(1:N_bank, 2); a_im((1*N_bank + 1):(2*N_bank)) = a_im_buf(1:N_bank, 2);
a_re((2*N_bank + 1):(3*N_bank)) = a_re_buf(1:N_bank, 3); a_im((2*N_bank + 1):(3*N_bank)) = a_im_buf(1:N_bank, 3);
a_re((3*N_bank + 1):(4*N_bank)) = a_re_buf(1:N_bank, 4); a_im((3*N_bank + 1):(4*N_bank)) = a_im_buf(1:N_bank, 4);

a_re = a_re';
a_im = a_im';

if(strcmp(moodel, 'fpga'))
    b_re(1 : N_bank)                = b_re_buf(1:N_bank, 1); b_im(1 : N_bank)                = b_im_buf(1:N_bank, 1);
    b_re((1*N_bank + 1):(2*N_bank)) = b_re_buf(1:N_bank, 2); b_im((1*N_bank + 1):(2*N_bank)) = b_im_buf(1:N_bank, 2);
    b_re((2*N_bank + 1):(3*N_bank)) = b_re_buf(1:N_bank, 3); b_im((2*N_bank + 1):(3*N_bank)) = b_im_buf(1:N_bank, 3);
    b_re((3*N_bank + 1):(4*N_bank)) = b_re_buf(1:N_bank, 4); b_im((3*N_bank + 1):(4*N_bank)) = b_im_buf(1:N_bank, 4);
    
    b_re = b_re';
    b_im = b_im';
end

% alternative way to read data from RAM banks - line by line:
%{
for i = 1:N_bank
    a_re(1, (1 + (i-1)*4) : (i*4)) = a_re_buf(i, 1:4);
    a_im(1, (1 + (i-1)*4) : (i*4)) = a_im_buf(i, 1:4);
end
%}

%% AFC:
fprintf('\n\t\tcalc AFC and build graphics...\n');
afc_a = sqrt(a_re.^2 + a_im.^2);
%afc_b = sqrt(b_re.^2 + b_im.^2);

% subtraction 1st half from 2nd, mirror left and right part of AFC
half_afc_a_1 = afc_a(2:(N/2));
half_afc_a_2 = wrev(afc_a((N/2 + 1):N));

sub(1:N/2) = zeros;
for i = 1:(N/2 - 1)
	sub(i) = half_afc_a_1(i) - half_afc_a_2(i);
end
sub = sub';

%% graphics:
Fd = 44100;
freq = 0 : Fd/N : Fd - 1;

figure;    
plot(freq, afc_a);
if(lines == 1)
    for j = 1:N
        hold on;
        plot([freq(j), freq(j)], [0, afc_a(j)], 'c--');
    end
end
xlabel('Freq, Hz');
title('FFT from RAM "A":');
grid on;

figure;
plot(sub);
title('Error between 1st and 2nd half:');
grid on;

fprintf('\n\tComplete\n');