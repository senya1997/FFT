clear;
close all;
clc;

N = 4096;
Fd = 44100;

mode = 'home';
%mode = 'work';

test = 'sin';
%test = 'const';
%test = 'num';

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

% 2st
    w_re_2_buf = w_re_2(1:4:1024);
w_re_2_2st(1:1024) = [w_re_2_buf, w_re_2_buf, w_re_2_buf, w_re_2_buf];
    w_re_3_buf = w_re_3(1:4:1024);
w_re_3_2st(1:1024) = [w_re_3_buf, w_re_3_buf, w_re_3_buf, w_re_3_buf];
    w_re_4_buf = w_re_4(1:4:1024);
w_re_4_2st(1:1024) = [w_re_4_buf, w_re_4_buf, w_re_4_buf, w_re_4_buf];

    w_im_2_buf = w_im_2(1:4:1024);
w_im_2_2st(1:1024) = [w_im_2_buf, w_im_2_buf, w_im_2_buf, w_im_2_buf];
    w_im_3_buf = w_im_3(1:4:1024);
w_im_3_2st(1:1024) = [w_im_3_buf, w_im_3_buf, w_im_3_buf, w_im_3_buf];
    w_im_4_buf = w_im_4(1:4:1024);
w_im_4_2st(1:1024) = [w_im_4_buf, w_im_4_buf, w_im_4_buf, w_im_4_buf];

w_re_2_2st = w_re_2_2st'; w_im_2_2st = w_im_2_2st';
w_re_3_2st = w_re_3_2st'; w_im_3_2st = w_im_3_2st';
w_re_4_2st = w_re_4_2st'; w_im_4_2st = w_im_4_2st';

    clear w_re_2_buf; clear w_re_3_buf; clear w_re_4_buf;  
    clear w_im_2_buf; clear w_im_3_buf; clear w_im_4_buf;

% 3st
    w_re_2_buf = w_re_2_2st(1:4:1024);
w_re_2_3st(1:1024) = [w_re_2_buf, w_re_2_buf, w_re_2_buf, w_re_2_buf];
    w_re_3_buf = w_re_3_2st(1:4:1024);
w_re_3_3st(1:1024) = [w_re_3_buf, w_re_3_buf, w_re_3_buf, w_re_3_buf];
    w_re_4_buf = w_re_4_2st(1:4:1024);
w_re_4_3st(1:1024) = [w_re_4_buf, w_re_4_buf, w_re_4_buf, w_re_4_buf];

    w_im_2_buf = w_im_2_2st(1:4:1024);
w_im_2_3st(1:1024) = [w_im_2_buf, w_im_2_buf, w_im_2_buf, w_im_2_buf];
    w_im_3_buf = w_im_3_2st(1:4:1024);
w_im_3_3st(1:1024) = [w_im_3_buf, w_im_3_buf, w_im_3_buf, w_im_3_buf];
    w_im_4_buf = w_im_4_2st(1:4:1024);
w_im_4_3st(1:1024) = [w_im_4_buf, w_im_4_buf, w_im_4_buf, w_im_4_buf];

w_re_2_3st = w_re_2_3st'; w_im_2_3st = w_im_2_3st';
w_re_3_3st = w_re_3_3st'; w_im_3_3st = w_im_3_3st';
w_re_4_3st = w_re_4_3st'; w_im_4_3st = w_im_4_3st';

    clear w_re_2_buf; clear w_re_3_buf; clear w_re_4_buf;  
    clear w_im_2_buf; clear w_im_3_buf; clear w_im_4_buf;
    
% 4st
    w_re_2_buf = w_re_2_3st(1:4:1024);
w_re_2_4st(1:1024) = [w_re_2_buf, w_re_2_buf, w_re_2_buf, w_re_2_buf];
    w_re_3_buf = w_re_3_3st(1:4:1024);
w_re_3_4st(1:1024) = [w_re_3_buf, w_re_3_buf, w_re_3_buf, w_re_3_buf];
    w_re_4_buf = w_re_4_3st(1:4:1024);
w_re_4_4st(1:1024) = [w_re_4_buf, w_re_4_buf, w_re_4_buf, w_re_4_buf];

    w_im_2_buf = w_im_2_3st(1:4:1024);
w_im_2_4st(1:1024) = [w_im_2_buf, w_im_2_buf, w_im_2_buf, w_im_2_buf];
    w_im_3_buf = w_im_3_3st(1:4:1024);
w_im_3_4st(1:1024) = [w_im_3_buf, w_im_3_buf, w_im_3_buf, w_im_3_buf];
    w_im_4_buf = w_im_4_3st(1:4:1024);
w_im_4_4st(1:1024) = [w_im_4_buf, w_im_4_buf, w_im_4_buf, w_im_4_buf];

