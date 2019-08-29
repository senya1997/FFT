clear;
close all;
clc;

% ===============================   coef:   ===============================
w_re_2(1:512) = load('D:\work\fft\matlab\w_re_2.txt');
w_im_2(1:512) = load('D:\work\fft\matlab\w_im_2.txt');

w_re_3(1:512) = load('D:\work\fft\matlab\w_re_3.txt');
w_im_3(1:512) = load('D:\work\fft\matlab\w_im_3.txt');

w_re_4(1:512) = load('D:\work\fft\matlab\w_re_4.txt');
w_im_4(1:512) = load('D:\work\fft\matlab\w_im_4.txt');

%{
w_re_2(1:512) = load('D:\SS\fpga\fft\matlab\w_re_2.txt');
w_im_2(1:512) = load('D:\SS\fpga\fft\matlab\w_im_2.txt');

w_re_3(1:512) = load('D:\SS\fpga\fft\matlab\w_re_3.txt');
w_im_3(1:512) = load('D:\SS\fpga\fft\matlab\w_im_3.txt');

w_re_4(1:512) = load('D:\SS\fpga\fft\matlab\w_re_4.txt');
w_im_4(1:512) = load('D:\SS\fpga\fft\matlab\w_im_4.txt');
%}

w_re_2 = w_re_2'; w_im_2 = w_im_2';
w_re_3 = w_re_3'; w_im_3 = w_im_3';
w_re_4 = w_re_4'; w_im_4 = w_im_4';



    w_re_2_buf = w_re_2(1:4:512);
w_re_2_2st(1:512) = [w_re_2_buf, w_re_2_buf, w_re_2_buf, w_re_2_buf];
    w_re_3_buf = w_re_3(1:4:512);
w_re_3_2st(1:512) = [w_re_3_buf, w_re_3_buf, w_re_3_buf, w_re_3_buf];
    w_re_4_buf = w_re_4(1:4:512);
w_re_4_2st(1:512) = [w_re_4_buf, w_re_4_buf, w_re_4_buf, w_re_4_buf];

    w_im_2_buf = w_im_2(1:4:512);
w_im_2_2st(1:512) = [w_im_2_buf, w_im_2_buf, w_im_2_buf, w_im_2_buf];
    w_im_3_buf = w_im_3(1:4:512);
w_im_3_2st(1:512) = [w_im_3_buf, w_im_3_buf, w_im_3_buf, w_im_3_buf];
    w_im_4_buf = w_im_4(1:4:512);
w_im_4_2st(1:512) = [w_im_4_buf, w_im_4_buf, w_im_4_buf, w_im_4_buf];

w_re_2_2st = w_re_2_2st'; w_im_2_2st = w_im_2_2st';
w_re_3_2st = w_re_3_2st'; w_im_3_2st = w_im_3_2st';
w_re_4_2st = w_re_4_2st'; w_im_4_2st = w_im_4_2st';



    w_re_2_buf = w_re_2_2st(1:4:512);
w_re_2_3st(1:512) = [w_re_2_buf, w_re_2_buf, w_re_2_buf, w_re_2_buf];
    w_re_3_buf = w_re_3_2st(1:4:512);
w_re_3_3st(1:512) = [w_re_3_buf, w_re_3_buf, w_re_3_buf, w_re_3_buf];
    w_re_4_buf = w_re_4_2st(1:4:512);
w_re_4_3st(1:512) = [w_re_4_buf, w_re_4_buf, w_re_4_buf, w_re_4_buf];

    w_im_2_buf = w_im_2_2st(1:4:512);
w_im_2_3st(1:512) = [w_im_2_buf, w_im_2_buf, w_im_2_buf, w_im_2_buf];
    w_im_3_buf = w_im_3_2st(1:4:512);
w_im_3_3st(1:512) = [w_im_3_buf, w_im_3_buf, w_im_3_buf, w_im_3_buf];
    w_im_4_buf = w_im_4_2st(1:4:512);
