clear;
clc;

N = 16;
Fd = 44100;

%mode = 'home';
mode = 'work';

test = 'sin';
%test = 'const';
%test = 'num';

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

w_re(1:N) = temp_re(1:N);
w_im(1:N) = temp_im(1:N);

w_re = w_re';
w_im = w_im';

clear temp_re; clear temp_im;

w_re_2st(1:4) = w_re(1:4:16);
w_im_2st(1:4) = w_im(1:4:16);

    w_re2_2st(1:4) = [w_re_2st(1), w_re_2st(2), w_re_2st(1), w_re_2st(2)];
    w_im2_2st(1:4) = [w_im_2st(1), w_im_2st(2), w_im_2st(1), w_im_2st(2)];

    w_re2_2st = w_re2_2st';
    w_im2_2st = w_im2_2st';

    w_re3_2st(1:4) = [w_re_2st(1), w_re_2st(3), w_re_2st(1), w_re_2st(3)];
    w_im3_2st(1:4) = [w_im_2st(1), w_im_2st(3), w_im_2st(1), w_im_2st(3)];

    w_re3_2st = w_re3_2st';
    w_im3_2st = w_im3_2st';

    w_re4_2st(1:4) = [w_re_2st(1), w_re_2st(4), w_re_2st(1), w_re_2st(4)];
    w_im4_2st(1:4) = [w_im_2st(1), w_im_2st(4), w_im_2st(1), w_im_2st(4)];

    w_re4_2st = w_re4_2st';
    w_im4_2st = w_im4_2st';

clear w_re_2st; clear w_im_2st;
    
%% signal:
amp_1 = 10000; % 16 bit ADC
amp_2 = 5000;

freq_1 = 9000; % Hz
freq_2 = 4500;

phase_1 = 0; % grad
phase_2 = 37;

bias = amp_1; 
time = 0 : 1/Fd : (N - 1)/Fd; % sec

signal = bias + amp_1*sind((freq_1*360).* time + phase_1) + amp_2*sind((freq_2*360).* time + phase_2);
signal = signal';

ram_re(1:4, 1:4) = zeros;
ram_im(1:4, 1:4) = zeros;

if(strcmp(test, 'sin'))
    fprintf('signal test\n');
elseif(strcmp(test, 'const'))
    fprintf('const test\n');
elseif(strcmp(test, 'num'))
    fprintf('index number test\n');
else
    error('"test" is wrong\n');
end
        
k = 0;
for i = 1:4 
    for j = 1:4
        k = k + 1;
        
        if(strcmp(test, 'sin'))
            ram_re(j, i) = round(signal(k));
        elseif(strcmp(test, 'const'))
            ram_re(j, i) = 14537;
        elseif(strcmp(test, 'num'))
            ram_re(j, i) = k - 1;
            %ram_im(j, i) = k - 1;
        end
    end
end

%{
% output mixer:
    % real:
    ram_re(1, 1:4) = [ram_re(1, 1), ram_re(1, 2), ram_re(1, 3), ram_re(1, 4)];
    ram_re(2, 1:4) = [ram_re(2, 2), ram_re(2, 3), ram_re(2, 4), ram_re(2, 1)];
    ram_re(3, 1:4) = [ram_re(3, 3), ram_re(3, 4), ram_re(3, 1), ram_re(3, 2)];
    ram_re(4, 1:4) = [ram_re(4, 4), ram_re(4, 1), ram_re(4, 2), ram_re(4, 3)]; 

% input mixer + rotate addr:
    % real:
    ram_a_re_buf(1, 1:4) =	[ram_re(1, 1), ram_re(2, 4), ram_re(3, 3), ram_re(4, 2)];
    ram_a_re_buf(2, 1:4) =	[ram_re(1, 2), ram_re(2, 1), ram_re(3, 4), ram_re(4, 3)];
    ram_a_re_buf(3, 1:4) =	[ram_re(1, 3), ram_re(2, 2), ram_re(3, 1), ram_re(4, 4)];
    ram_a_re_buf(4, 1:4) =	[ram_re(1, 4), ram_re(2, 3), ram_re(3, 2), ram_re(4, 1)];

ram_re = ram_a_re_buf;
%}

