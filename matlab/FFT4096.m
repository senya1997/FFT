clear;
close all;
clc;

N = 4096;
Fd = 44100;

mode = 'home';
%mode = 'work';

%test = 'sin';
%test = 'const';
test = 'num';

%% ===============================   coef:   ===============================

if(strcmp(mode, 'work'))
    w_re_2(1:1024) = load('D:\work\fft\matlab\w_re4096_1.txt');
    w_im_2(1:1024) = load('D:\work\fft\matlab\w_im4096_1.txt');

    w_re_3(1:1024) = load('D:\work\fft\matlab\w_re4096_2.txt');
    w_im_3(1:1024) = load('D:\work\fft\matlab\w_im4096_2.txt');

    w_re_4(1:1024) = load('D:\work\fft\matlab\w_re4096_3.txt');
    w_im_4(1:1024) = load('D:\work\fft\matlab\w_im4096_3.txt');
elseif(strcmp(mode, 'home'))
    w_re_2(1:1024) = load('D:\SS\fpga\fft\matlab\w_re4096_1.txt');
    w_im_2(1:1024) = load('D:\SS\fpga\fft\matlab\w_im4096_1.txt');

    w_re_3(1:1024) = load('D:\SS\fpga\fft\matlab\w_re4096_2.txt');
    w_im_3(1:1024) = load('D:\SS\fpga\fft\matlab\w_im4096_2.txt');

    w_re_4(1:1024) = load('D:\SS\fpga\fft\matlab\w_re4096_3.txt');
    w_im_4(1:1024) = load('D:\SS\fpga\fft\matlab\w_im4096_3.txt');
else
    error('"mode" is wrong');
end

    w_re_2 = w_re_2'; w_im_2 = w_im_2';
    w_re_3 = w_re_3'; w_im_3 = w_im_3';
    w_re_4 = w_re_4'; w_im_4 = w_im_4';

    w_re_2_buf = w_re_2(1:4:16);
w_re_2_2st(1:16) = [w_re_2_buf, w_re_2_buf, w_re_2_buf, w_re_2_buf];
    w_re_3_buf = w_re_3(1:4:16);
w_re_3_2st(1:16) = [w_re_3_buf, w_re_3_buf, w_re_3_buf, w_re_3_buf];
    w_re_4_buf = w_re_4(1:4:16);
w_re_4_2st(1:16) = [w_re_4_buf, w_re_4_buf, w_re_4_buf, w_re_4_buf];

    w_im_2_buf = w_im_2(1:4:16);
w_im_2_2st(1:16) = [w_im_2_buf, w_im_2_buf, w_im_2_buf, w_im_2_buf];
    w_im_3_buf = w_im_3(1:4:16);
w_im_3_2st(1:16) = [w_im_3_buf, w_im_3_buf, w_im_3_buf, w_im_3_buf];
    w_im_4_buf = w_im_4(1:4:16);
w_im_4_2st(1:16) = [w_im_4_buf, w_im_4_buf, w_im_4_buf, w_im_4_buf];

w_re_2_2st = w_re_2_2st'; w_im_2_2st = w_im_2_2st';
w_re_3_2st = w_re_3_2st'; w_im_3_2st = w_im_3_2st';
w_re_4_2st = w_re_4_2st'; w_im_4_2st = w_im_4_2st';

    clear w_re_2_buf; clear w_re_3_buf; clear w_re_4_buf;  
    clear w_im_2_buf; clear w_im_3_buf; clear w_im_4_buf;

    w_re_2_buf = w_re_2_2st(1:4:16);
w_re_2_3st(1:16) = [w_re_2_buf, w_re_2_buf, w_re_2_buf, w_re_2_buf];
    w_re_3_buf = w_re_3_2st(1:4:16);
w_re_3_3st(1:16) = [w_re_3_buf, w_re_3_buf, w_re_3_buf, w_re_3_buf];
    w_re_4_buf = w_re_4_2st(1:4:16);
w_re_4_3st(1:16) = [w_re_4_buf, w_re_4_buf, w_re_4_buf, w_re_4_buf];

    w_im_2_buf = w_im_2_2st(1:4:16);
w_im_2_3st(1:16) = [w_im_2_buf, w_im_2_buf, w_im_2_buf, w_im_2_buf];
    w_im_3_buf = w_im_3_2st(1:4:16);