w_im_4_3st(1:512) = [w_im_4_buf, w_im_4_buf, w_im_4_buf, w_im_4_buf];

w_re_2_3st = w_re_2_3st'; w_im_2_3st = w_im_2_3st';
w_re_3_3st = w_re_3_3st'; w_im_3_3st = w_im_3_3st';
w_re_4_3st = w_re_4_3st'; w_im_4_3st = w_im_4_3st';



    w_re_2_buf = w_re_2_3st(1:4:512);
w_re_2_4st(1:512) = [w_re_2_buf, w_re_2_buf, w_re_2_buf, w_re_2_buf];
    w_re_3_buf = w_re_3_3st(1:4:512);
w_re_3_4st(1:512) = [w_re_3_buf, w_re_3_buf, w_re_3_buf, w_re_3_buf];
    w_re_4_buf = w_re_4_3st(1:4:512);
w_re_4_4st(1:512) = [w_re_4_buf, w_re_4_buf, w_re_4_buf, w_re_4_buf];

    w_im_2_buf = w_im_2_3st(1:4:512);
w_im_2_4st(1:512) = [w_im_2_buf, w_im_2_buf, w_im_2_buf, w_im_2_buf];
    w_im_3_buf = w_im_3_3st(1:4:512);
w_im_3_4st(1:512) = [w_im_3_buf, w_im_3_buf, w_im_3_buf, w_im_3_buf];
    w_im_4_buf = w_im_4_3st(1:4:512);
w_im_4_4st(1:512) = [w_im_4_buf, w_im_4_buf, w_im_4_buf, w_im_4_buf];

w_re_2_4st = w_re_2_4st'; w_im_2_4st = w_im_2_4st';
w_re_3_4st = w_re_3_4st'; w_im_3_4st = w_im_3_4st';
w_re_4_4st = w_re_4_4st'; w_im_4_4st = w_im_4_4st';



    clear w_re_2_buf; clear w_re_3_buf; clear w_re_4_buf;  
    clear w_im_2_buf; clear w_im_3_buf; clear w_im_4_buf;
    
    

% ===============================   start:   ==============================
ram_a_re(1:512, 1:4) = zeros;
ram_a_im(1:512, 1:4) = zeros;

ram_b_re(1:512, 1:4) = zeros;
ram_b_im(1:512, 1:4) = zeros;

time = 0;

for i = 1:4
    for j = 1:512
        %ram_a_re(j, i) = round(32767*(sin(2*3.14*2000*time) + sin(2*3.14*3500*time))/2 - 1);
        %ram_a_re(j, i) = round(20000*sin(2*3.14*100*48.828125*time));
        ram_a_re(j, i) = 100;
        
        time = time + 0.00001;
    end
end

% ===========================    1 stage    ===============================
% butterfly:
    but_re(1:512, 1) = round((ram_a_re(1:512, 1) + ram_a_re(1:512, 2) + ram_a_re(1:512, 3) + ram_a_re(1:512, 4))/4);
    but_re(1:512, 2) = round((ram_a_re(1:512, 1) + ram_a_im(1:512, 2) - ram_a_re(1:512, 3) - ram_a_im(1:512, 4))/4);
    but_re(1:512, 3) = round((ram_a_re(1:512, 1) - ram_a_re(1:512, 2) + ram_a_re(1:512, 3) - ram_a_re(1:512, 4))/4);
    but_re(1:512, 4) = round((ram_a_re(1:512, 1) - ram_a_im(1:512, 2) - ram_a_re(1:512, 3) + ram_a_im(1:512, 4))/4);

    but_im(1:512, 1) = round((ram_a_im(1:512, 1) + ram_a_im(1:512, 2) + ram_a_im(1:512, 3) + ram_a_im(1:512, 4))/4);
    but_im(1:512, 2) = round((ram_a_im(1:512, 1) - ram_a_re(1:512, 2) - ram_a_im(1:512, 3) + ram_a_re(1:512, 4))/4);
    but_im(1:512, 3) = round((ram_a_im(1:512, 1) - ram_a_im(1:512, 2) + ram_a_im(1:512, 3) - ram_a_im(1:512, 4))/4);
    but_im(1:512, 4) = round((ram_a_im(1:512, 1) + ram_a_re(1:512, 2) - ram_a_im(1:512, 3) - ram_a_re(1:512, 4))/4);

