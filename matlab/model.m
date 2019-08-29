clear;
close all;
clc;


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
    but_a_re(1:512, 1) = round((ram_a_re(1:512, 1) + ram_a_re(1:512, 2) + ram_a_re(1:512, 3) + ram_a_re(1:512, 4))/4);
    but_a_re(1:512, 2) = round((ram_a_re(1:512, 1) + ram_a_im(1:512, 2) - ram_a_re(1:512, 3) - ram_a_im(1:512, 4))/4);
    but_a_re(1:512, 3) = round((ram_a_re(1:512, 1) - ram_a_re(1:512, 2) + ram_a_re(1:512, 3) - ram_a_re(1:512, 4))/4);
    but_a_re(1:512, 4) = round((ram_a_re(1:512, 1) - ram_a_im(1:512, 2) - ram_a_re(1:512, 3) + ram_a_im(1:512, 4))/4);

    but_a_im(1:512, 1) = round((ram_a_im(1:512, 1) + ram_a_im(1:512, 2) + ram_a_im(1:512, 3) + ram_a_im(1:512, 4))/4);
    but_a_im(1:512, 2) = round((ram_a_im(1:512, 1) - ram_a_re(1:512, 2) - ram_a_im(1:512, 3) + ram_a_re(1:512, 4))/4);
    but_a_im(1:512, 3) = round((ram_a_im(1:512, 1) - ram_a_im(1:512, 2) + ram_a_im(1:512, 3) - ram_a_im(1:512, 4))/4);
    but_a_im(1:512, 4) = round((ram_a_im(1:512, 1) + ram_a_re(1:512, 2) - ram_a_im(1:512, 3) - ram_a_re(1:512, 4))/4);

% multipiler:
    mult_a_re(1:512, 1) = but_a_re(1:512, 1);
    mult_a_im(1:512, 1) = but_a_im(1:512, 1);

    mult_a_re(1:512, 2) = round((but_a_re(1:512, 2).*w_re_2(1:512) - but_a_im(1:512, 2).*w_im_2(1:512))/1024);
    mult_a_im(1:512, 2) = round((but_a_re(1:512, 2).*w_im_2(1:512) + but_a_im(1:512, 2).*w_re_2(1:512))/1024);

    mult_a_re(1:512, 3) = round((but_a_re(1:512, 3).*w_re_3(1:512) - but_a_im(1:512, 3).*w_im_3(1:512))/1024);
    mult_a_im(1:512, 3) = round((but_a_re(1:512, 3).*w_im_3(1:512) + but_a_im(1:512, 3).*w_re_3(1:512))/1024);

    mult_a_re(1:512, 4) = round((but_a_re(1:512, 4).*w_re_4(1:512) - but_a_im(1:512, 4).*w_im_4(1:512))/1024);
    mult_a_im(1:512, 4) = round((but_a_re(1:512, 4).*w_im_4(1:512) + but_a_im(1:512, 4).*w_re_4(1:512))/1024);

% output mixer:
    % real:
    ram_a_re(1:128, 1) =   mult_a_re(1:128, 1);
    ram_a_re(1:128, 2) =   mult_a_re(1:128, 2);
    ram_a_re(1:128, 3) =   mult_a_re(1:128, 3);
    ram_a_re(1:128, 4) =   mult_a_re(1:128, 4);
    
    ram_a_re(129:256, 1) = mult_a_re(129:256, 2);
    ram_a_re(129:256, 2) = mult_a_re(129:256, 3);
    ram_a_re(129:256, 3) = mult_a_re(129:256, 4);
    ram_a_re(129:256, 4) = mult_a_re(129:256, 1);
    
    ram_a_re(257:384, 1) = mult_a_re(257:384, 3);
    ram_a_re(257:384, 2) = mult_a_re(257:384, 4);
    ram_a_re(257:384, 3) = mult_a_re(257:384, 1);
    ram_a_re(257:384, 4) = mult_a_re(257:384, 2);
    
    ram_a_re(385:512, 1) = mult_a_re(385:512, 4);
    ram_a_re(385:512, 2) = mult_a_re(385:512, 1);
    ram_a_re(385:512, 3) = mult_a_re(385:512, 2);
    ram_a_re(385:512, 4) = mult_a_re(385:512, 3);
    
    % imag:
    ram_a_im(1:128, 1) =   mult_a_im(1:128, 1);
    ram_a_im(1:128, 2) =   mult_a_im(1:128, 2);
    ram_a_im(1:128, 3) =   mult_a_im(1:128, 3);
    ram_a_im(1:128, 4) =   mult_a_im(1:128, 4);
    
    ram_a_im(129:256, 1) = mult_a_im(129:256, 2);
    ram_a_im(129:256, 2) = mult_a_im(129:256, 3);
    ram_a_im(129:256, 3) = mult_a_im(129:256, 4);
    ram_a_im(129:256, 4) = mult_a_im(129:256, 1);
    
    ram_a_im(257:384, 1) = mult_a_im(257:384, 3);
    ram_a_im(257:384, 2) = mult_a_im(257:384, 4);
    ram_a_im(257:384, 3) = mult_a_im(257:384, 1);
    ram_a_im(257:384, 4) = mult_a_im(257:384, 2);
    
    ram_a_im(385:512, 1) = mult_a_im(385:512, 4);
    ram_a_im(385:512, 2) = mult_a_im(385:512, 1);
    ram_a_im(385:512, 3) = mult_a_im(385:512, 2);
    ram_a_im(385:512, 4) = mult_a_im(385:512, 3);    