w_im_3_3st(1:16) = [w_im_3_buf, w_im_3_buf, w_im_3_buf, w_im_3_buf];
    w_im_4_buf = w_im_4_2st(1:4:16);
w_im_4_3st(1:16) = [w_im_4_buf, w_im_4_buf, w_im_4_buf, w_im_4_buf];

w_re_2_3st = w_re_2_3st'; w_im_2_3st = w_im_2_3st';
w_re_3_3st = w_re_3_3st'; w_im_3_3st = w_im_3_3st';
w_re_4_3st = w_re_4_3st'; w_im_4_3st = w_im_4_3st';

    clear w_re_2_buf; clear w_re_3_buf; clear w_re_4_buf;  
    clear w_im_2_buf; clear w_im_3_buf; clear w_im_4_buf;

%% ===============================   start:   ==============================
ram_re(1:1024, 1:4) = zeros;
ram_im(1:1024, 1:4) = zeros;

amp_1 = 10000; % e.g. 16 bit ADC
amp_2 = 000; % 2nd sine

freq_1 = 9000; % Hz
freq_2 = 4500;

phase_1 = 0; % grad
phase_2 = 37;

bias = amp_1;
time = 0 : 1/Fd : (N - 1)/Fd;

signal = bias + amp_1*sind((freq_1*360).* time + phase_1) + amp_2*sind((freq_2*360).* time + phase_2);

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
    for j = 1:1024
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

signal = signal';
figure;
plot(time, signal);
grid on;