% multipiler:
    mult_re(1:512, 1) = but_re(1:512, 1);
    mult_im(1:512, 1) = but_im(1:512, 1);

    mult_re(1:512, 2) = round((but_re(1:512, 2).*w_re_2(1:512) - but_im(1:512, 2).*w_im_2(1:512))/1024);
    mult_im(1:512, 2) = round((but_re(1:512, 2).*w_im_2(1:512) + but_im(1:512, 2).*w_re_2(1:512))/1024);

    mult_re(1:512, 3) = round((but_re(1:512, 3).*w_re_3(1:512) - but_im(1:512, 3).*w_im_3(1:512))/1024);
    mult_im(1:512, 3) = round((but_re(1:512, 3).*w_im_3(1:512) + but_im(1:512, 3).*w_re_3(1:512))/1024);

    mult_re(1:512, 4) = round((but_re(1:512, 4).*w_re_4(1:512) - but_im(1:512, 4).*w_im_4(1:512))/1024);
    mult_im(1:512, 4) = round((but_re(1:512, 4).*w_im_4(1:512) + but_im(1:512, 4).*w_re_4(1:512))/1024);

% output mixer:
    % real:
    ram_a_re(1:128, 1:4) =   [mult_re(1:128,   1), mult_re(1:128,   2), mult_re(1:128,   3), mult_re(1:128,   4)];
    ram_a_re(129:256, 1:4) = [mult_re(129:256, 2), mult_re(129:256, 3), mult_re(129:256, 4), mult_re(129:256, 1)];
    ram_a_re(257:384, 1:4) = [mult_re(257:384, 3), mult_re(257:384, 4), mult_re(257:384, 1), mult_re(257:384, 2)];
    ram_a_re(385:512, 1:4) = [mult_re(385:512, 4), mult_re(385:512, 1), mult_re(385:512, 2), mult_re(385:512, 3)];
    
    % imag:
    ram_a_im(1:128, 1:4) =   [mult_im(1:128,   1), mult_im(1:128,   2), mult_im(1:128,   3), mult_im(1:128,   4)];
    ram_a_im(129:256, 1:4) = [mult_im(129:256, 2), mult_im(129:256, 3), mult_im(129:256, 4), mult_im(129:256, 1)];
    ram_a_im(257:384, 1:4) = [mult_im(257:384, 3), mult_im(257:384, 4), mult_im(257:384, 1), mult_im(257:384, 2)];
    ram_a_im(385:512, 1:4) = [mult_im(385:512, 4), mult_im(385:512, 1), mult_im(385:512, 2), mult_im(385:512, 3)];   

