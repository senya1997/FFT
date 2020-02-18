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

w_re(1:16) = temp_re(1:16);
w_im(1:16) = temp_im(1:16);

w_re = w_re';
w_im = w_im';

clear temp_re; clear temp_im;

%% signal:
amp_1 = 10000; % 16 bit ADC
amp_2 = 0;

freq_1 = 9000;  % Hz
freq_2 = 4200;

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
            ram_re(j, i) = 100;
        elseif(strcmp(test, 'num'))
            ram_re(j, i) = k - 1;
            ram_im(j, i) = k - 1;
        end
    end
end

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

% multipiler:
    mult_re(1:4, 1) = but_re(1:4, 1); % 0
    mult_im(1:4, 1) = but_im(1:4, 1);

    mult_re(1:4, 2) = (but_re(1:4, 2).*w_re(1:4) - but_im(1:4, 2).*w_im(1:4))/2048; % coef reading step = 1
    mult_im(1:4, 2) = (but_re(1:4, 2).*w_im(1:4) + but_im(1:4, 2).*w_re(1:4))/2048;

    mult_re(1:4, 3) = (but_re(1:4, 3).*w_re(1:2:7) - but_im(1:4, 3).*w_im(1:2:7))/2048; % 2
    mult_im(1:4, 3) = (but_re(1:4, 3).*w_im(1:2:7) + but_im(1:4, 3).*w_re(1:2:7))/2048;

    mult_re(1:4, 4) = (but_re(1:4, 4).*w_re(1:3:10) - but_im(1:4, 4).*w_im(1:3:10))/2048; % 3
    mult_im(1:4, 4) = (but_re(1:4, 4).*w_im(1:3:10) + but_im(1:4, 4).*w_re(1:3:10))/2048;

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

% multipiler:
    mult_re(1:4, 1) = but_re(1:4, 1); % 0
    mult_im(1:4, 1) = but_im(1:4, 1);

    mult_re(1:4, 2) = (but_re(1:4, 2).*w_re(1:4) - but_im(1:4, 2).*w_im(1:4))/2048; % coef reading step = 1
    mult_im(1:4, 2) = (but_re(1:4, 2).*w_im(1:4) + but_im(1:4, 2).*w_re(1:4))/2048;

    mult_re(1:4, 3) = (but_re(1:4, 3).*w_re(1:2:7) - but_im(1:4, 3).*w_im(1:2:7))/2048; % 2
    mult_im(1:4, 3) = (but_re(1:4, 3).*w_im(1:2:7) + but_im(1:4, 3).*w_re(1:2:7))/2048;

    mult_re(1:4, 4) = (but_re(1:4, 4).*w_re(1:3:10) - but_im(1:4, 4).*w_im(1:3:10))/2048; % 3
    mult_im(1:4, 4) = (but_re(1:4, 4).*w_im(1:3:10) + but_im(1:4, 4).*w_re(1:3:10))/2048;
%}

%% analys:
ram_a_re(1:4)	= but_re(1:4, 1); ram_a_im(1:4)	  = but_im(1:4, 1);
ram_a_re(5:8)	= but_re(1:4, 2); ram_a_im(5:8)	  = but_im(1:4, 2);
ram_a_re(9:12)  = but_re(1:4, 3); ram_a_im(9:12)  = but_im(1:4, 3);
ram_a_re(13:16) = but_re(1:4, 4); ram_a_im(13:16) = but_im(1:4, 4);

ram_a_re = ram_a_re';
ram_a_im = ram_a_im';

a_re(1:16) = zeros;
a_im(1:16) = zeros;

% bit reverse change to normal:
for i = 1:16
   ind =  bitget(i - 1, 1)*2^3 + bitget(i - 1, 2)*2^2 +...
          bitget(i - 1, 3)*2^1 + bitget(i - 1, 4)*2^0;
   
   fprintf('\tind = %4d\ti = %4d\n', ind, i - 1);
   
   a_re(i) = ram_a_re(ind + 1);
   a_im(i) = ram_a_im(ind + 1);
end

a_re = a_re';
a_im = a_im';

afc_a = sqrt(a_re.^2 + a_im.^2);

%% graphics:
figure;
plot(time, signal);
title('Signal:');
xlabel('Time, sec');
grid on;

freq = 0 : Fd/N : Fd - 1;

figure;
plot(freq, afc_a);
title('AFC:');
xlabel('Freq, Hz');
grid on;