w_re_2_4st = w_re_2_4st'; w_im_2_4st = w_im_2_4st';
w_re_3_4st = w_re_3_4st'; w_im_3_4st = w_im_3_4st';
w_re_4_4st = w_re_4_4st'; w_im_4_4st = w_im_4_4st';

    clear w_re_2_buf; clear w_re_3_buf; clear w_re_4_buf;  
    clear w_im_2_buf; clear w_im_3_buf; clear w_im_4_buf;

% 5st
    w_re_2_buf = w_re_2_4st(1:4:1024);
w_re_2_5st(1:1024) = [w_re_2_buf, w_re_2_buf, w_re_2_buf, w_re_2_buf];
    w_re_3_buf = w_re_3_4st(1:4:1024);
w_re_3_5st(1:1024) = [w_re_3_buf, w_re_3_buf, w_re_3_buf, w_re_3_buf];
    w_re_4_buf = w_re_4_4st(1:4:1024);
w_re_4_5st(1:1024) = [w_re_4_buf, w_re_4_buf, w_re_4_buf, w_re_4_buf];

    w_im_2_buf = w_im_2_4st(1:4:1024);
w_im_2_5st(1:1024) = [w_im_2_buf, w_im_2_buf, w_im_2_buf, w_im_2_buf];
    w_im_3_buf = w_im_3_4st(1:4:1024);
w_im_3_5st(1:1024) = [w_im_3_buf, w_im_3_buf, w_im_3_buf, w_im_3_buf];
    w_im_4_buf = w_im_4_4st(1:4:1024);
w_im_4_5st(1:1024) = [w_im_4_buf, w_im_4_buf, w_im_4_buf, w_im_4_buf];

w_re_2_5st = w_re_2_5st'; w_im_2_5st = w_im_2_5st';
w_re_3_5st = w_re_3_5st'; w_im_3_5st = w_im_3_5st';
w_re_4_5st = w_re_4_5st'; w_im_4_5st = w_im_4_5st';

    clear w_re_2_buf; clear w_re_3_buf; clear w_re_4_buf;  
    clear w_im_2_buf; clear w_im_3_buf; clear w_im_4_buf;
    
%% ===============================   start:   ==============================
ram_re(1:1024, 1:4) = zeros;
ram_im(1:1024, 1:4) = zeros;

amp_1 = 10000; % e.g. 16 bit ADC
amp_2 = 5000; % 2nd sine

freq_1 = 9000; % Hz
freq_2 = 4500;

phase_1 = 0; % grad
phase_2 = 37;

bias = amp_1;
time = 0 : 1/Fd : (N - 1)/Fd;

signal = bias + amp_1*sind((freq_1*360).* time + phase_1) + amp_2*sind((freq_2*360).* time + phase_2);

[y, Fs] = audioread('impulses/g.wav');
signal(1:N) = y(1:N);

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
            %ram_im(j, i) = k - 1;
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
    ram_re_buf1(1:256,   1:4) = [ram_re(1:256,   1), ram_re(1:256,   2), ram_re(1:256,   3), ram_re(1:256,   4)];
    ram_re_buf1(257:512, 1:4) = [ram_re(257:512, 2), ram_re(257:512, 3), ram_re(257:512, 4), ram_re(257:512, 1)];
    ram_re_buf1(513:768, 1:4) = [ram_re(513:768, 3), ram_re(513:768, 4), ram_re(513:768, 1), ram_re(513:768, 2)];
    ram_re_buf1(769:1024,1:4) = [ram_re(769:1024,4), ram_re(769:1024,1), ram_re(769:1024,2), ram_re(769:1024,3)];

% ===========================    2 stage    ===============================
% input mixer + rotate addr:
    ram_a_re_buf(1:256,   1:4) = [ram_re_buf1(1:256, 1), ram_re_buf1(257:512, 4), ram_re_buf1(513:768, 3), ram_re_buf1(769:1024, 2)];
    ram_a_re_buf(257:512, 1:4) = [ram_re_buf1(1:256, 2), ram_re_buf1(257:512, 1), ram_re_buf1(513:768, 4), ram_re_buf1(769:1024, 3)];
    ram_a_re_buf(513:768, 1:4) = [ram_re_buf1(1:256, 3), ram_re_buf1(257:512, 2), ram_re_buf1(513:768, 1), ram_re_buf1(769:1024, 4)];
    ram_a_re_buf(769:1024,1:4) = [ram_re_buf1(1:256, 4), ram_re_buf1(257:512, 3), ram_re_buf1(513:768, 2), ram_re_buf1(769:1024, 1)];
    