% ===========================    2 stage    ===============================
% input mixer + rotate addr:
    % real:
    ram_a_re_buf(1:128, 1:4) =   [ram_a_re(1:128,   1), ram_a_re(129:256, 2), ram_a_re(257:384, 3), ram_a_re(385:512, 4)];
    ram_a_re_buf(129:256, 1:4) = [ram_a_re(257:384, 4), ram_a_re(385:512, 1), ram_a_re(1:128,   2), ram_a_re(129:256, 3)];
    ram_a_re_buf(257:384, 1:4) = [ram_a_re(1:128,   3), ram_a_re(129:256, 4), ram_a_re(257:384, 1), ram_a_re(385:512, 2)];
    ram_a_re_buf(385:512, 1:4) = [ram_a_re(257:384, 2), ram_a_re(385:512, 3), ram_a_re(1:128,   4), ram_a_re(129:256, 1)];
    
    % imag:
    ram_a_im_buf(1:128, 1:4) =   [ram_a_im(1:128,   1), ram_a_im(129:256, 2), ram_a_im(257:384, 3), ram_a_im(385:512, 4)];
    ram_a_im_buf(129:256, 1:4) = [ram_a_im(257:384, 4), ram_a_im(385:512, 1), ram_a_im(1:128,   2), ram_a_im(129:256, 3)];
    ram_a_im_buf(257:384, 1:4) = [ram_a_im(1:128,   3), ram_a_im(129:256, 4), ram_a_im(257:384, 1), ram_a_im(385:512, 2)];
    ram_a_im_buf(385:512, 1:4) = [ram_a_im(257:384, 2), ram_a_im(385:512, 3), ram_a_im(1:128,   4), ram_a_im(129:256, 1)];
    
ram_a_re = ram_a_re_buf;
ram_a_im = ram_a_im_buf;
clear ram_a_re_buf; clear ram_a_im_buf;
    
% butterfly:
    but_re(1:512, 1) = round((ram_a_re(1:512, 1) + ram_a_re(1:512, 2) + ram_a_re(1:512, 3) + ram_a_re(1:512, 4))/4);
    but_re(1:512, 2) = round((ram_a_re(1:512, 1) + ram_a_im(1:512, 2) - ram_a_re(1:512, 3) - ram_a_im(1:512, 4))/4);
    but_re(1:512, 3) = round((ram_a_re(1:512, 1) - ram_a_re(1:512, 2) + ram_a_re(1:512, 3) - ram_a_re(1:512, 4))/4);
    but_re(1:512, 4) = round((ram_a_re(1:512, 1) - ram_a_im(1:512, 2) - ram_a_re(1:512, 3) + ram_a_im(1:512, 4))/4);

    but_im(1:512, 1) = round((ram_a_im(1:512, 1) + ram_a_im(1:512, 2) + ram_a_im(1:512, 3) + ram_a_im(1:512, 4))/4);
    but_im(1:512, 2) = round((ram_a_im(1:512, 1) - ram_a_re(1:512, 2) - ram_a_im(1:512, 3) + ram_a_re(1:512, 4))/4);
    but_im(1:512, 3) = round((ram_a_im(1:512, 1) - ram_a_im(1:512, 2) + ram_a_im(1:512, 3) - ram_a_im(1:512, 4))/4);
    but_im(1:512, 4) = round((ram_a_im(1:512, 1) + ram_a_re(1:512, 2) - ram_a_im(1:512, 3) - ram_a_re(1:512, 4))/4);
    
% multipiler:
    mult_re(1:512, 1) = but_re(1:512, 1);
    mult_im(1:512, 1) = but_im(1:512, 1);

    mult_re(1:512, 2) = round((but_re(1:512, 2).*w_re_2_2st(1:512) - but_im(1:512, 2).*w_im_2_2st(1:512))/1024);
    mult_im(1:512, 2) = round((but_re(1:512, 2).*w_im_2_2st(1:512) + but_im(1:512, 2).*w_re_2_2st(1:512))/1024);

    mult_re(1:512, 3) = round((but_re(1:512, 3).*w_re_3_2st(1:512) - but_im(1:512, 3).*w_im_3_2st(1:512))/1024);
    mult_im(1:512, 3) = round((but_re(1:512, 3).*w_im_3_2st(1:512) + but_im(1:512, 3).*w_re_3_2st(1:512))/1024);

    mult_re(1:512, 4) = round((but_re(1:512, 4).*w_re_4_2st(1:512) - but_im(1:512, 4).*w_im_4_2st(1:512))/1024);
    mult_im(1:512, 4) = round((but_re(1:512, 4).*w_im_4_2st(1:512) + but_im(1:512, 4).*w_re_4_2st(1:512))/1024);
    
    %clear w_re_2_2st; clear w_re_3_2st; clear w_re_4_2st;
    