% ===========================    2 stage    ===============================
% input mixer + rotate addr:
    % real:
    ram_a_re_buf(1:128, 1) =   ram_a_re(1:128, 1);
    ram_a_re_buf(1:128, 2) =   ram_a_re(129:256, 2);
    ram_a_re_buf(1:128, 3) =   ram_a_re(257:384, 3);
    ram_a_re_buf(1:128, 4) =   ram_a_re(385:512, 4);
    
    ram_a_re_buf(129:256, 1) = ram_a_re(257:384, 4);
    ram_a_re_buf(129:256, 2) = ram_a_re(385:512, 1);
    ram_a_re_buf(129:256, 3) = ram_a_re(1:128, 2);
    ram_a_re_buf(129:256, 4) = ram_a_re(129:256, 3);
    
    ram_a_re_buf(257:384, 1) = ram_a_re(1:128, 3);
    ram_a_re_buf(257:384, 2) = ram_a_re(129:256, 4);
    ram_a_re_buf(257:384, 3) = ram_a_re(257:384, 1);
    ram_a_re_buf(257:384, 4) = ram_a_re(385:512, 2);
    
    ram_a_re_buf(385:512, 1) = ram_a_re(257:384, 2);
    ram_a_re_buf(385:512, 2) = ram_a_re(385:512, 3);
    ram_a_re_buf(385:512, 3) = ram_a_re(1:128, 4);
    ram_a_re_buf(385:512, 4) = ram_a_re(129:256, 1);
    
    % imag:
    ram_a_im_buf(1:128, 1) =   ram_a_im(1:128, 1);
    ram_a_im_buf(1:128, 2) =   ram_a_im(129:256, 2);
    ram_a_im_buf(1:128, 3) =   ram_a_im(257:384, 3);
    ram_a_im_buf(1:128, 4) =   ram_a_im(385:512, 4);
    
    ram_a_im_buf(129:256, 1) = ram_a_im(257:384, 4);
    ram_a_im_buf(129:256, 2) = ram_a_im(385:512, 1);
    ram_a_im_buf(129:256, 3) = ram_a_im(1:128, 2);
    ram_a_im_buf(129:256, 4) = ram_a_im(129:256, 3);
    
    ram_a_im_buf(257:384, 1) = ram_a_im(1:128, 3);
    ram_a_im_buf(257:384, 2) = ram_a_im(129:256, 4);
    ram_a_im_buf(257:384, 3) = ram_a_im(257:384, 1);
    ram_a_im_buf(257:384, 4) = ram_a_im(385:512, 2);
    
    ram_a_im_buf(385:512, 1) = ram_a_im(257:384, 2);
    ram_a_im_buf(385:512, 2) = ram_a_im(385:512, 3);
    ram_a_im_buf(385:512, 3) = ram_a_im(1:128, 4);
    ram_a_im_buf(385:512, 4) = ram_a_im(129:256, 1);  
    
ram_a_re = ram_a_re_buf;
ram_a_im = ram_a_im_buf;
clear ram_a_re_buf; clear ram_a_im_buf;
    