% output mixer:
for i = 1:4
    t = (i-1)*256;
    
    ram_re(1+t : 64+t, 1:4) =    [ram_a_re_buf(1+t : 64+t, 1),    ram_a_re_buf(1+t : 64+t, 2),    ram_a_re_buf(1+t : 64+t, 3),    ram_a_re_buf(1+t : 64+t, 4)];
    ram_re(65+t : 128+t, 1:4) =  [ram_a_re_buf(65+t : 128+t, 2),  ram_a_re_buf(65+t : 128+t, 3),  ram_a_re_buf(65+t : 128+t, 4),  ram_a_re_buf(65+t : 128+t, 1)];
    ram_re(129+t : 192+t, 1:4) = [ram_a_re_buf(129+t : 192+t, 3), ram_a_re_buf(129+t : 192+t, 4), ram_a_re_buf(129+t : 192+t, 1), ram_a_re_buf(129+t : 192+t, 2)];
    ram_re(193+t : 256+t, 1:4) = [ram_a_re_buf(193+t : 256+t, 4), ram_a_re_buf(193+t : 256+t, 1), ram_a_re_buf(193+t : 256+t, 2), ram_a_re_buf(193+t : 256+t, 3)];

end

% ===========================    3 stage    ===============================

ram_a_re_buf(1:1024, 1:4) = zeros;

% input mixer + rotate addr:
for i = 1:4
    t = (i-1)*256;
    
    ram_a_re_buf(1+t : 64+t, 1:4) =    [ram_re(1+t : 64+t, 1), ram_re(65+t : 128+t, 4), ram_re(129+t : 192+t, 3), ram_re(193+t : 256+t, 2)];
    ram_a_re_buf(65+t : 128+t, 1:4) =  [ram_re(1+t : 64+t, 2), ram_re(65+t : 128+t, 1), ram_re(129+t : 192+t, 4), ram_re(193+t : 256+t, 3)];
    ram_a_re_buf(129+t : 192+t, 1:4) = [ram_re(1+t : 64+t, 3), ram_re(65+t : 128+t, 2), ram_re(129+t : 192+t, 1), ram_re(193+t : 256+t, 4)];
    ram_a_re_buf(193+t : 256+t, 1:4) = [ram_re(1+t : 64+t, 4), ram_re(65+t : 128+t, 3), ram_re(129+t : 192+t, 2), ram_re(193+t : 256+t, 1)];
end
  
% output mixer:
for i = 1:16
    t = (i-1)*64;
    
    ram_re(1+t : 16+t, 1:4) =  [ram_a_re_buf(1+t : 16+t, 1), ram_a_re_buf(1+t : 16+t, 2), ram_a_re_buf(1+t : 16+t, 3), ram_a_re_buf(1+t : 16+t, 4)];
    ram_re(17+t : 32+t, 1:4) = [ram_a_re_buf(17+t : 32+t, 2), ram_a_re_buf(17+t : 32+t, 3), ram_a_re_buf(17+t : 32+t, 4), ram_a_re_buf(17+t : 32+t, 1)];
    ram_re(33+t : 48+t, 1:4) = [ram_a_re_buf(33+t : 48+t, 3), ram_a_re_buf(33+t : 48+t, 4), ram_a_re_buf(33+t : 48+t, 1), ram_a_re_buf(33+t : 48+t, 2)];
    ram_re(49+t : 64+t, 1:4) = [ram_a_re_buf(49+t : 64+t, 4), ram_a_re_buf(49+t : 64+t, 1), ram_a_re_buf(49+t : 64+t, 2), ram_a_re_buf(49+t : 64+t, 3)];
end

% ===========================    4 stage    ===============================

ram_a_re_buf(1:1024, 1:4) = zeros;

% input mixer + rotate addr:
for i = 1:16
    t = (i-1)*64;
    
    ram_a_re_buf(1+t : 16+t, 1:4) =  [ram_re(1+t : 16+t, 1), ram_re(17+t : 32+t, 4), ram_re(33+t : 48+t, 3), ram_re(49+t : 64+t, 2)];
    ram_a_re_buf(17+t : 32+t, 1:4) = [ram_re(1+t : 16+t, 2), ram_re(17+t : 32+t, 1), ram_re(33+t : 48+t, 4), ram_re(49+t : 64+t, 3)];
    ram_a_re_buf(33+t : 48+t, 1:4) = [ram_re(1+t : 16+t, 3), ram_re(17+t : 32+t, 2), ram_re(33+t : 48+t, 1), ram_re(49+t : 64+t, 4)];
    ram_a_re_buf(49+t : 64+t, 1:4) = [ram_re(1+t : 16+t, 4), ram_re(17+t : 32+t, 3), ram_re(33+t : 48+t, 2), ram_re(49+t : 64+t, 1)];
end
    
