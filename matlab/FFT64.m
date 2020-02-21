clear;
%close all;
clc;

N = 64;
Fd = 44100;

%mode = 'home';
mode = 'work';

test = 'sin';
%test = 'const';
%test = 'num';

%% ===============================   coef:   ===============================

if(strcmp(mode, 'work'))
    temp_re(1:3970) = load('D:\work\fft\matlab\w_re64.txt');
    temp_im(1:3970) = load('D:\work\fft\matlab\w_im64.txt');
elseif(strcmp(mode, 'home'))
    temp_re(1:3970) = load('D:\SS\fpga\fft\matlab\w_re64.txt');
    temp_im(1:3970) = load('D:\SS\fpga\fft\matlab\w_im64.txt');
else
    error('"mode" is wrong');
end

w_re(1:N) = temp_re(1:N);
w_im(1:N) = temp_im(1:N);

w_re = w_re'; 
w_im = w_im';

clear temp_re; clear temp_im;

w_re_2st(1:16) = w_re(1:4:64);
w_im_2st(1:16) = w_im(1:4:64);

    w_re2_2st(1:16) = [w_re_2st(1:4), w_re_2st(1:4), w_re_2st(1:4), w_re_2st(1:4)];
    w_im2_2st(1:16) = [w_im_2st(1:4), w_im_2st(1:4), w_im_2st(1:4), w_im_2st(1:4)];

    w_re2_2st = w_re2_2st';
    w_im2_2st = w_im2_2st';

    w_re3_2st(1:16) = [w_re_2st(1:2:7), w_re_2st(1:2:7), w_re_2st(1:2:7), w_re_2st(1:2:7)];
    w_im3_2st(1:16) = [w_im_2st(1:2:7), w_im_2st(1:2:7), w_im_2st(1:2:7), w_im_2st(1:2:7)];

    w_re3_2st = w_re3_2st';
    w_im3_2st = w_im3_2st';

    w_re4_2st(1:16) = [w_re_2st(1:3:10), w_re_2st(1:3:10), w_re_2st(1:3:10), w_re_2st(1:3:10)];
    w_im4_2st(1:16) = [w_im_2st(1:3:10), w_im_2st(1:3:10), w_im_2st(1:3:10), w_im_2st(1:3:10)];

    w_re4_2st = w_re4_2st';
    w_im4_2st = w_im4_2st';
  
%{
w_re_3st(1:4) = w_re(1:16:64);
w_im_3st(1:4) = w_im(1:16:64);

    w_re2_3st(1:16) = [w_re_3st(1:2), w_re_3st(1:2), w_re_3st(1:2), w_re_3st(1:2), w_re_3st(1:2), w_re_3st(1:2), w_re_3st(1:2), w_re_3st(1:2)];
    w_im2_3st(1:16) = [w_im_3st(1:2), w_im_3st(1:2), w_im_3st(1:2), w_im_3st(1:2), w_im_3st(1:2), w_im_3st(1:2), w_im_3st(1:2), w_im_3st(1:2)];

    w_re2_3st = w_re2_3st';
    w_im2_3st = w_im2_3st';

    w_re3_3st(1:16) = [w_re_3st(1:2:3), w_re_3st(1:2:3), w_re_3st(1:2:3), w_re_3st(1:2:3), w_re_3st(1:2:3), w_re_3st(1:2:3), w_re_3st(1:2:3), w_re_3st(1:2:3)];
    w_im3_3st(1:16) = [w_im_3st(1:2:3), w_im_3st(1:2:3), w_im_3st(1:2:3), w_im_3st(1:2:3), w_im_3st(1:2:3), w_im_3st(1:2:3), w_im_3st(1:2:3), w_im_3st(1:2:3)];

    w_re3_3st = w_re3_3st';
    w_im3_3st = w_im3_3st';

    w_re4_3st(1:16) = [w_re_3st(1:3:4), w_re_3st(1:3:4), w_re_3st(1:3:4), w_re_3st(1:3:4), w_re_3st(1:3:4), w_re_3st(1:3:4), w_re_3st(1:3:4), w_re_3st(1:3:4)];
    w_im4_3st(1:16) = [w_im_3st(1:3:4), w_im_3st(1:3:4), w_im_3st(1:3:4), w_im_3st(1:3:4), w_im_3st(1:3:4), w_im_3st(1:3:4), w_im_3st(1:3:4), w_im_3st(1:3:4)];

    w_re4_3st = w_re4_3st';
    w_im4_3st = w_im4_3st';
%}
    