% butterfly:
    but_a_re(1:512, 1) = round((ram_a_re(1:512, 1) + ram_a_re(1:512, 2) + ram_a_re(1:512, 3) + ram_a_re(1:512, 4))/4);
    but_a_re(1:512, 2) = round((ram_a_re(1:512, 1) + ram_a_im(1:512, 2) - ram_a_re(1:512, 3) - ram_a_im(1:512, 4))/4);
    but_a_re(1:512, 3) = round((ram_a_re(1:512, 1) - ram_a_re(1:512, 2) + ram_a_re(1:512, 3) - ram_a_re(1:512, 4))/4);
    but_a_re(1:512, 4) = round((ram_a_re(1:512, 1) - ram_a_im(1:512, 2) - ram_a_re(1:512, 3) + ram_a_im(1:512, 4))/4);

    but_a_im(1:512, 1) = round((ram_a_im(1:512, 1) + ram_a_im(1:512, 2) + ram_a_im(1:512, 3) + ram_a_im(1:512, 4))/4);
    but_a_im(1:512, 2) = round((ram_a_im(1:512, 1) - ram_a_re(1:512, 2) - ram_a_im(1:512, 3) + ram_a_re(1:512, 4))/4);
    but_a_im(1:512, 3) = round((ram_a_im(1:512, 1) - ram_a_im(1:512, 2) + ram_a_im(1:512, 3) - ram_a_im(1:512, 4))/4);
    but_a_im(1:512, 4) = round((ram_a_im(1:512, 1) + ram_a_re(1:512, 2) - ram_a_im(1:512, 3) - ram_a_re(1:512, 4))/4);
    
% multipiler:
    mult_a_re(1:512, 1) = but_a_re(1:512, 1);
    mult_a_im(1:512, 1) = but_a_im(1:512, 1);

        w_re_2_buf = w_re_2(1:4:512);
    w_re_2_2st(1:512) = [w_re_2_buf, w_re_2_buf, w_re_2_buf, w_re_2_buf];
        w_re_3_buf = w_re_3(1:4:512);
    w_re_3_2st(1:512) = [w_re_3_buf, w_re_3_buf, w_re_3_buf, w_re_3_buf];
        w_re_4_buf = w_re_4(1:4:512);
    w_re_4_2st(1:512) = [w_re_4_buf, w_re_4_buf, w_re_4_buf, w_re_4_buf];
        clear w_re_2_buf; clear w_re_3_buf; clear w_re_4_buf;
    
    mult_a_re(1:512, 2) = round((but_a_re(1:512, 2).*w_re_2_2st(1:512) - but_a_im(1:512, 2).*w_im_2_2st(1:512))/1024);
    mult_a_im(1:512, 2) = round((but_a_re(1:512, 2).*w_im_2_2st(1:512) + but_a_im(1:512, 2).*w_re_2_2st(1:512))/1024);

    mult_a_re(1:512, 3) = round((but_a_re(1:512, 3).*w_re_3_2st(1:512) - but_a_im(1:512, 3).*w_im_3_2st(1:512))/1024);
    mult_a_im(1:512, 3) = round((but_a_re(1:512, 3).*w_im_3_2st(1:512) + but_a_im(1:512, 3).*w_re_3_2st(1:512))/1024);

    mult_a_re(1:512, 4) = round((but_a_re(1:512, 4).*w_re_4_2st(1:512) - but_a_im(1:512, 4).*w_im_4_2st(1:512))/1024);
    mult_a_im(1:512, 4) = round((but_a_re(1:512, 4).*w_im_4_2st(1:512) + but_a_im(1:512, 4).*w_re_4_2st(1:512))/1024);
    
    %clear w_re_2_2st; clear w_re_3_2st; clear w_re_4_2st;
    
% output mixer:
    % real:
for i = 1:4
    ram_a_re(1+(i-1)*128 : 32+(i-1)*128, 1) =  mult_a_re(1+(i-1)*128 : 32+(i-1)*128, 1);
    ram_a_re(1+(i-1)*128 : 32+(i-1)*128, 2) =  mult_a_re(1+(i-1)*128 : 32+(i-1)*128, 2);
    ram_a_re(1+(i-1)*128 : 32+(i-1)*128, 3) =  mult_a_re(1+(i-1)*128 : 32+(i-1)*128, 3);
    ram_a_re(1+(i-1)*128 : 32+(i-1)*128, 4) =  mult_a_re(1+(i-1)*128 : 32+(i-1)*128, 4);
    
    ram_a_re(33+(i-1)*128 : 64+(i-1)*128, 1) = mult_a_re(33+(i-1)*128 : 64+(i-1)*128, 2);
    ram_a_re(33+(i-1)*128 : 64+(i-1)*128, 2) = mult_a_re(33+(i-1)*128 : 64+(i-1)*128, 3);
    ram_a_re(33+(i-1)*128 : 64+(i-1)*128, 3) = mult_a_re(33+(i-1)*128 : 64+(i-1)*128, 4);
    ram_a_re(33+(i-1)*128 : 64+(i-1)*128, 4) = mult_a_re(33+(i-1)*128 : 64+(i-1)*128, 1);
    
    ram_a_re(65+(i-1)*128 : 96+(i-1)*128, 1) = mult_a_re(65+(i-1)*128 : 96+(i-1)*128, 3);
    ram_a_re(65+(i-1)*128 : 96+(i-1)*128, 2) = mult_a_re(65+(i-1)*128 : 96+(i-1)*128, 4);
    ram_a_re(65+(i-1)*128 : 96+(i-1)*128, 3) = mult_a_re(65+(i-1)*128 : 96+(i-1)*128, 1);
    ram_a_re(65+(i-1)*128 : 96+(i-1)*128, 4) = mult_a_re(65+(i-1)*128 : 96+(i-1)*128, 2);
    
    ram_a_re(97+(i-1)*128 : 128+(i-1)*128, 1) = mult_a_re(97+(i-1)*128 : 128+(i-1)*128, 4);
    ram_a_re(97+(i-1)*128 : 128+(i-1)*128, 2) = mult_a_re(97+(i-1)*128 : 128+(i-1)*128, 1);
    ram_a_re(97+(i-1)*128 : 128+(i-1)*128, 3) = mult_a_re(97+(i-1)*128 : 128+(i-1)*128, 2);
    ram_a_re(97+(i-1)*128 : 128+(i-1)*128, 4) = mult_a_re(97+(i-1)*128 : 128+(i-1)*128, 3);
    
    % imag:
    ram_a_im(1+(i-1)*128 : 32+(i-1)*128, 1) =  mult_a_im(1+(i-1)*128 : 32+(i-1)*128, 1);
    ram_a_im(1+(i-1)*128 : 32+(i-1)*128, 2) =  mult_a_im(1+(i-1)*128 : 32+(i-1)*128, 2);
    ram_a_im(1+(i-1)*128 : 32+(i-1)*128, 3) =  mult_a_im(1+(i-1)*128 : 32+(i-1)*128, 3);
    ram_a_im(1+(i-1)*128 : 32+(i-1)*128, 4) =  mult_a_im(1+(i-1)*128 : 32+(i-1)*128, 4);
    
    ram_a_im(33+(i-1)*128 : 64+(i-1)*128, 1) = mult_a_im(33+(i-1)*128 : 64+(i-1)*128, 2);
    ram_a_im(33+(i-1)*128 : 64+(i-1)*128, 2) = mult_a_im(33+(i-1)*128 : 64+(i-1)*128, 3);
    ram_a_im(33+(i-1)*128 : 64+(i-1)*128, 3) = mult_a_im(33+(i-1)*128 : 64+(i-1)*128, 4);
    ram_a_im(33+(i-1)*128 : 64+(i-1)*128, 4) = mult_a_im(33+(i-1)*128 : 64+(i-1)*128, 1);
    
    ram_a_im(65+(i-1)*128 : 96+(i-1)*128, 1) = mult_a_im(65+(i-1)*128 : 96+(i-1)*128, 3);
    ram_a_im(65+(i-1)*128 : 96+(i-1)*128, 2) = mult_a_im(65+(i-1)*128 : 96+(i-1)*128, 4);
    ram_a_im(65+(i-1)*128 : 96+(i-1)*128, 3) = mult_a_im(65+(i-1)*128 : 96+(i-1)*128, 1);
    ram_a_im(65+(i-1)*128 : 96+(i-1)*128, 4) = mult_a_im(65+(i-1)*128 : 96+(i-1)*128, 2);
    
    ram_a_im(97+(i-1)*128 : 128+(i-1)*128, 1) = mult_a_im(97+(i-1)*128 : 128+(i-1)*128, 4);
    ram_a_im(97+(i-1)*128 : 128+(i-1)*128, 2) = mult_a_im(97+(i-1)*128 : 128+(i-1)*128, 1);
    ram_a_im(97+(i-1)*128 : 128+(i-1)*128, 3) = mult_a_im(97+(i-1)*128 : 128+(i-1)*128, 2);
    ram_a_im(97+(i-1)*128 : 128+(i-1)*128, 4) = mult_a_im(97+(i-1)*128 : 128+(i-1)*128, 3);
end

% ===========================    3 stage    ===============================