% output mixer:
for i = 1:64
    t = (i-1)*16;
    
    ram_re(1+t : 4+t, 1:4) =   [ram_a_re_buf(1+t : 4+t, 1),   ram_a_re_buf(1+t : 4+t, 2),   ram_a_re_buf(1+t : 4+t, 3),   ram_a_re_buf(1+t : 4+t, 4)];
    ram_re(5+t : 8+t, 1:4) =   [ram_a_re_buf(5+t : 8+t, 2),   ram_a_re_buf(5+t : 8+t, 3),   ram_a_re_buf(5+t : 8+t, 4),   ram_a_re_buf(5+t : 8+t, 1)];
    ram_re(9+t : 12+t, 1:4) =  [ram_a_re_buf(9+t : 12+t, 3),  ram_a_re_buf(9+t : 12+t, 4),  ram_a_re_buf(9+t : 12+t, 1),  ram_a_re_buf(9+t : 12+t, 2)];
    ram_re(13+t : 16+t, 1:4) = [ram_a_re_buf(13+t : 16+t, 4), ram_a_re_buf(13+t : 16+t, 1), ram_a_re_buf(13+t : 16+t, 2), ram_a_re_buf(13+t : 16+t, 3)];
end

% ===========================    5 stage    ===============================

ram_a_re_buf(1:1024, 1:4) = zeros;

% input mixer + rotate addr:
for i = 1:64
    t = (i-1)*16;
    
    ram_a_re_buf(1+t : 4+t, 1:4) =   [ram_re(1+t : 4+t, 1), ram_re(5+t : 8+t, 4), ram_re(9+t : 12+t, 3), ram_re(13+t : 16+t, 2)];
    ram_a_re_buf(5+t : 8+t, 1:4) =   [ram_re(1+t : 4+t, 2), ram_re(5+t : 8+t, 1), ram_re(9+t : 12+t, 4), ram_re(13+t : 16+t, 3)];
    ram_a_re_buf(9+t : 12+t, 1:4) =  [ram_re(1+t : 4+t, 3), ram_re(5+t : 8+t, 2), ram_re(9+t : 12+t, 1), ram_re(13+t : 16+t, 4)];
    ram_a_re_buf(13+t : 16+t, 1:4) = [ram_re(1+t : 4+t, 4), ram_re(5+t : 8+t, 3), ram_re(9+t : 12+t, 2), ram_re(13+t : 16+t, 1)];
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

    mult_re(1:1024, 2) = (but_re(1:1024, 2).*w_re_2_2st(1:1024) - but_im(1:1024, 2).*w_im_2_2st(1:1024))/1024;
    mult_im(1:1024, 2) = (but_re(1:1024, 2).*w_im_2_2st(1:1024) + but_im(1:1024, 2).*w_re_2_2st(1:1024))/1024;

    mult_re(1:1024, 3) = (but_re(1:1024, 3).*w_re_3_2st(1:1024) - but_im(1:1024, 3).*w_im_3_2st(1:1024))/1024;
    mult_im(1:1024, 3) = (but_re(1:1024, 3).*w_im_3_2st(1:1024) + but_im(1:1024, 3).*w_re_3_2st(1:1024))/1024;

    mult_re(1:1024, 4) = (but_re(1:1024, 4).*w_re_4_2st(1:1024) - but_im(1:1024, 4).*w_im_4_2st(1:1024))/1024;
    mult_im(1:1024, 4) = (but_re(1:1024, 4).*w_im_4_2st(1:1024) + but_im(1:1024, 4).*w_re_4_2st(1:1024))/1024;
    
    clear w_re_2_2st; clear w_re_3_2st; clear w_re_4_2st;
    
% output mixer:
for i = 1:4
    t = (i-1)*256;
    
    ram_re(1+t : 64+t, 1:4) =    [mult_re(1+t : 64+t, 1),    mult_re(1+t : 64+t, 2),    mult_re(1+t : 64+t, 3),    mult_re(1+t : 64+t, 4)];
    ram_re(65+t : 128+t, 1:4) =  [mult_re(65+t : 128+t, 2),  mult_re(65+t : 128+t, 3),  mult_re(65+t : 128+t, 4),  mult_re(65+t : 128+t, 1)];
    ram_re(129+t : 192+t, 1:4) = [mult_re(129+t : 192+t, 3), mult_re(129+t : 192+t, 4), mult_re(129+t : 192+t, 1), mult_re(129+t : 192+t, 2)];
    ram_re(193+t : 256+t, 1:4) = [mult_re(193+t : 256+t, 4), mult_re(193+t : 256+t, 1), mult_re(193+t : 256+t, 2), mult_re(193+t : 256+t, 3)];
    
    ram_im(1+t : 64+t, 1:4) =    [mult_im(1+t : 64+t, 1),    mult_im(1+t : 64+t, 2),    mult_im(1+t : 64+t, 3),    mult_im(1+t : 64+t, 4)];
    ram_im(65+t : 128+t, 1:4) =  [mult_im(65+t : 128+t, 2),  mult_im(65+t : 128+t, 3),  mult_im(65+t : 128+t, 4),  mult_im(65+t : 128+t, 1)];
    ram_im(129+t : 192+t, 1:4) = [mult_im(129+t : 192+t, 3), mult_im(129+t : 192+t, 4), mult_im(129+t : 192+t, 1), mult_im(129+t : 192+t, 2)];
    ram_im(193+t : 256+t, 1:4) = [mult_im(193+t : 256+t, 4), mult_im(193+t : 256+t, 1), mult_im(193+t : 256+t, 2), mult_im(193+t : 256+t, 3)];