% output mixer:
for i = 1:4
    t = (i-1)*128;
    % real:
    ram_a_re(1+t  : 32+t, 1:4) =  [mult_re(1+t  : 32+t,  1), mult_re(1+t  : 32+t,  2), mult_re(1+t  : 32+t,  3), mult_re(1+t  : 32+t,  4)];
    ram_a_re(33+t : 64+t, 1:4) =  [mult_re(33+t : 64+t,  2), mult_re(33+t : 64+t,  3), mult_re(33+t : 64+t,  4), mult_re(33+t : 64+t,  1)];
    ram_a_re(65+t : 96+t, 1:4) =  [mult_re(65+t : 96+t,  3), mult_re(65+t : 96+t,  4), mult_re(65+t : 96+t,  1), mult_re(65+t : 96+t,  2)];
    ram_a_re(97+t : 128+t, 1:4) = [mult_re(97+t : 128+t, 4), mult_re(97+t : 128+t, 1), mult_re(97+t : 128+t, 2), mult_re(97+t : 128+t, 3)];
    
    % imag:
    ram_a_im(1+t  : 32+t, 1:4) =  [mult_im(1+t  : 32+t,  1), mult_im(1+t  : 32+t,  2), mult_im(1+t  : 32+t,  3), mult_im(1+t  : 32+t,  4)];
    ram_a_im(33+t : 64+t, 1:4) =  [mult_im(33+t : 64+t,  2), mult_im(33+t : 64+t,  3), mult_im(33+t : 64+t,  4), mult_im(33+t : 64+t,  1)];
    ram_a_im(65+t : 96+t, 1:4) =  [mult_im(65+t : 96+t,  3), mult_im(65+t : 96+t,  4), mult_im(65+t : 96+t,  1), mult_im(65+t : 96+t,  2)];
    ram_a_im(97+t : 128+t, 1:4) = [mult_im(97+t : 128+t, 4), mult_im(97+t : 128+t, 1), mult_im(97+t : 128+t, 2), mult_im(97+t : 128+t, 3)];
end

% ===========================    3 stage    ===============================
% input mixer + rotate addr:
for i = 1:4
    t = (i-1)*128;
    % real:
    ram_a_re_buf(1+t  : 32+t, 1:4) =  [ram_a_re(1+t  : 32+t, 1), ram_a_re(33+t : 64+t,  2), ram_a_re(65+t : 96+t, 3), ram_a_re(97+t : 128+t, 4)];
    ram_a_re_buf(33+t : 64+t, 1:4) =  [ram_a_re(65+t : 96+t, 4), ram_a_re(97+t : 128+t, 1), ram_a_re(1+t  : 32+t, 2), ram_a_re(33+t : 64+t,  3)];
    ram_a_re_buf(65+t : 96+t, 1:4) =  [ram_a_re(1+t  : 32+t, 3), ram_a_re(33+t : 64+t,  4), ram_a_re(65+t : 96+t, 1), ram_a_re(97+t : 128+t, 2)];
    ram_a_re_buf(97+t : 128+t, 1:4) = [ram_a_re(65+t : 96+t, 2), ram_a_re(97+t : 128+t, 3), ram_a_re(1+t  : 32+t, 4), ram_a_re(33+t : 64+t,  1)];
    
    % imag:
    ram_a_im_buf(1+t  : 32+t, 1:4) =  [ram_a_im(1+t  : 32+t, 1), ram_a_im(33+t : 64+t,  2), ram_a_im(65+t : 96+t, 3), ram_a_im(97+t : 128+t, 4)];
    ram_a_im_buf(33+t : 64+t, 1:4) =  [ram_a_im(65+t : 96+t, 4), ram_a_im(97+t : 128+t, 1), ram_a_im(1+t  : 32+t, 2), ram_a_im(33+t : 64+t,  3)];
    ram_a_im_buf(65+t : 96+t, 1:4) =  [ram_a_im(1+t  : 32+t, 3), ram_a_im(33+t : 64+t,  4), ram_a_im(65+t : 96+t, 1), ram_a_im(97+t : 128+t, 2)];
    ram_a_im_buf(97+t : 128+t, 1:4) = [ram_a_im(65+t : 96+t, 2), ram_a_im(97+t : 128+t, 3), ram_a_im(1+t  : 32+t, 4), ram_a_im(33+t : 64+t,  1)];
