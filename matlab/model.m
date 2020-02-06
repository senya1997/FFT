clear;
close all;
clc;

%mode = 'home';
mode = 'work';

%% ===============================   coef:   ===============================

if(strcmp(mode, 'work'))
    w_re_2(1:16) = load('D:\work\fft\matlab\w_re_2.txt');
    w_im_2(1:16) = load('D:\work\fft\matlab\w_im_2.txt');

    w_re_3(1:16) = load('D:\work\fft\matlab\w_re_3.txt');
    w_im_3(1:16) = load('D:\work\fft\matlab\w_im_3.txt');

    w_re_4(1:16) = load('D:\work\fft\matlab\w_re_4.txt');
    w_im_4(1:16) = load('D:\work\fft\matlab\w_im_4.txt');
elseif(strcmp(mode, 'home'))
    w_re_2(1:16) = load('D:\SS\fpga\fft\matlab\w_re_2.txt');
    w_im_2(1:16) = load('D:\SS\fpga\fft\matlab\w_im_2.txt');

    w_re_3(1:16) = load('D:\SS\fpga\fft\matlab\w_re_3.txt');
    w_im_3(1:16) = load('D:\SS\fpga\fft\matlab\w_im_3.txt');

    w_re_4(1:16) = load('D:\SS\fpga\fft\matlab\w_re_4.txt');
    w_im_4(1:16) = load('D:\SS\fpga\fft\matlab\w_im_4.txt');
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
ram_re(1:16, 1:4) = zeros;
ram_im(1:16, 1:4) = zeros;

N = 64;
Fd = 44100;

A1 = 10000; % Амплитуда первой синусоиды
A2 = 0; % Амплитуда второй синусоиды
Ak = A1; % Постоянная составляющая

F1 = 1300;  % Частота первой синусоиды (Гц)
F2 = 4200;  % Частота второй синусоиды (Гц)

Phi1 = 0;     % Начальная фаза первой синусоиды (Градусов)
Phi2 = 37;    % Начальная фаза второй синусоиды (Градусов)

T = 0 : 1/Fd : (N - 1)/Fd; % Массив отсчетов времени

Signal = Ak + A1*sind((F1*360).* T + Phi1) + A2*sind((F2*360).* T + Phi2);

for i = 1:4 
    for j = 1:16
        ind = j + 16*(i-1);
        %ram_re(j, i) = round(Signal(ind));
        ram_re(j, i) = (j - 1) + 16*(i - 1); % 0..63
    end
end

Signal = Signal';
figure;
plot(T, Signal);
grid on;

%% ===========================    1 stage    ===============================
% butterfly:
    but_re(1:16, 1) = (ram_re(1:16, 1) + ram_re(1:16, 2) + ram_re(1:16, 3) + ram_re(1:16, 4))/4;
    but_re(1:16, 2) = (ram_re(1:16, 1) + ram_im(1:16, 2) - ram_re(1:16, 3) - ram_im(1:16, 4))/4;
    but_re(1:16, 3) = (ram_re(1:16, 1) - ram_re(1:16, 2) + ram_re(1:16, 3) - ram_re(1:16, 4))/4;
    but_re(1:16, 4) = (ram_re(1:16, 1) - ram_im(1:16, 2) - ram_re(1:16, 3) + ram_im(1:16, 4))/4;

    but_im(1:16, 1) = (ram_im(1:16, 1) + ram_im(1:16, 2) + ram_im(1:16, 3) + ram_im(1:16, 4))/4;
    but_im(1:16, 2) = (ram_im(1:16, 1) - ram_re(1:16, 2) - ram_im(1:16, 3) + ram_re(1:16, 4))/4;
    but_im(1:16, 3) = (ram_im(1:16, 1) - ram_im(1:16, 2) + ram_im(1:16, 3) - ram_im(1:16, 4))/4;
    but_im(1:16, 4) = (ram_im(1:16, 1) + ram_re(1:16, 2) - ram_im(1:16, 3) - ram_re(1:16, 4))/4;