end

%% ===========================    3 stage    ===============================

ram_a_re_buf(1:1024, 1:4) = zeros;
ram_a_im_buf(1:1024, 1:4) = zeros;

% input mixer + rotate addr:
for i = 1:4
    t = (i-1)*256;
    
    ram_a_re_buf(1+t : 64+t, 1:4) =    [ram_re(1+t : 64+t, 1), ram_re(65+t : 128+t, 4), ram_re(129+t : 192+t, 3), ram_re(193+t : 256+t, 2)];
    ram_a_re_buf(65+t : 128+t, 1:4) =  [ram_re(1+t : 64+t, 2), ram_re(65+t : 128+t, 1), ram_re(129+t : 192+t, 4), ram_re(193+t : 256+t, 3)];
    ram_a_re_buf(129+t : 192+t, 1:4) = [ram_re(1+t : 64+t, 3), ram_re(65+t : 128+t, 2), ram_re(129+t : 192+t, 1), ram_re(193+t : 256+t, 4)];
    ram_a_re_buf(193+t : 256+t, 1:4) = [ram_re(1+t : 64+t, 4), ram_re(65+t : 128+t, 3), ram_re(129+t : 192+t, 2), ram_re(193+t : 256+t, 1)];
    
    ram_a_im_buf(1+t : 64+t, 1:4) =    [ram_im(1+t : 64+t, 1), ram_im(65+t : 128+t, 4), ram_im(129+t : 192+t, 3), ram_im(193+t : 256+t, 2)];
    ram_a_im_buf(65+t : 128+t, 1:4) =  [ram_im(1+t : 64+t, 2), ram_im(65+t : 128+t, 1), ram_im(129+t : 192+t, 4), ram_im(193+t : 256+t, 3)];
    ram_a_im_buf(129+t : 192+t, 1:4) = [ram_im(1+t : 64+t, 3), ram_im(65+t : 128+t, 2), ram_im(129+t : 192+t, 1), ram_im(193+t : 256+t, 4)];
    ram_a_im_buf(193+t : 256+t, 1:4) = [ram_im(1+t : 64+t, 4), ram_im(65+t : 128+t, 3), ram_im(129+t : 192+t, 2), ram_im(193+t : 256+t, 1)];
end
    
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

    mult_re(1:1024, 2) = (but_re(1:1024, 2).*w_re_2_3st(1:1024) - but_im(1:1024, 2).*w_im_2_3st(1:1024))/1024;
    mult_im(1:1024, 2) = (but_re(1:1024, 2).*w_im_2_3st(1:1024) + but_im(1:1024, 2).*w_re_2_3st(1:1024))/1024;

    mult_re(1:1024, 3) = (but_re(1:1024, 3).*w_re_3_3st(1:1024) - but_im(1:1024, 3).*w_im_3_3st(1:1024))/1024;
    mult_im(1:1024, 3) = (but_re(1:1024, 3).*w_im_3_3st(1:1024) + but_im(1:1024, 3).*w_re_3_3st(1:1024))/1024;

    mult_re(1:1024, 4) = (but_re(1:1024, 4).*w_re_4_3st(1:1024) - but_im(1:1024, 4).*w_im_4_3st(1:1024))/1024;
    mult_im(1:1024, 4) = (but_re(1:1024, 4).*w_im_4_3st(1:1024) + but_im(1:1024, 4).*w_re_4_3st(1:1024))/1024;
    
    clear w_re_2_3st; clear w_re_3_3st; clear w_re_4_3st;