end
    
ram_a_re = ram_a_re_buf;
ram_a_im = ram_a_im_buf;
clear ram_a_re_buf; clear ram_a_im_buf;
    
% butterfly:
    but_re(1:512, 1) = round((ram_a_re(1:512, 1) + ram_a_re(1:512, 2) + ram_a_re(1:512, 3) + ram_a_re(1:512, 4))/4);
    but_re(1:512, 2) = round((ram_a_re(1:512, 1) + ram_a_im(1:512, 2) - ram_a_re(1:512, 3) - ram_a_im(1:512, 4))/4);
    but_re(1:512, 3) = round((ram_a_re(1:512, 1) - ram_a_re(1:512, 2) + ram_a_re(1:512, 3) - ram_a_re(1:512, 4))/4);
    but_re(1:512, 4) = round((ram_a_re(1:512, 1) - ram_a_im(1:512, 2) - ram_a_re(1:512, 3) + ram_a_im(1:512, 4))/4);

    but_im(1:512, 1) = round((ram_a_im(1:512, 1) + ram_a_im(1:512, 2) + ram_a_im(1:512, 3) + ram_a_im(1:512, 4))/4);
    but_im(1:512, 2) = round((ram_a_im(1:512, 1) - ram_a_re(1:512, 2) - ram_a_im(1:512, 3) + ram_a_re(1:512, 4))/4);
    but_im(1:512, 3) = round((ram_a_im(1:512, 1) - ram_a_im(1:512, 2) + ram_a_im(1:512, 3) - ram_a_im(1:512, 4))/4);
    but_im(1:512, 4) = round((ram_a_im(1:512, 1) + ram_a_re(1:512, 2) - ram_a_im(1:512, 3) - ram_a_re(1:512, 4))/4);
    
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
    ram_a_re(1+t  : 8+t, 1:4) =  [mult_re(1+t  : 8+t,  1), mult_re(1+t  : 8+t,  2), mult_re(1+t  : 8+t,  3), mult_re(1+t  : 8+t,  4)];
    ram_a_re(9+t  : 16+t, 1:4) = [mult_re(9+t  : 16+t, 2), mult_re(9+t  : 16+t, 3), mult_re(9+t :  16+t, 4), mult_re(9+t  : 16+t, 1)];
    ram_a_re(17+t : 24+t, 1:4) = [mult_re(17+t : 24+t, 3), mult_re(17+t : 24+t, 4), mult_re(17+t : 24+t, 1), mult_re(17+t : 24+t, 2)];
    ram_a_re(25+t : 32+t, 1:4) = [mult_re(25+t : 32+t, 4), mult_re(25+t : 32+t, 1), mult_re(25+t : 32+t, 2), mult_re(25+t : 32+t, 3)];
    
    % imag:
    ram_a_im(1+t  : 8+t, 1:4) =  [mult_im(1+t  : 8+t,  1), mult_im(1+t  : 8+t,  2), mult_im(1+t  : 8+t,  3), mult_im(1+t  : 8+t,  4)];
    ram_a_im(9+t  : 16+t, 1:4) = [mult_im(9+t  : 16+t, 2), mult_im(9+t  : 16+t, 3), mult_im(9+t :  16+t, 4), mult_im(9+t  : 16+t, 1)];
    ram_a_im(17+t : 24+t, 1:4) = [mult_im(17+t : 24+t, 3), mult_im(17+t : 24+t, 4), mult_im(17+t : 24+t, 1), mult_im(17+t : 24+t, 2)];
    ram_a_im(25+t : 32+t, 1:4) = [mult_im(25+t : 32+t, 4), mult_im(25+t : 32+t, 1), mult_im(25+t : 32+t, 2), mult_im(25+t : 32+t, 3)];