% multipiler:
    mult_re(1:16, 1) = but_re(1:16, 1);
    mult_im(1:16, 1) = but_im(1:16, 1);

    mult_re(1:16, 2) = (but_re(1:16, 2).*w_re_2(1:16) - but_im(1:16, 2).*w_im_2(1:16))/1024;
    mult_im(1:16, 2) = (but_re(1:16, 2).*w_im_2(1:16) + but_im(1:16, 2).*w_re_2(1:16))/1024;

    mult_re(1:16, 3) = (but_re(1:16, 3).*w_re_3(1:16) - but_im(1:16, 3).*w_im_3(1:16))/1024;
    mult_im(1:16, 3) = (but_re(1:16, 3).*w_im_3(1:16) + but_im(1:16, 3).*w_re_3(1:16))/1024;

    mult_re(1:16, 4) = (but_re(1:16, 4).*w_re_4(1:16) - but_im(1:16, 4).*w_im_4(1:16))/1024;
    mult_im(1:16, 4) = (but_re(1:16, 4).*w_im_4(1:16) + but_im(1:16, 4).*w_re_4(1:16))/1024;

% output mixer:
    % real:
    ram_re(1:4, 1:4) =      [mult_re(1:4,   1), mult_re(1:4,   2), mult_re(1:4,   3), mult_re(1:4,   4)];
    ram_re(5:8, 1:4) =      [mult_re(5:8,   2), mult_re(5:8,   3), mult_re(5:8,   4), mult_re(5:8,   1)];
    ram_re(9:12, 1:4) =     [mult_re(9:12,  3), mult_re(9:12,  4), mult_re(9:12,  1), mult_re(9:12,  2)];
    ram_re(13:16, 1:4) =	[mult_re(13:16, 4), mult_re(13:16, 1), mult_re(13:16, 2), mult_re(13:16, 3)];
    
    % imag:
    ram_im(1:4, 1:4) =      [mult_im(1:4,   1), mult_im(1:4,   2), mult_im(1:4,   3), mult_im(1:4,   4)];
    ram_im(5:8, 1:4) =      [mult_im(5:8,   2), mult_im(5:8,   3), mult_im(5:8,   4), mult_im(5:8,   1)];
    ram_im(9:12, 1:4) =     [mult_im(9:12,  3), mult_im(9:12,  4), mult_im(9:12,  1), mult_im(9:12,  2)];
    ram_im(13:16, 1:4) =	[mult_im(13:16, 4), mult_im(13:16, 1), mult_im(13:16, 2), mult_im(13:16, 3)];   

%% ===========================    2 stage    ===============================
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
    
% multipiler:
    mult_re(1:16, 1) = but_re(1:16, 1);
    mult_im(1:16, 1) = but_im(1:16, 1);

    mult_re(1:16, 2) = (but_re(1:16, 2).*w_re_2(1:16) - but_im(1:16, 2).*w_im_2_2st(1:16))/1024;
    mult_im(1:16, 2) = (but_re(1:16, 2).*w_im_2(1:16) + but_im(1:16, 2).*w_re_2_2st(1:16))/1024;

    mult_re(1:16, 3) = (but_re(1:16, 3).*w_re_3(1:16) - but_im(1:16, 3).*w_im_3_2st(1:16))/1024;
    mult_im(1:16, 3) = (but_re(1:16, 3).*w_im_3(1:16) + but_im(1:16, 3).*w_re_3_2st(1:16))/1024;

    mult_re(1:16, 4) = (but_re(1:16, 4).*w_re_4(1:16) - but_im(1:16, 4).*w_im_4_2st(1:16))/1024;
    mult_im(1:16, 4) = (but_re(1:16, 4).*w_im_4(1:16) + but_im(1:16, 4).*w_re_4_2st(1:16))/1024;
    
    %clear w_re_2_2st; clear w_re_3_2st; clear w_re_4_2st;
    
% output mixer:
for i = 1:4
    t = (i-1)*4;
    % real:
    ram_re(1+t  : 32+t, 1:4) =  [mult_re(1+t  : 32+t,  1), mult_re(1+t  : 32+t,  2), mult_re(1+t  : 32+t,  3), mult_re(1+t  : 32+t,  4)];
    ram_re(33+t : 64+t, 1:4) =  [mult_re(33+t : 64+t,  2), mult_re(33+t : 64+t,  3), mult_re(33+t : 64+t,  4), mult_re(33+t : 64+t,  1)];
    ram_re(65+t : 96+t, 1:4) =  [mult_re(65+t : 96+t,  3), mult_re(65+t : 96+t,  4), mult_re(65+t : 96+t,  1), mult_re(65+t : 96+t,  2)];
    ram_re(97+t : 128+t, 1:4) = [mult_re(97+t : 128+t, 4), mult_re(97+t : 128+t, 1), mult_re(97+t : 128+t, 2), mult_re(97+t : 128+t, 3)];
    
    % imag:
    ram_im(1+t  : 32+t, 1:4) =  [mult_im(1+t  : 32+t,  1), mult_im(1+t  : 32+t,  2), mult_im(1+t  : 32+t,  3), mult_im(1+t  : 32+t,  4)];
    ram_im(33+t : 64+t, 1:4) =  [mult_im(33+t : 64+t,  2), mult_im(33+t : 64+t,  3), mult_im(33+t : 64+t,  4), mult_im(33+t : 64+t,  1)];
    ram_im(65+t : 96+t, 1:4) =  [mult_im(65+t : 96+t,  3), mult_im(65+t : 96+t,  4), mult_im(65+t : 96+t,  1), mult_im(65+t : 96+t,  2)];
    ram_im(97+t : 128+t, 1:4) = [mult_im(97+t : 128+t, 4), mult_im(97+t : 128+t, 1), mult_im(97+t : 128+t, 2), mult_im(97+t : 128+t, 3)];