% output mixer:
for i = 1:16
    t = (i-1)*64;
    
    ram_re(1+t : 16+t, 1:4) =  [mult_re(1+t : 16+t, 1), mult_re(1+t : 16+t, 2), mult_re(1+t : 16+t, 3), mult_re(1+t : 16+t, 4)];
    ram_re(17+t : 32+t, 1:4) = [mult_re(17+t : 32+t, 2), mult_re(17+t : 32+t, 3), mult_re(17+t : 32+t, 4), mult_re(17+t : 32+t, 1)];
    ram_re(33+t : 48+t, 1:4) = [mult_re(33+t : 48+t, 3), mult_re(33+t : 48+t, 4), mult_re(33+t : 48+t, 1), mult_re(33+t : 48+t, 2)];
    ram_re(49+t : 64+t, 1:4) = [mult_re(49+t : 64+t, 4), mult_re(49+t : 64+t, 1), mult_re(49+t : 64+t, 2), mult_re(49+t : 64+t, 3)];
    
    ram_im(1+t : 16+t, 1:4) =  [mult_im(1+t : 16+t, 1), mult_im(1+t : 16+t, 2), mult_im(1+t : 16+t, 3), mult_im(1+t : 16+t, 4)];
    ram_im(17+t : 32+t, 1:4) = [mult_im(17+t : 32+t, 2), mult_im(17+t : 32+t, 3), mult_im(17+t : 32+t, 4), mult_im(17+t : 32+t, 1)];
    ram_im(33+t : 48+t, 1:4) = [mult_im(33+t : 48+t, 3), mult_im(33+t : 48+t, 4), mult_im(33+t : 48+t, 1), mult_im(33+t : 48+t, 2)];
    ram_im(49+t : 64+t, 1:4) = [mult_im(49+t : 64+t, 4), mult_im(49+t : 64+t, 1), mult_im(49+t : 64+t, 2), mult_im(49+t : 64+t, 3)];
end

%% ===========================    4 stage    ===============================

ram_a_re_buf(1:1024, 1:4) = zeros;
ram_a_im_buf(1:1024, 1:4) = zeros;

% input mixer + rotate addr:
for i = 1:16
    t = (i-1)*64;
    
    ram_a_re_buf(1+t : 16+t, 1:4) =  [ram_re(1+t : 16+t, 1), ram_re(17+t : 32+t, 4), ram_re(33+t : 48+t, 3), ram_re(49+t : 64+t, 2)];
    ram_a_re_buf(17+t : 32+t, 1:4) = [ram_re(1+t : 16+t, 2), ram_re(17+t : 32+t, 1), ram_re(33+t : 48+t, 4), ram_re(49+t : 64+t, 3)];
    ram_a_re_buf(33+t : 48+t, 1:4) = [ram_re(1+t : 16+t, 3), ram_re(17+t : 32+t, 2), ram_re(33+t : 48+t, 1), ram_re(49+t : 64+t, 4)];
    ram_a_re_buf(49+t : 64+t, 1:4) = [ram_re(1+t : 16+t, 4), ram_re(17+t : 32+t, 3), ram_re(33+t : 48+t, 2), ram_re(49+t : 64+t, 1)];
    
    ram_a_im_buf(1+t : 16+t, 1:4) =  [ram_im(1+t : 16+t, 1), ram_im(17+t : 32+t, 4), ram_im(33+t : 48+t, 3), ram_im(49+t : 64+t, 2)];
    ram_a_im_buf(17+t : 32+t, 1:4) = [ram_im(1+t : 16+t, 2), ram_im(17+t : 32+t, 1), ram_im(33+t : 48+t, 4), ram_im(49+t : 64+t, 3)];
    ram_a_im_buf(33+t : 48+t, 1:4) = [ram_im(1+t : 16+t, 3), ram_im(17+t : 32+t, 2), ram_im(33+t : 48+t, 1), ram_im(49+t : 64+t, 4)];
    ram_a_im_buf(49+t : 64+t, 1:4) = [ram_im(1+t : 16+t, 4), ram_im(17+t : 32+t, 3), ram_im(33+t : 48+t, 2), ram_im(49+t : 64+t, 1)];
end
    
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

    mult_re(1:1024, 2) = (but_re(1:1024, 2).*w_re_2_4st(1:1024) - but_im(1:1024, 2).*w_im_2_4st(1:1024))/1024;
    mult_im(1:1024, 2) = (but_re(1:1024, 2).*w_im_2_4st(1:1024) + but_im(1:1024, 2).*w_re_2_4st(1:1024))/1024;

    mult_re(1:1024, 3) = (but_re(1:1024, 3).*w_re_3_4st(1:1024) - but_im(1:1024, 3).*w_im_3_4st(1:1024))/1024;
    mult_im(1:1024, 3) = (but_re(1:1024, 3).*w_im_3_4st(1:1024) + but_im(1:1024, 3).*w_re_3_4st(1:1024))/1024;

    mult_re(1:1024, 4) = (but_re(1:1024, 4).*w_re_4_4st(1:1024) - but_im(1:1024, 4).*w_im_4_4st(1:1024))/1024;
    mult_im(1:1024, 4) = (but_re(1:1024, 4).*w_im_4_4st(1:1024) + but_im(1:1024, 4).*w_re_4_4st(1:1024))/1024;
    
    clear w_re_2_3st; clear w_re_3_3st; clear w_re_4_3st;