end

% ===========================    4 stage    ===============================
% input mixer + rotate addr:
for i = 1:16
    t = (i-1)*32;
    % real:
    ram_a_re_buf(1+t  : 8+t,  1:4) =  [ram_a_re(1+t  : 8+t,  1), ram_a_re(9+t  : 16+t, 2), ram_a_re(17+t : 24+t, 3), ram_a_re(25+t : 32+t, 4)];
    ram_a_re_buf(9+t  : 16+t, 1:4) =  [ram_a_re(17+t : 24+t, 4), ram_a_re(25+t : 32+t, 1), ram_a_re(1+t  : 8+t,  2), ram_a_re(9+t  : 16+t, 3)];
    ram_a_re_buf(17+t : 24+t, 1:4) =  [ram_a_re(1+t  : 8+t,  3), ram_a_re(9+t  : 16+t, 4), ram_a_re(17+t : 24+t, 1), ram_a_re(25+t : 32+t, 2)];
    ram_a_re_buf(25+t : 32+t, 1:4) =  [ram_a_re(17+t : 24+t, 2), ram_a_re(25+t : 32+t, 3), ram_a_re(1+t  : 8+t,  4), ram_a_re(9+t  : 16+t, 1)];
    
    % imag:
    ram_a_im_buf(1+t  : 8+t,  1:4) =  [ram_a_im(1+t  : 8+t,  1), ram_a_im(9+t  : 16+t, 2), ram_a_im(17+t : 24+t, 3), ram_a_im(25+t : 32+t, 4)];
    ram_a_im_buf(9+t  : 16+t, 1:4) =  [ram_a_im(17+t : 24+t, 4), ram_a_im(25+t : 32+t, 1), ram_a_im(1+t  : 8+t,  2), ram_a_im(9+t  : 16+t, 3)];
    ram_a_im_buf(17+t : 24+t, 1:4) =  [ram_a_im(1+t  : 8+t,  3), ram_a_im(9+t  : 16+t, 4), ram_a_im(17+t : 24+t, 1), ram_a_im(25+t : 32+t, 2)];
    ram_a_im_buf(25+t : 32+t, 1:4) =  [ram_a_im(17+t : 24+t, 2), ram_a_im(25+t : 32+t, 3), ram_a_im(1+t  : 8+t,  4), ram_a_im(9+t  : 16+t, 1)];
end
    
ram_a_re = ram_a_re_buf;
ram_a_im = ram_a_im_buf;
clear ram_a_re_buf; clear ram_a_im_buf;
    
% butterfly:
    but_re(1:512, 1) = round((ram_a_re(1:512, 1) + ram_a_re(1:512, 2) + ram_a_re(1:512, 3) + ram_a_re(1:512, 4))/4);
    but_re(1:512, 2) = round((ram_a_re(1:512, 1) + ram_a_im(1:512, 2) - ram_a_re(1:512, 3) - ram_a_im(1:512, 4))/4);
    but_re(1:512, 3) = round((ram_a_re(1:512, 1) - ram_a_re(1:512, 2) + ram_a_re(1:512, 3) - ram_a_re(1:512, 4))/4);
    but_re(1:512, 4) = round((ram_a_re(1:512, 1) - ram_a_im(1:512, 2) - ram_a_re(1:512, 3) + ram_a_im(1:512, 4))/4);

    but_im(1:512, 1) = round((ram_a_im(1:512, 1) + ram_a_im(1:512, 2) + ram_a_im(1:512, 3) + ram_a_im(1:512, 4))/4);
    but_im(1:512, 2) = round((ram_a_im(1:512, 1) - ram_a_re(1:512, 2) - ram_a_im(1:512, 3) + ram_a_re(1:512, 4))/4);
    but_im(1:512, 3) = round((ram_a_im(1:512, 1) - ram_a_im(1:512, 2) + ram_a_im(1:512, 3) - ram_a_im(1:512, 4))/4);
    but_im(1:512, 4) = round((ram_a_im(1:512, 1) + ram_a_re(1:512, 2) - ram_a_im(1:512, 3) - ram_a_re(1:512, 4))/4);
    