%{
% 1 st:
% output mixer:
    % real:
    ram_re(1:4, 1:4) =      [ram_re(1:4,   1), ram_re(1:4,   2), ram_re(1:4,   3), ram_re(1:4,   4)];
    ram_re(5:8, 1:4) =      [ram_re(5:8,   2), ram_re(5:8,   3), ram_re(5:8,   4), ram_re(5:8,   1)];
    ram_re(9:12, 1:4) =     [ram_re(9:12,  3), ram_re(9:12,  4), ram_re(9:12,  1), ram_re(9:12,  2)];
    ram_re(13:16, 1:4) =	[ram_re(13:16, 4), ram_re(13:16, 1), ram_re(13:16, 2), ram_re(13:16, 3)];
    
    % imag:
    ram_im(1:4, 1:4) =      [ram_im(1:4,   1), ram_im(1:4,   2), ram_im(1:4,   3), ram_im(1:4,   4)];
    ram_im(5:8, 1:4) =      [ram_im(5:8,   2), ram_im(5:8,   3), ram_im(5:8,   4), ram_im(5:8,   1)];
    ram_im(9:12, 1:4) =     [ram_im(9:12,  3), ram_im(9:12,  4), ram_im(9:12,  1), ram_im(9:12,  2)];
    ram_im(13:16, 1:4) =	[ram_im(13:16, 4), ram_im(13:16, 1), ram_im(13:16, 2), ram_im(13:16, 3)];   
    
% 2 st:    
    % input mixer + rotate addr:
    % real:
    ram_a_re_buf(1:4, 1:4) =	[ram_re(1:4, 1), ram_re(5:8, 4), ram_re(9:12, 3), ram_re(13:16, 2)];
    ram_a_re_buf(5:8, 1:4) =	[ram_re(1:4, 2), ram_re(5:8, 1), ram_re(9:12, 4), ram_re(13:16, 3)];
    ram_a_re_buf(9:12, 1:4) =	[ram_re(1:4, 3), ram_re(5:8, 2), ram_re(9:12, 1), ram_re(13:16, 4)];
    ram_a_re_buf(13:16, 1:4) =	[ram_re(1:4, 4), ram_re(5:8, 3), ram_re(9:12, 2), ram_re(13:16, 1)];
    
    % imag:
    ram_a_im_buf(1:4, 1:4) =	[ram_im(1:4, 1), ram_im(5:8, 4), ram_im(9:12, 3), ram_im(13:16, 2)];
    ram_a_im_buf(5:8, 1:4) =	[ram_im(1:4, 2), ram_im(5:8, 1), ram_im(9:12, 4), ram_im(13:16, 3)];
    ram_a_im_buf(9:12, 1:4) =	[ram_im(1:4, 3), ram_im(5:8, 2), ram_im(9:12, 1), ram_im(13:16, 4)];
    ram_a_im_buf(13:16, 1:4) =	[ram_im(1:4, 4), ram_im(5:8, 3), ram_im(9:12, 2), ram_im(13:16, 1)];
    
    % output mixer:
    for i = 1:4
        t = (i-1)*4;
        % real:
        ram_re(1+t, 1:4) = [ram_a_re_buf(1+t, 1), ram_a_re_buf(1+t, 2), ram_a_re_buf(1+t, 3), ram_a_re_buf(1+t, 4)];
        ram_re(2+t, 1:4) = [ram_a_re_buf(2+t, 2), ram_a_re_buf(2+t, 3), ram_a_re_buf(2+t, 4), ram_a_re_buf(2+t, 1)];
        ram_re(3+t, 1:4) = [ram_a_re_buf(3+t, 3), ram_a_re_buf(3+t, 4), ram_a_re_buf(3+t, 1), ram_a_re_buf(3+t, 2)];
        ram_re(4+t, 1:4) = [ram_a_re_buf(4+t, 4), ram_a_re_buf(4+t, 1), ram_a_re_buf(4+t, 2), ram_a_re_buf(4+t, 3)];

        % imag:
        ram_im(1+t, 1:4) = [ram_a_im_buf(1+t, 1), ram_a_im_buf(1+t, 2), ram_a_im_buf(1+t, 3), ram_a_im_buf(1+t, 4)];
        ram_im(2+t, 1:4) = [ram_a_im_buf(2+t, 2), ram_a_im_buf(2+t, 3), ram_a_im_buf(2+t, 4), ram_a_im_buf(2+t, 1)];
        ram_im(3+t, 1:4) = [ram_a_im_buf(3+t, 3), ram_a_im_buf(3+t, 4), ram_a_im_buf(3+t, 1), ram_a_im_buf(3+t, 2)];
        ram_im(4+t, 1:4) = [ram_a_im_buf(4+t, 4), ram_a_im_buf(4+t, 1), ram_a_im_buf(4+t, 2), ram_a_im_buf(4+t, 3)];
    end
    
% 3 st:
    % input mixer + rotate addr:
    for i = 1:4
        t = (i-1)*4;
        % real:
        ram_a_re_buf(1+t, 1:4) = [ram_re(1+t, 1), ram_re(2+t, 4), ram_re(3+t, 3), ram_re(4+t, 2)];
        ram_a_re_buf(2+t, 1:4) = [ram_re(1+t, 2), ram_re(2+t, 1), ram_re(3+t, 4), ram_re(4+t, 3)];
        ram_a_re_buf(3+t, 1:4) = [ram_re(1+t, 3), ram_re(2+t, 2), ram_re(3+t, 1), ram_re(4+t, 4)];
        ram_a_re_buf(4+t, 1:4) = [ram_re(1+t, 4), ram_re(2+t, 3), ram_re(3+t, 2), ram_re(4+t, 1)];

        % imag:
        ram_a_im_buf(1+t, 1:4) = [ram_im(1+t, 1), ram_im(2+t, 4), ram_im(3+t, 3), ram_im(4+t, 2)];
        ram_a_im_buf(2+t, 1:4) = [ram_im(1+t, 2), ram_im(2+t, 1), ram_im(3+t, 4), ram_im(4+t, 3)];
        ram_a_im_buf(3+t, 1:4) = [ram_im(1+t, 3), ram_im(2+t, 2), ram_im(3+t, 1), ram_im(4+t, 4)];
        ram_a_im_buf(4+t, 1:4) = [ram_im(1+t, 4), ram_im(2+t, 3), ram_im(3+t, 2), ram_im(4+t, 1)];
    end
    
    % output mixer:
    for i = 1:4
        t = (i-1)*4;
        % real:
        ram_re(1+t, 1:4) = [ram_a_re_buf(1+t, 1), ram_a_re_buf(1+t, 2), ram_a_re_buf(1+t, 3), ram_a_re_buf(1+t, 4)];
        ram_re(2+t, 1:4) = [ram_a_re_buf(2+t, 2), ram_a_re_buf(2+t, 3), ram_a_re_buf(2+t, 4), ram_a_re_buf(2+t, 1)];
        ram_re(3+t, 1:4) = [ram_a_re_buf(3+t, 3), ram_a_re_buf(3+t, 4), ram_a_re_buf(3+t, 1), ram_a_re_buf(3+t, 2)];
        ram_re(4+t, 1:4) = [ram_a_re_buf(4+t, 4), ram_a_re_buf(4+t, 1), ram_a_re_buf(4+t, 2), ram_a_re_buf(4+t, 3)];

        % imag:
        ram_im(1+t, 1:4) = [ram_a_im_buf(1+t, 1), ram_a_im_buf(1+t, 2), ram_a_im_buf(1+t, 3), ram_a_im_buf(1+t, 4)];
        ram_im(2+t, 1:4) = [ram_a_im_buf(2+t, 2), ram_a_im_buf(2+t, 3), ram_a_im_buf(2+t, 4), ram_a_im_buf(2+t, 1)];
        ram_im(3+t, 1:4) = [ram_a_im_buf(3+t, 3), ram_a_im_buf(3+t, 4), ram_a_im_buf(3+t, 1), ram_a_im_buf(3+t, 2)];
        ram_im(4+t, 1:4) = [ram_a_im_buf(4+t, 4), ram_a_im_buf(4+t, 1), ram_a_im_buf(4+t, 2), ram_a_im_buf(4+t, 3)];
    end
%}