% output mixer:
for i = 1:64
    t = (i-1)*16;
    
    ram_re(1+t : 4+t, 1:4) =   [mult_re(1+t : 4+t, 1),   mult_re(1+t : 4+t, 2),   mult_re(1+t : 4+t, 3),   mult_re(1+t : 4+t, 4)];
    ram_re(5+t : 8+t, 1:4) =   [mult_re(5+t : 8+t, 2),   mult_re(5+t : 8+t, 3),   mult_re(5+t : 8+t, 4),   mult_re(5+t : 8+t, 1)];
    ram_re(9+t : 12+t, 1:4) =  [mult_re(9+t : 12+t, 3),  mult_re(9+t : 12+t, 4),  mult_re(9+t : 12+t, 1),  mult_re(9+t : 12+t, 2)];
    ram_re(13+t : 16+t, 1:4) = [mult_re(13+t : 16+t, 4), mult_re(13+t : 16+t, 1), mult_re(13+t : 16+t, 2), mult_re(13+t : 16+t, 3)];
    
    ram_im(1+t : 4+t, 1:4) =   [mult_im(1+t : 4+t, 1),   mult_im(1+t : 4+t, 2),   mult_im(1+t : 4+t, 3),   mult_im(1+t : 4+t, 4)];
    ram_im(5+t : 8+t, 1:4) =   [mult_im(5+t : 8+t, 2),   mult_im(5+t : 8+t, 3),   mult_im(5+t : 8+t, 4),   mult_im(5+t : 8+t, 1)];
    ram_im(9+t : 12+t, 1:4) =  [mult_im(9+t : 12+t, 3),  mult_im(9+t : 12+t, 4),  mult_im(9+t : 12+t, 1),  mult_im(9+t : 12+t, 2)];
    ram_im(13+t : 16+t, 1:4) = [mult_im(13+t : 16+t, 4), mult_im(13+t : 16+t, 1), mult_im(13+t : 16+t, 2), mult_im(13+t : 16+t, 3)];
end

%% ===========================    5 stage    ===============================

ram_a_re_buf(1:1024, 1:4) = zeros;
ram_a_im_buf(1:1024, 1:4) = zeros;

% input mixer + rotate addr:
for i = 1:64
    t = (i-1)*16;
    
    ram_a_re_buf(1+t : 4+t, 1:4) =   [ram_re(1+t : 4+t, 1), ram_re(5+t : 8+t, 4), ram_re(9+t : 12+t, 3), ram_re(13+t : 16+t, 2)];
    ram_a_re_buf(5+t : 8+t, 1:4) =   [ram_re(1+t : 4+t, 2), ram_re(5+t : 8+t, 1), ram_re(9+t : 12+t, 4), ram_re(13+t : 16+t, 3)];
    ram_a_re_buf(9+t : 12+t, 1:4) =  [ram_re(1+t : 4+t, 3), ram_re(5+t : 8+t, 2), ram_re(9+t : 12+t, 1), ram_re(13+t : 16+t, 4)];
    ram_a_re_buf(13+t : 16+t, 1:4) = [ram_re(1+t : 4+t, 4), ram_re(5+t : 8+t, 3), ram_re(9+t : 12+t, 2), ram_re(13+t : 16+t, 1)];
    
    ram_a_im_buf(1+t : 4+t, 1:4) =   [ram_im(1+t : 4+t, 1), ram_im(5+t : 8+t, 4), ram_im(9+t : 12+t, 3), ram_im(13+t : 16+t, 2)];
    ram_a_im_buf(5+t : 8+t, 1:4) =   [ram_im(1+t : 4+t, 2), ram_im(5+t : 8+t, 1), ram_im(9+t : 12+t, 4), ram_im(13+t : 16+t, 3)];
    ram_a_im_buf(9+t : 12+t, 1:4) =  [ram_im(1+t : 4+t, 3), ram_im(5+t : 8+t, 2), ram_im(9+t : 12+t, 1), ram_im(13+t : 16+t, 4)];
    ram_a_im_buf(13+t : 16+t, 1:4) = [ram_im(1+t : 4+t, 4), ram_im(5+t : 8+t, 3), ram_im(9+t : 12+t, 2), ram_im(13+t : 16+t, 1)];