%% FFT:
% butterfly:
    but_re(1:4, 1) = (ram_re(1:4, 1) + ram_re(1:4, 2) + ram_re(1:4, 3) + ram_re(1:4, 4))/4;
    but_re(1:4, 2) = (ram_re(1:4, 1) + ram_im(1:4, 2) - ram_re(1:4, 3) - ram_im(1:4, 4))/4;
    but_re(1:4, 3) = (ram_re(1:4, 1) - ram_re(1:4, 2) + ram_re(1:4, 3) - ram_re(1:4, 4))/4;
    but_re(1:4, 4) = (ram_re(1:4, 1) - ram_im(1:4, 2) - ram_re(1:4, 3) + ram_im(1:4, 4))/4;

    but_im(1:4, 1) = (ram_im(1:4, 1) + ram_im(1:4, 2) + ram_im(1:4, 3) + ram_im(1:4, 4))/4;
    but_im(1:4, 2) = (ram_im(1:4, 1) - ram_re(1:4, 2) - ram_im(1:4, 3) + ram_re(1:4, 4))/4;
    but_im(1:4, 3) = (ram_im(1:4, 1) - ram_im(1:4, 2) + ram_im(1:4, 3) - ram_im(1:4, 4))/4;
    but_im(1:4, 4) = (ram_im(1:4, 1) + ram_re(1:4, 2) - ram_im(1:4, 3) - ram_re(1:4, 4))/4;

% multiplier:
    mult_re(1:4, 1) = but_re(1:4, 1); % 0
    mult_im(1:4, 1) = but_im(1:4, 1);

    mult_re(1:4, 2) = (but_re(1:4, 2).*w_re(1:4) - but_im(1:4, 2).*w_im(1:4))/2047; % coef reading step = 1
    mult_im(1:4, 2) = (but_re(1:4, 2).*w_im(1:4) + but_im(1:4, 2).*w_re(1:4))/2047;

    mult_re(1:4, 3) = (but_re(1:4, 3).*w_re(1:2:7) - but_im(1:4, 3).*w_im(1:2:7))/2047; % 2
    mult_im(1:4, 3) = (but_re(1:4, 3).*w_im(1:2:7) + but_im(1:4, 3).*w_re(1:2:7))/2047;

    mult_re(1:4, 4) = (but_re(1:4, 4).*w_re(1:3:10) - but_im(1:4, 4).*w_im(1:3:10))/2047; % 3
    mult_im(1:4, 4) = (but_re(1:4, 4).*w_im(1:3:10) + but_im(1:4, 4).*w_re(1:3:10))/2047;

% output mixer:
    % real:
    ram_re(1, 1:4) = [mult_re(1, 1), mult_re(1, 2), mult_re(1, 3), mult_re(1, 4)];
    ram_re(2, 1:4) = [mult_re(2, 2), mult_re(2, 3), mult_re(2, 4), mult_re(2, 1)];
    ram_re(3, 1:4) = [mult_re(3, 3), mult_re(3, 4), mult_re(3, 1), mult_re(3, 2)];
    ram_re(4, 1:4) = [mult_re(4, 4), mult_re(4, 1), mult_re(4, 2), mult_re(4, 3)];
    
    % imag:
    ram_im(1, 1:4) = [mult_im(1, 1), mult_im(1, 2), mult_im(1, 3), mult_im(1, 4)];
    ram_im(2, 1:4) = [mult_im(2, 2), mult_im(2, 3), mult_im(2, 4), mult_im(2, 1)];
    ram_im(3, 1:4) = [mult_im(3, 3), mult_im(3, 4), mult_im(3, 1), mult_im(3, 2)];
    ram_im(4, 1:4) = [mult_im(4, 4), mult_im(4, 1), mult_im(4, 2), mult_im(4, 3)];  