end

%% ===========================    3 stage    ===============================
% input mixer + rotate addr:
for i = 1:4
    t = (i-1)*128;
    % real:
    ram_a_re_buf(1+t  : 32+t, 1:4) =  [ram_re(1+t  : 32+t, 1), ram_re(33+t : 64+t,  2), ram_re(65+t : 96+t, 3), ram_re(97+t : 128+t, 4)];
    ram_a_re_buf(33+t : 64+t, 1:4) =  [ram_re(65+t : 96+t, 4), ram_re(97+t : 128+t, 1), ram_re(1+t  : 32+t, 2), ram_re(33+t : 64+t,  3)];
    ram_a_re_buf(65+t : 96+t, 1:4) =  [ram_re(1+t  : 32+t, 3), ram_re(33+t : 64+t,  4), ram_re(65+t : 96+t, 1), ram_re(97+t : 128+t, 2)];
    ram_a_re_buf(97+t : 128+t, 1:4) = [ram_re(65+t : 96+t, 2), ram_re(97+t : 128+t, 3), ram_re(1+t  : 32+t, 4), ram_re(33+t : 64+t,  1)];
    
    % imag:
    ram_a_im_buf(1+t  : 32+t, 1:4) =  [ram_im(1+t  : 32+t, 1), ram_im(33+t : 64+t,  2), ram_im(65+t : 96+t, 3), ram_im(97+t : 128+t, 4)];
    ram_a_im_buf(33+t : 64+t, 1:4) =  [ram_im(65+t : 96+t, 4), ram_im(97+t : 128+t, 1), ram_im(1+t  : 32+t, 2), ram_im(33+t : 64+t,  3)];
    ram_a_im_buf(65+t : 96+t, 1:4) =  [ram_im(1+t  : 32+t, 3), ram_im(33+t : 64+t,  4), ram_im(65+t : 96+t, 1), ram_im(97+t : 128+t, 2)];
    ram_a_im_buf(97+t : 128+t, 1:4) = [ram_im(65+t : 96+t, 2), ram_im(97+t : 128+t, 3), ram_im(1+t  : 32+t, 4), ram_im(33+t : 64+t,  1)];
end
    
ram_re = ram_a_re_buf;
ram_im = ram_a_im_buf;
clear ram_a_re_buf; clear ram_a_im_buf;
    
% butterfly:
    but_re(1:512, 1) = round((ram_re(1:512, 1) + ram_re(1:512, 2) + ram_re(1:512, 3) + ram_re(1:512, 4))/4);
    but_re(1:512, 2) = round((ram_re(1:512, 1) + ram_im(1:512, 2) - ram_re(1:512, 3) - ram_im(1:512, 4))/4);
    but_re(1:512, 3) = round((ram_re(1:512, 1) - ram_re(1:512, 2) + ram_re(1:512, 3) - ram_re(1:512, 4))/4);
    but_re(1:512, 4) = round((ram_re(1:512, 1) - ram_im(1:512, 2) - ram_re(1:512, 3) + ram_im(1:512, 4))/4);

    but_im(1:512, 1) = round((ram_im(1:512, 1) + ram_im(1:512, 2) + ram_im(1:512, 3) + ram_im(1:512, 4))/4);
    but_im(1:512, 2) = round((ram_im(1:512, 1) - ram_re(1:512, 2) - ram_im(1:512, 3) + ram_re(1:512, 4))/4);
    but_im(1:512, 3) = round((ram_im(1:512, 1) - ram_im(1:512, 2) + ram_im(1:512, 3) - ram_im(1:512, 4))/4);
    but_im(1:512, 4) = round((ram_im(1:512, 1) + ram_re(1:512, 2) - ram_im(1:512, 3) - ram_re(1:512, 4))/4);
    