%% ===========================    1 stage    ===============================
% butterfly:
    but_re(1:1024, 1) = (ram_re(1:1024, 1) + ram_re(1:1024, 2) + ram_re(1:1024, 3) + ram_re(1:1024, 4))/4;
    but_re(1:1024, 2) = (ram_re(1:1024, 1) + ram_im(1:1024, 2) - ram_re(1:1024, 3) - ram_im(1:1024, 4))/4;
    but_re(1:1024, 3) = (ram_re(1:1024, 1) - ram_re(1:1024, 2) + ram_re(1:1024, 3) - ram_re(1:1024, 4))/4;
    but_re(1:1024, 4) = (ram_re(1:1024, 1) - ram_im(1:1024, 2) - ram_re(1:1024, 3) + ram_im(1:1024, 4))/4;

    but_im(1:1024, 1) = (ram_im(1:1024, 1) + ram_im(1:1024, 2) + ram_im(1:1024, 3) + ram_im(1:1024, 4))/4;
    but_im(1:1024, 2) = (ram_im(1:1024, 1) - ram_re(1:1024, 2) - ram_im(1:1024, 3) + ram_re(1:1024, 4))/4;
    but_im(1:1024, 3) = (ram_im(1:1024, 1) - ram_im(1:1024, 2) + ram_im(1:1024, 3) - ram_im(1:1024, 4))/4;
    but_im(1:1024, 4) = (ram_im(1:1024, 1) + ram_re(1:1024, 2) - ram_im(1:1024, 3) - ram_re(1:1024, 4))/4;

% multipiler:
    mult_re(1:1024, 1) = but_re(1:1024, 1);
    mult_im(1:1024, 1) = but_im(1:1024, 1);

    mult_re(1:1024, 2) = (but_re(1:1024, 2).*w_re_2(1:1024) - but_im(1:1024, 2).*w_im_2(1:1024))/1024;
    mult_im(1:1024, 2) = (but_re(1:1024, 2).*w_im_2(1:1024) + but_im(1:1024, 2).*w_re_2(1:1024))/1024;

    mult_re(1:1024, 3) = (but_re(1:1024, 3).*w_re_3(1:1024) - but_im(1:1024, 3).*w_im_3(1:1024))/1024;
    mult_im(1:1024, 3) = (but_re(1:1024, 3).*w_im_3(1:1024) + but_im(1:1024, 3).*w_re_3(1:1024))/1024;

    mult_re(1:1024, 4) = (but_re(1:1024, 4).*w_re_4(1:1024) - but_im(1:1024, 4).*w_im_4(1:1024))/1024; 
    mult_im(1:1024, 4) = (but_re(1:1024, 4).*w_im_4(1:1024) + but_im(1:1024, 4).*w_re_4(1:1024))/1024;