% input mixer + rotate addr:
    % real:
    ram_a_re_buf(1, 1:4) =	[ram_re(1, 1), ram_re(2, 4), ram_re(3, 3), ram_re(4, 2)];
    ram_a_re_buf(2, 1:4) =	[ram_re(1, 2), ram_re(2, 1), ram_re(3, 4), ram_re(4, 3)];
    ram_a_re_buf(3, 1:4) =	[ram_re(1, 3), ram_re(2, 2), ram_re(3, 1), ram_re(4, 4)];
    ram_a_re_buf(4, 1:4) =	[ram_re(1, 4), ram_re(2, 3), ram_re(3, 2), ram_re(4, 1)];
    
    % imag:
    ram_a_im_buf(1, 1:4) =	[ram_im(1, 1), ram_im(2, 4), ram_im(3, 3), ram_im(4, 2)];
    ram_a_im_buf(2, 1:4) =	[ram_im(1, 2), ram_im(2, 1), ram_im(3, 4), ram_im(4, 3)];
    ram_a_im_buf(3, 1:4) =	[ram_im(1, 3), ram_im(2, 2), ram_im(3, 1), ram_im(4, 4)];
    ram_a_im_buf(4, 1:4) =	[ram_im(1, 4), ram_im(2, 3), ram_im(3, 2), ram_im(4, 1)];
    
ram_re = ram_a_re_buf;
ram_im = ram_a_im_buf;
clear ram_a_re_buf; clear ram_a_im_buf;

% butterfly:
    but_re(1:4, 1) = (ram_re(1:4, 1) + ram_re(1:4, 2) + ram_re(1:4, 3) + ram_re(1:4, 4))/4;
    but_re(1:4, 2) = (ram_re(1:4, 1) + ram_im(1:4, 2) - ram_re(1:4, 3) - ram_im(1:4, 4))/4;
    but_re(1:4, 3) = (ram_re(1:4, 1) - ram_re(1:4, 2) + ram_re(1:4, 3) - ram_re(1:4, 4))/4;
    but_re(1:4, 4) = (ram_re(1:4, 1) - ram_im(1:4, 2) - ram_re(1:4, 3) + ram_im(1:4, 4))/4;

    but_im(1:4, 1) = (ram_im(1:4, 1) + ram_im(1:4, 2) + ram_im(1:4, 3) + ram_im(1:4, 4))/4;
    but_im(1:4, 2) = (ram_im(1:4, 1) - ram_re(1:4, 2) - ram_im(1:4, 3) + ram_re(1:4, 4))/4;
    but_im(1:4, 3) = (ram_im(1:4, 1) - ram_im(1:4, 2) + ram_im(1:4, 3) - ram_im(1:4, 4))/4;
    but_im(1:4, 4) = (ram_im(1:4, 1) + ram_re(1:4, 2) - ram_im(1:4, 3) - ram_re(1:4, 4))/4;

%{
% butterfly:
    but_re(1:4, 1) = (mult_re(1:4, 1) + mult_re(1:4, 2) + mult_re(1:4, 3) + mult_re(1:4, 4))/4;
    but_re(1:4, 2) = (mult_re(1:4, 1) + mult_im(1:4, 2) - mult_re(1:4, 3) - mult_im(1:4, 4))/4;
    but_re(1:4, 3) = (mult_re(1:4, 1) - mult_re(1:4, 2) + mult_re(1:4, 3) - mult_re(1:4, 4))/4;
    but_re(1:4, 4) = (mult_re(1:4, 1) - mult_im(1:4, 2) - mult_re(1:4, 3) + mult_im(1:4, 4))/4;

    but_im(1:4, 1) = (mult_im(1:4, 1) + mult_im(1:4, 2) + mult_im(1:4, 3) + mult_im(1:4, 4))/4;
    but_im(1:4, 2) = (mult_im(1:4, 1) - mult_re(1:4, 2) - mult_im(1:4, 3) + mult_re(1:4, 4))/4;
    but_im(1:4, 3) = (mult_im(1:4, 1) - mult_im(1:4, 2) + mult_im(1:4, 3) - mult_im(1:4, 4))/4;
    but_im(1:4, 4) = (mult_im(1:4, 1) + mult_re(1:4, 2) - mult_im(1:4, 3) - mult_re(1:4, 4))/4;
%}
 