% multipiler:
    mult_re(1:512, 1) = but_re(1:512, 1);
    mult_im(1:512, 1) = but_im(1:512, 1);

    mult_re(1:512, 2) = round((but_re(1:512, 2).*w_re_2_3st(1:512) - but_im(1:512, 2).*w_im_2_3st(1:512))/1024);
    mult_im(1:512, 2) = round((but_re(1:512, 2).*w_im_2_3st(1:512) + but_im(1:512, 2).*w_re_2_3st(1:512))/1024);

    mult_re(1:512, 3) = round((but_re(1:512, 3).*w_re_3_3st(1:512) - but_im(1:512, 3).*w_im_3_3st(1:512))/1024);
    mult_im(1:512, 3) = round((but_re(1:512, 3).*w_im_3_3st(1:512) + but_im(1:512, 3).*w_re_3_3st(1:512))/1024);

    mult_re(1:512, 4) = round((but_re(1:512, 4).*w_re_4_3st(1:512) - but_im(1:512, 4).*w_im_4_3st(1:512))/1024);
    mult_im(1:512, 4) = round((but_re(1:512, 4).*w_im_4_3st(1:512) + but_im(1:512, 4).*w_re_4_3st(1:512))/1024);
    
    %clear w_re_2_3st; clear w_re_3_3st; clear w_re_4_3st;
    
% output mixer:
for i = 1:16
    t = (i-1)*32;
    % real:
    ram_re(1+t  : 8+t, 1:4) =  [mult_re(1+t  : 8+t,  1), mult_re(1+t  : 8+t,  2), mult_re(1+t  : 8+t,  3), mult_re(1+t  : 8+t,  4)];
    ram_re(9+t  : 16+t, 1:4) = [mult_re(9+t  : 16+t, 2), mult_re(9+t  : 16+t, 3), mult_re(9+t :  16+t, 4), mult_re(9+t  : 16+t, 1)];
    ram_re(17+t : 24+t, 1:4) = [mult_re(17+t : 24+t, 3), mult_re(17+t : 24+t, 4), mult_re(17+t : 24+t, 1), mult_re(17+t : 24+t, 2)];
    ram_re(25+t : 32+t, 1:4) = [mult_re(25+t : 32+t, 4), mult_re(25+t : 32+t, 1), mult_re(25+t : 32+t, 2), mult_re(25+t : 32+t, 3)];
    
    % imag:
    ram_im(1+t  : 8+t, 1:4) =  [mult_im(1+t  : 8+t,  1), mult_im(1+t  : 8+t,  2), mult_im(1+t  : 8+t,  3), mult_im(1+t  : 8+t,  4)];
    ram_im(9+t  : 16+t, 1:4) = [mult_im(9+t  : 16+t, 2), mult_im(9+t  : 16+t, 3), mult_im(9+t :  16+t, 4), mult_im(9+t  : 16+t, 1)];
    ram_im(17+t : 24+t, 1:4) = [mult_im(17+t : 24+t, 3), mult_im(17+t : 24+t, 4), mult_im(17+t : 24+t, 1), mult_im(17+t : 24+t, 2)];
    ram_im(25+t : 32+t, 1:4) = [mult_im(25+t : 32+t, 4), mult_im(25+t : 32+t, 1), mult_im(25+t : 32+t, 2), mult_im(25+t : 32+t, 3)];
end

%% output files
if(strcmp(mode, 'work'))
    file_a_re = fopen('D:\work\fft\matlab\ram_a_re.txt', 'w');
    file_a_im = fopen('D:\work\fft\matlab\ram_a_im.txt', 'w');
elseif(strcmp(mode, 'home'))
    file_a_re = fopen('D:\SS\fpga\fft\matlab\ram_a_re.txt', 'w');
    file_a_im = fopen('D:\SS\fpga\fft\matlab\ram_a_im.txt', 'w');
end

for i = 1:16
    fprintf(file_a_re, '%d\t%d\t%d\t%d\n', ram_re(i, 1:4)); 
    fprintf(file_a_im, '%d\t%d\t%d\t%d\n', ram_im(i, 1:4)); 
end

fclose(file_a_re);
fclose(file_a_im);