% output mixer:
    ram_re(1:256,   1:4) = [mult_re(1:256,   1), mult_re(1:256,   2), mult_re(1:256,   3), mult_re(1:256,   4)];
    ram_re(257:512, 1:4) = [mult_re(257:512, 2), mult_re(257:512, 3), mult_re(257:512, 4), mult_re(257:512, 1)];
    ram_re(513:768, 1:4) = [mult_re(513:768, 3), mult_re(513:768, 4), mult_re(513:768, 1), mult_re(513:768, 2)];
    ram_re(769:1024,1:4) = [mult_re(769:1024,4), mult_re(769:1024,1), mult_re(769:1024,2), mult_re(769:1024,3)];
    
    ram_im(1:256,   1:4) = [mult_im(1:256,   1), mult_im(1:256,   2), mult_im(1:256,   3), mult_im(1:256,   4)];
    ram_im(257:512, 1:4) = [mult_im(257:512, 2), mult_im(257:512, 3), mult_im(257:512, 4), mult_im(257:512, 1)];
    ram_im(513:768, 1:4) = [mult_im(513:768, 3), mult_im(513:768, 4), mult_im(513:768, 1), mult_im(513:768, 2)];
    ram_im(769:1024,1:4) = [mult_im(769:1024,4), mult_im(769:1024,1), mult_im(769:1024,2), mult_im(769:1024,3)];

%% ===========================    2 stage    ===============================
% input mixer + rotate addr:
    ram_a_re_buf(1:256,   1:4) = [ram_re(1:256, 1), ram_re(257:512, 4), ram_re(513:768, 3), ram_re(769:1024, 2)];
    ram_a_re_buf(257:512, 1:4) = [ram_re(1:256, 2), ram_re(257:512, 1), ram_re(513:768, 4), ram_re(769:1024, 3)];
    ram_a_re_buf(513:768, 1:4) = [ram_re(1:256, 3), ram_re(257:512, 2), ram_re(513:768, 1), ram_re(769:1024, 4)];
    ram_a_re_buf(769:1024,1:4) = [ram_re(1:256, 4), ram_re(257:512, 3), ram_re(513:768, 2), ram_re(769:1024, 1)];
    
    ram_a_im_buf(1:256,   1:4) = [ram_im(1:256, 1), ram_im(257:512, 4), ram_im(513:768, 3), ram_im(769:1024, 2)];
    ram_a_im_buf(257:512, 1:4) = [ram_im(1:256, 2), ram_im(257:512, 1), ram_im(513:768, 4), ram_im(769:1024, 3)];
    ram_a_im_buf(513:768, 1:4) = [ram_im(1:256, 3), ram_im(257:512, 2), ram_im(513:768, 1), ram_im(769:1024, 4)];
    ram_a_im_buf(769:1024,1:4) = [ram_im(1:256, 4), ram_im(257:512, 3), ram_im(513:768, 2), ram_im(769:1024, 1)];
    
ram_re = ram_a_re_buf;
ram_im = ram_a_im_buf;
clear ram_a_re_buf; clear ram_a_im_buf;
    
% butterfly:
    but_re(1:1024, 1) = (ram_re(1:1024, 1) + ram_re(1:1024, 2) + ram_re(1:1024, 3) + ram_re(1:1024, 4))/4;
    but_re(1:1024, 2) = (ram_re(1:1024, 1) + ram_im(1:1024, 2) - ram_re(1:1024, 3) - ram_im(1:1024, 4))/4;
    but_re(1:1024, 3) = (ram_re(1:1024, 1) - ram_re(1:1024, 2) + ram_re(1:1024, 3) - ram_re(1:1024, 4))/4;
    but_re(1:1024, 4) = (ram_re(1:1024, 1) - ram_im(1:1024, 2) - ram_re(1:1024, 3) + ram_im(1:1024, 4))/4;

    but_im(1:1024, 1) = (ram_im(1:1024, 1) + ram_im(1:1024, 2) + ram_im(1:1024, 3) + ram_im(1:1024, 4))/4;
    but_im(1:1024, 2) = (ram_im(1:1024, 1) - ram_re(1:1024, 2) - ram_im(1:1024, 3) + ram_re(1:1024, 4))/4;
    but_im(1:1024, 3) = (ram_im(1:1024, 1) - ram_im(1:1024, 2) + ram_im(1:1024, 3) - ram_im(1:1024, 4))/4;
    but_im(1:1024, 4) = (ram_im(1:1024, 1) + ram_re(1:1024, 2) - ram_im(1:1024, 3) - ram_re(1:1024, 4))/4;
    