%{
% multipiler:
    mult_re(1:4, 1) = but_re(1:4, 1); % 0
    mult_im(1:4, 1) = but_im(1:4, 1);

    mult_re(1:4, 2) = (but_re(1:4, 2).*w_re2_2st(1:4) - but_im(1:4, 2).*w_im2_2st(1:4))/2047; % coef reading step = 1
    mult_im(1:4, 2) = (but_re(1:4, 2).*w_im2_2st(1:4) + but_im(1:4, 2).*w_re2_2st(1:4))/2047;

    mult_re(1:4, 3) = (but_re(1:4, 3).*w_re3_2st(1:4) - but_im(1:4, 3).*w_im3_2st(1:4))/2047; % 2
    mult_im(1:4, 3) = (but_re(1:4, 3).*w_im3_2st(1:4) + but_im(1:4, 3).*w_re3_2st(1:4))/2047;

    mult_re(1:4, 4) = (but_re(1:4, 4).*w_re4_2st(1:4) - but_im(1:4, 4).*w_im4_2st(1:4))/2047; % 3
    mult_im(1:4, 4) = (but_re(1:4, 4).*w_im4_2st(1:4) + but_im(1:4, 4).*w_re4_2st(1:4))/2047;
%}

% output mixer:
    %ram_re(1:4, 1:4) = [mult_re(1:4, 1), mult_re(1:4, 4), mult_re(1:4, 3), mult_re(1:4, 2)];
    %ram_im(1:4, 1:4) = [mult_im(1:4, 1), mult_im(1:4, 4), mult_im(1:4, 3), mult_im(1:4, 2)];
    
%% analys:
ram_a_re(1:4)	= but_re(1:4, 1); ram_a_im(1:4)    = but_im(1:4, 1);
ram_a_re(5:8)	= but_re(1:4, 2); ram_a_im(5:8)    = but_im(1:4, 2);
ram_a_re(9:12)  = but_re(1:4, 3); ram_a_im(9:12)   = but_im(1:4, 3);
ram_a_re(13:16) = but_re(1:4, 4); ram_a_im(13:16)  = but_im(1:4, 4);

ram_a_re = ram_a_re';
ram_a_im = ram_a_im';

%{
a_re = bitrevorder(ram_a_re);
a_im = bitrevorder(ram_a_im);


a_re(1) = ram_a_re(1);
a_re(2) = ram_a_re(5);
a_re(3) = ram_a_re(9);
a_re(4) = ram_a_re(13);
a_re(5) = ram_a_re(2);
a_re(6) = ram_a_re(6);
a_re(7) = ram_a_re(10);
a_re(8) = ram_a_re(14);
a_re(9) = ram_a_re(3);
a_re(10) = ram_a_re(7);
a_re(11) = ram_a_re(11);
a_re(12) = ram_a_re(15);
a_re(13) = ram_a_re(4);
a_re(14) = ram_a_re(8);
a_re(15) = ram_a_re(12);
a_re(16) = ram_a_re(16);

a_im(1) = ram_a_im(1);
a_im(2) = ram_a_im(5);
a_im(3) = ram_a_im(9);
a_im(4) = ram_a_im(13);
a_im(5) = ram_a_im(2);
a_im(6) = ram_a_im(6);
a_im(7) = ram_a_im(10);
a_im(8) = ram_a_im(14);
a_im(9) = ram_a_im(3);
a_im(10) = ram_a_im(7);
a_im(11) = ram_a_im(11);
a_im(12) = ram_a_im(15);
a_im(13) = ram_a_im(4);
a_im(14) = ram_a_im(8);
a_im(15) = ram_a_im(12);
a_im(16) = ram_a_im(16);
%}

afc_a = sqrt(ram_a_re.^2 + ram_a_im.^2);

%% graphics:
figure;
plot(time, signal);
title('Signal:');
xlabel('Time, sec');
grid on;

freq = 0 : Fd/N : Fd - 1;

figure;
plot(freq, afc_a);
for j = 1:N
    hold on;
    plot([freq(j), freq(j)], [0, afc_a(j)], 'c--');
end
title('AFC:');
xlabel('Freq, Hz');
grid on;