end
    
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

    mult_re(1:1024, 2) = (but_re(1:1024, 2).*w_re_2_5st(1:1024) - but_im(1:1024, 2).*w_im_2_5st(1:1024))/1024;
    mult_im(1:1024, 2) = (but_re(1:1024, 2).*w_im_2_5st(1:1024) + but_im(1:1024, 2).*w_re_2_5st(1:1024))/1024;

    mult_re(1:1024, 3) = (but_re(1:1024, 3).*w_re_3_5st(1:1024) - but_im(1:1024, 3).*w_im_3_5st(1:1024))/1024;
    mult_im(1:1024, 3) = (but_re(1:1024, 3).*w_im_3_5st(1:1024) + but_im(1:1024, 3).*w_re_3_5st(1:1024))/1024;

    mult_re(1:1024, 4) = (but_re(1:1024, 4).*w_re_4_5st(1:1024) - but_im(1:1024, 4).*w_im_4_5st(1:1024))/1024;
    mult_im(1:1024, 4) = (but_re(1:1024, 4).*w_im_4_5st(1:1024) + but_im(1:1024, 4).*w_re_4_5st(1:1024))/1024;
    
    clear w_re_2_3st; clear w_re_3_3st; clear w_re_4_3st;

% output mixer:
for i = 1:256
    t = (i-1)*4;
    
    ram_re(1+t, 1:4) = [mult_re(1+t, 1), mult_re(1+t, 2), mult_re(1+t, 3), mult_re(1+t, 4)];
    ram_re(2+t, 1:4) = [mult_re(2+t, 2), mult_re(2+t, 3), mult_re(2+t, 4), mult_re(2+t, 1)];
    ram_re(3+t, 1:4) = [mult_re(3+t, 3), mult_re(3+t, 4), mult_re(3+t, 1), mult_re(3+t, 2)];
    ram_re(4+t, 1:4) = [mult_re(4+t, 4), mult_re(4+t, 1), mult_re(4+t, 2), mult_re(4+t, 3)];
    
    ram_im(1+t, 1:4) = [mult_im(1+t, 1), mult_im(1+t, 2), mult_im(1+t, 3), mult_im(1+t, 4)];
    ram_im(2+t, 1:4) = [mult_im(2+t, 2), mult_im(2+t, 3), mult_im(2+t, 4), mult_im(2+t, 1)];
    ram_im(3+t, 1:4) = [mult_im(3+t, 3), mult_im(3+t, 4), mult_im(3+t, 1), mult_im(3+t, 2)];
    ram_im(4+t, 1:4) = [mult_im(4+t, 4), mult_im(4+t, 1), mult_im(4+t, 2), mult_im(4+t, 3)];
end

%% ===========================    6 stage    ===============================

ram_a_re_buf(1:1024, 1:4) = zeros;
ram_a_im_buf(1:1024, 1:4) = zeros;

% input mixer + rotate addr:
for i = 1:256
    t = (i-1)*4;
    
    ram_a_re_buf(1+t, 1:4) = [ram_re(1+t, 1), ram_re(2+t, 4), ram_re(3+t, 3), ram_re(4+t, 2)];
    ram_a_re_buf(2+t, 1:4) = [ram_re(1+t, 2), ram_re(2+t, 1), ram_re(3+t, 4), ram_re(4+t, 3)];
    ram_a_re_buf(3+t, 1:4) = [ram_re(1+t, 3), ram_re(2+t, 2), ram_re(3+t, 1), ram_re(4+t, 4)];
    ram_a_re_buf(4+t, 1:4) = [ram_re(1+t, 4), ram_re(2+t, 3), ram_re(3+t, 2), ram_re(4+t, 1)];
    
    ram_a_im_buf(1+t, 1:4) = [ram_im(1+t, 1), ram_im(2+t, 4), ram_im(3+t, 3), ram_im(4+t, 2)];
    ram_a_im_buf(2+t, 1:4) = [ram_im(1+t, 2), ram_im(2+t, 1), ram_im(3+t, 4), ram_im(4+t, 3)];
    ram_a_im_buf(3+t, 1:4) = [ram_im(1+t, 3), ram_im(2+t, 2), ram_im(3+t, 1), ram_im(4+t, 4)];
    ram_a_im_buf(4+t, 1:4) = [ram_im(1+t, 4), ram_im(2+t, 3), ram_im(3+t, 2), ram_im(4+t, 1)];
end

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

%% output files
if(strcmp(mode, 'work'))
    file_a_re = fopen('D:\work\fft\matlab\ram_a_re.txt', 'w');
    file_a_im = fopen('D:\work\fft\matlab\ram_a_im.txt', 'w');
elseif(strcmp(mode, 'home'))
    file_a_re = fopen('D:\SS\fpga\fft\matlab\ram_a_re.txt', 'w');
    file_a_im = fopen('D:\SS\fpga\fft\matlab\ram_a_im.txt', 'w');
end

for i = 1:1024
    fprintf(file_a_re, '%d\t%d\t%d\t%d\n', but_re(i, 1:4)); 
    fprintf(file_a_im, '%d\t%d\t%d\t%d\n', but_im(i, 1:4)); 
end

fclose(file_a_re);
fclose(file_a_im);