% multipiler:
    mult_re(1:1024, 1) = but_re(1:1024, 1); % 0
    mult_im(1:1024, 1) = but_im(1:1024, 1);

    mult_re(1:1024, 2) = (but_re(1:1024, 2).*w_re_2(1:1024) - but_im(1:1024, 2).*w_im_2(1:1024))/1024;
    mult_im(1:1024, 2) = (but_re(1:1024, 2).*w_im_2(1:1024) + but_im(1:1024, 2).*w_re_2(1:1024))/1024;

    mult_re(1:1024, 3) = (but_re(1:1024, 3).*w_re_3(1:1024) - but_im(1:1024, 3).*w_im_3(1:1024))/1024;
    mult_im(1:1024, 3) = (but_re(1:1024, 3).*w_im_3(1:1024) + but_im(1:1024, 3).*w_re_3(1:1024))/1024;

    mult_re(1:1024, 4) = (but_re(1:1024, 4).*w_re_4(1:1024) - but_im(1:1024, 4).*w_im_4(1:1024))/1024;
    mult_im(1:1024, 4) = (but_re(1:1024, 4).*w_im_4(1:1024) + but_im(1:1024, 4).*w_re_4(1:1024))/1024;
    
    clear w_re_2_2st; clear w_re_3_2st; clear w_re_4_2st;
    
% output mixer:
for i = 1:4
    t = (i-1)*4;
    % real:
    ram_re(1+t, 1:4) = [mult_re(1+t, 1), mult_re(1+t, 2), mult_re(1+t, 3), mult_re(1+t, 4)];
    ram_re(2+t, 1:4) = [mult_re(2+t, 2), mult_re(2+t, 3), mult_re(2+t, 4), mult_re(2+t, 1)];
    ram_re(3+t, 1:4) = [mult_re(3+t, 3), mult_re(3+t, 4), mult_re(3+t, 1), mult_re(3+t, 2)];
    ram_re(4+t, 1:4) = [mult_re(4+t, 4), mult_re(4+t, 1), mult_re(4+t, 2), mult_re(4+t, 3)];
    
    % imag:
    ram_im(1+t, 1:4) = [mult_im(1+t, 1), mult_im(1+t, 2), mult_im(1+t, 3), mult_im(1+t, 4)];
    ram_im(2+t, 1:4) = [mult_im(2+t, 2), mult_im(2+t, 3), mult_im(2+t, 4), mult_im(2+t, 1)];
    ram_im(3+t, 1:4) = [mult_im(3+t, 3), mult_im(3+t, 4), mult_im(3+t, 1), mult_im(3+t, 2)];
    ram_im(4+t, 1:4) = [mult_im(4+t, 4), mult_im(4+t, 1), mult_im(4+t, 2), mult_im(4+t, 3)];
end

%% ===========================    3 stage    ===============================

ram_a_re_buf(1:16, 1:4) = zeros;
ram_a_im_buf(1:16, 1:4) = zeros;

% input mixer + rotate addr:
for i = 1:4
    t = (i-1)*4;
    % real:
    ram_a_re_buf(1+t, 1:4) = [ram_re(1+t, 1), ram_re(2+t, 4), ram_re(3+t, 3), ram_re(4+t, 2)];
    ram_a_re_buf(2+t, 1:4) = [ram_re(1+t, 2), ram_re(2+t, 1), ram_re(3+t, 4), ram_re(4+t, 3)];
    ram_a_re_buf(3+t, 1:4) = [ram_re(1+t, 3), ram_re(2+t, 2), ram_re(3+t, 1), ram_re(4+t, 4)];
    ram_a_re_buf(4+t, 1:4) = [ram_re(1+t, 4), ram_re(2+t, 3), ram_re(3+t, 2), ram_re(4+t, 1)];
    
    % imag:
    ram_a_im_buf(1+t, 1:4) = [ram_im(1+t, 1), ram_im(2+t, 4), ram_im(3+t, 3), ram_im(4+t, 2)];
    ram_a_im_buf(2+t, 1:4) = [ram_im(1+t, 2), ram_im(2+t, 1), ram_im(3+t, 4), ram_im(4+t, 3)];
    ram_a_im_buf(3+t, 1:4) = [ram_im(1+t, 3), ram_im(2+t, 2), ram_im(3+t, 1), ram_im(4+t, 4)];
    ram_a_im_buf(4+t, 1:4) = [ram_im(1+t, 4), ram_im(2+t, 3), ram_im(3+t, 2), ram_im(4+t, 1)];
end
    
ram_re = ram_a_re_buf;
ram_im = ram_a_im_buf;
clear ram_a_re_buf; clear ram_a_im_buf;
    