% multipiler:
    mult_re(1:512, 1) = but_re(1:512, 1);
    mult_im(1:512, 1) = but_im(1:512, 1);

    mult_re(1:512, 2) = round((but_re(1:512, 2).*w_re_2_4st(1:512) - but_im(1:512, 2).*w_im_2_4st(1:512))/1024);
    mult_im(1:512, 2) = round((but_re(1:512, 2).*w_im_2_4st(1:512) + but_im(1:512, 2).*w_re_2_4st(1:512))/1024);

    mult_re(1:512, 3) = round((but_re(1:512, 3).*w_re_3_4st(1:512) - but_im(1:512, 3).*w_im_3_4st(1:512))/1024);
    mult_im(1:512, 3) = round((but_re(1:512, 3).*w_im_3_4st(1:512) + but_im(1:512, 3).*w_re_3_4st(1:512))/1024);

    mult_re(1:512, 4) = round((but_re(1:512, 4).*w_re_4_4st(1:512) - but_im(1:512, 4).*w_im_4_4st(1:512))/1024);
    mult_im(1:512, 4) = round((but_re(1:512, 4).*w_im_4_4st(1:512) + but_im(1:512, 4).*w_re_4_4st(1:512))/1024);
    
    %clear w_re_2_4st; clear w_re_3_4st; clear w_re_4_4st;
    
% output mixer:
for i = 1:64
    t = (i-1)*8;
    % real:
    ram_a_re(1+t : 2+t, 1:4) = [mult_re(1+t : 2+t, 1), mult_re(1+t : 2+t, 2), mult_re(1+t : 2+t, 3), mult_re(1+t : 2+t, 4)];
    ram_a_re(3+t : 4+t, 1:4) = [mult_re(3+t : 4+t, 2), mult_re(3+t : 4+t, 3), mult_re(3+t : 4+t, 4), mult_re(3+t : 4+t, 1)];
    ram_a_re(5+t : 6+t, 1:4) = [mult_re(5+t : 6+t, 3), mult_re(5+t : 6+t, 4), mult_re(5+t : 6+t, 1), mult_re(5+t : 6+t, 2)];
    ram_a_re(7+t : 8+t, 1:4) = [mult_re(7+t : 8+t, 4), mult_re(7+t : 8+t, 1), mult_re(7+t : 8+t, 2), mult_re(7+t : 8+t, 3)];
    
    % imag:
    ram_a_im(1+t : 2+t, 1:4) = [mult_im(1+t : 2+t, 1), mult_im(1+t : 2+t, 2), mult_im(1+t : 2+t, 3), mult_im(1+t : 2+t, 4)];
    ram_a_im(3+t : 4+t, 1:4) = [mult_im(3+t : 4+t, 2), mult_im(3+t : 4+t, 3), mult_im(3+t : 4+t, 4), mult_im(3+t : 4+t, 1)];
    ram_a_im(5+t : 6+t, 1:4) = [mult_im(5+t : 6+t, 3), mult_im(5+t : 6+t, 4), mult_im(5+t : 6+t, 1), mult_im(5+t : 6+t, 2)];
    ram_a_im(7+t : 8+t, 1:4) = [mult_im(7+t : 8+t, 4), mult_im(7+t : 8+t, 1), mult_im(7+t : 8+t, 2), mult_im(7+t : 8+t, 3)];
end