%% =============================   fill RAM:   ============================
ram_re(1:16, 1:4) = zeros;
ram_im(1:16, 1:4) = zeros;

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
    for j = 1:16
        k = k + 1;
        
        if(strcmp(test, 'sin'))
            ram_re(j, i) = round(signal(k));
        elseif(strcmp(test, 'const'))
            ram_re(j, i) = 100;
        elseif(strcmp(test, 'num'))
            ram_re(j, i) = k - 1; % 0..63
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
    but_re(1:16, 1) = (ram_re(1:16, 1) + ram_re(1:16, 2) + ram_re(1:16, 3) + ram_re(1:16, 4))/4;
    but_re(1:16, 2) = (ram_re(1:16, 1) + ram_im(1:16, 2) - ram_re(1:16, 3) - ram_im(1:16, 4))/4;
    but_re(1:16, 3) = (ram_re(1:16, 1) - ram_re(1:16, 2) + ram_re(1:16, 3) - ram_re(1:16, 4))/4;
    but_re(1:16, 4) = (ram_re(1:16, 1) - ram_im(1:16, 2) - ram_re(1:16, 3) + ram_im(1:16, 4))/4;

    but_im(1:16, 1) = (ram_im(1:16, 1) + ram_im(1:16, 2) + ram_im(1:16, 3) + ram_im(1:16, 4))/4;
    but_im(1:16, 2) = (ram_im(1:16, 1) - ram_re(1:16, 2) - ram_im(1:16, 3) + ram_re(1:16, 4))/4;
    but_im(1:16, 3) = (ram_im(1:16, 1) - ram_im(1:16, 2) + ram_im(1:16, 3) - ram_im(1:16, 4))/4;
    but_im(1:16, 4) = (ram_im(1:16, 1) + ram_re(1:16, 2) - ram_im(1:16, 3) - ram_re(1:16, 4))/4;

% multipiler:
    mult_re(1:16, 1) = but_re(1:16, 1); % 0
    mult_im(1:16, 1) = but_im(1:16, 1);

    mult_re(1:16, 2) = (but_re(1:16, 2).*w_re(1:16) - but_im(1:16, 2).*w_im(1:16))/1024; % 0 : 1 : 15
    mult_im(1:16, 2) = (but_re(1:16, 2).*w_im(1:16) + but_im(1:16, 2).*w_re(1:16))/1024;

    mult_re(1:16, 3) = (but_re(1:16, 3).*w_re(1:2:31) - but_im(1:16, 3).*w_im(1:2:31))/1024; % 0 : 2 : 30 
    mult_im(1:16, 3) = (but_re(1:16, 3).*w_im(1:2:31) + but_im(1:16, 3).*w_re(1:2:31))/1024;

    mult_re(1:16, 4) = (but_re(1:16, 4).*w_re(1:3:46) - but_im(1:16, 4).*w_im(1:3:46))/1024; % 0 : 3 : 45
    mult_im(1:16, 4) = (but_re(1:16, 4).*w_im(1:3:46) + but_im(1:16, 4).*w_re(1:3:46))/1024;

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
    mult_re(1:16, 1) = but_re(1:16, 1); % 0
    mult_im(1:16, 1) = but_im(1:16, 1);

    mult_re(1:16, 2) = (but_re(1:16, 2).*w_re2_2st(1:16) - but_im(1:16, 2).*w_im2_2st(1:16))/1024; % 0 : 1 : 3
    mult_im(1:16, 2) = (but_re(1:16, 2).*w_im2_2st(1:16) + but_im(1:16, 2).*w_re2_2st(1:16))/1024;

    mult_re(1:16, 3) = (but_re(1:16, 3).*w_re3_2st(1:16) - but_im(1:16, 3).*w_im3_2st(1:16))/1024; % 0 : 2 : 6
    mult_im(1:16, 3) = (but_re(1:16, 3).*w_im3_2st(1:16) + but_im(1:16, 3).*w_re3_2st(1:16))/1024;

    mult_re(1:16, 4) = (but_re(1:16, 4).*w_re4_2st(1:16) - but_im(1:16, 4).*w_im4_2st(1:16))/1024; % 0 : 3 : 9
    mult_im(1:16, 4) = (but_re(1:16, 4).*w_im4_2st(1:16) + but_im(1:16, 4).*w_re4_2st(1:16))/1024;
    
    %clear w_re_2_2st; clear w_re_3_2st; clear w_re_4_2st;
    
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