% butterfly:
    but_re(1:16, 1) = (ram_re(1:16, 1) + ram_re(1:16, 2) + ram_re(1:16, 3) + ram_re(1:16, 4))/4;
    but_re(1:16, 2) = (ram_re(1:16, 1) + ram_im(1:16, 2) - ram_re(1:16, 3) - ram_im(1:16, 4))/4;
    but_re(1:16, 3) = (ram_re(1:16, 1) - ram_re(1:16, 2) + ram_re(1:16, 3) - ram_re(1:16, 4))/4;
    but_re(1:16, 4) = (ram_re(1:16, 1) - ram_im(1:16, 2) - ram_re(1:16, 3) + ram_im(1:16, 4))/4;

    but_im(1:16, 1) = (ram_im(1:16, 1) + ram_im(1:16, 2) + ram_im(1:16, 3) + ram_im(1:16, 4))/4;
    but_im(1:16, 2) = (ram_im(1:16, 1) - ram_re(1:16, 2) - ram_im(1:16, 3) + ram_re(1:16, 4))/4;
    but_im(1:16, 3) = (ram_im(1:16, 1) - ram_im(1:16, 2) + ram_im(1:16, 3) - ram_im(1:16, 4))/4;
    but_im(1:16, 4) = (ram_im(1:16, 1) + ram_re(1:16, 2) - ram_im(1:16, 3) - ram_re(1:16, 4))/4;

%{
% multipiler:
    mult_re(1:16, 1) = but_re(1:16, 1); % 0
    mult_im(1:16, 1) = but_im(1:16, 1);

    mult_re(1:16, 2) = but_re(1:16, 2); % 0
    mult_im(1:16, 2) = but_im(1:16, 2);

    mult_re(1:16, 3) = but_re(1:16, 3); % 0
    mult_im(1:16, 3) = but_im(1:16, 3);

    mult_re(1:16, 4) = but_re(1:16, 4); % 0
    mult_im(1:16, 4) = but_im(1:16, 4);
    
    %clear w_re_2_2st; clear w_re_3_2st; clear w_re_4_2st;
%}

%{
% output mixer:
for i = 1:4
    t = (i-1)*4;
    % real:
    ram_re(1+t, 1:4) = [mult_re(1+t, 1), mult_re(1+t, 2), mult_re(1+t, 3), mult_re(1+t, 4)];
    ram_re(2+t, 1:4) = [mult_re(2+t, 2), mult_re(2+t, 3), mult_re(2+t, 4), mult_re(2+t, 1)];
    ram_re(3+t, 1:4) = [mult_re(3+t, 3), mult_re(3+t, 4), mult_re(3+t, 1), mult_re(3+t, 2)];
    ram_re(4+t, 1:4) = [mult_re(4+t, 4), mult_re(4+t, 1), mult_re(4+t, 2), mult_re(4+t, 3)];
    
    % imag:
    ram_im(1+t, 1:4) = [mult_im(1+t, 1), mult_im(1+t, 2), mult_im(1+t, 3), mult_im(1+t, 4)];
    ram_im(2+t, 1:4) = [mult_im(2+t, 2), mult_im(2+t, 3), mult_im(2+t, 4), mult_im(2+t, 1)];
    ram_im(3+t, 1:4) = [mult_im(3+t, 3), mult_im(3+t, 4), mult_im(3+t, 1), mult_im(3+t, 2)];
    ram_im(4+t, 1:4) = [mult_im(4+t, 4), mult_im(4+t, 1), mult_im(4+t, 2), mult_im(4+t, 3)];
end
%}
    
%% output files
if(strcmp(mode, 'work'))
    file_a_re = fopen('D:\work\fft\matlab\ram_a_re.txt', 'w');
    file_a_im = fopen('D:\work\fft\matlab\ram_a_im.txt', 'w');
elseif(strcmp(mode, 'home'))
    file_a_re = fopen('D:\SS\fpga\fft\matlab\ram_a_re.txt', 'w');
    file_a_im = fopen('D:\SS\fpga\fft\matlab\ram_a_im.txt', 'w');
end

for i = 1:16
    fprintf(file_a_re, '%d\t%d\t%d\t%d\n', but_re(i, 1:4)); 
    fprintf(file_a_im, '%d\t%d\t%d\t%d\n', but_im(i, 1:4)); 
end

fclose(file_a_re);
fclose(file_a_im);