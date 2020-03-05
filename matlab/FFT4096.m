clear;
close all;
clc;

% choose test signal:
    test = 'sin';
    %test = 'audio';
    %test = 'const';
    %test = 'num'; % numbers 0...N (function 'y = x', x > 0)

% sin spec:
    Fd = 44100;

    amp_1 = 10000; % 1st sine from e.g. 16 bit ADC
    amp_2 = 5000; % 2nd sine
    amp_noise = 15000;
    
    freq_1 = 9000; % Hz
    freq_2 = 4500;

    phase_1 = 0; % grad
    phase_2 = 37;

    bias = 10000;
% auido sample path:   
    audiofile = 'impulses/sample_in.wav';
    boost = 1.5e4; % all sample points multiple on this coef for normalize
% const signal:
    dc = 100;

N = 4096;
N_bank = N/4; % cause Radix-4

w_amp = 1024; % amplitude of twiddle coef use to normalize data after multiplier
stage = 6; % number of stage

fprintf('\n\tBegin\n');
fprintf('\n\t\tread and sort coef...\n');

%% ==============================   coef:   ===============================
w_re_1(1:N_bank, 1) = load('w_re_1.txt'); % column mean stage of FFT
w_re_2(1:N_bank, 1) = load('w_re_2.txt');
w_re_3(1:N_bank, 1) = load('w_re_3.txt');

w_im_1(1:N_bank, 1) = load('w_im_1.txt');
w_im_2(1:N_bank, 1) = load('w_im_2.txt');
w_im_3(1:N_bank, 1) = load('w_im_3.txt');

for i = 1:(stage - 2) % '- 2' because stage with multiplier '= stage - 1'
        w_re_1_buf = w_re_1(1:4:N_bank, i);
    w_re_1(1:N_bank, i + 1) = [w_re_1_buf; w_re_1_buf; w_re_1_buf; w_re_1_buf];
        w_re_2_buf = w_re_2(1:4:N_bank, i);
    w_re_2(1:N_bank, i + 1) = [w_re_2_buf; w_re_2_buf; w_re_2_buf; w_re_2_buf];
        w_re_3_buf = w_re_3(1:4:N_bank, i);
    w_re_3(1:N_bank, i + 1) = [w_re_3_buf; w_re_3_buf; w_re_3_buf; w_re_3_buf];

        w_im_1_buf = w_im_1(1:4:N_bank, i);
    w_im_1(1:N_bank, i + 1) = [w_im_1_buf; w_im_1_buf; w_im_1_buf; w_im_1_buf];
        w_im_2_buf = w_im_2(1:4:N_bank, i);
    w_im_2(1:N_bank, i + 1) = [w_im_2_buf; w_im_2_buf; w_im_2_buf; w_im_2_buf];
        w_im_3_buf = w_im_3(1:4:N_bank, i);
    w_im_3(1:N_bank, i + 1) = [w_im_3_buf; w_im_3_buf; w_im_3_buf; w_im_3_buf];
end

clear w_re_1_buf; clear w_re_2_buf; clear w_re_3_buf;  
clear w_im_1_buf; clear w_im_2_buf; clear w_im_3_buf;

%% ===========================   test signal:   ===========================
fprintf('\n\t\tbuild test signal...\n');
if(strcmp(test, 'sin'))
    time = 0 : 1/Fd : (N - 1)/Fd;
    
    noise = amp_noise * randn(1, length(time));
    signal = bias + amp_1*sind((freq_1*360).* time + phase_1) +...
                    amp_2*sind((freq_2*360).* time + phase_2) + noise;
    
    clear Fd; clear bias; clear time;
    clear amp_1; clear amp_2;
    clear freq_1; clear freq_2;
    clear phase_1; clear phase_2;
    
    fprintf('\n\t\tsine signal test\n');
elseif(strcmp(test, 'audio'))
    [y, fs] = audioread(audiofile);
    signal(1:N) = y(1:N).*boost;
    
    clear y; clear fs;
    
    fprintf('\n\t\taudio test\n');
elseif(strcmp(test, 'const'))
    signal(1:N) = dc;
    fprintf('\n\t\tconst test\n');
elseif(strcmp(test, 'num'))
    signal(1:N) = 0 : (N-1);
    fprintf('\n\t\tindex number test\n');
else
    error('"test" is wrong\n');
end

% filling RAM:
ram_re(1:N_bank, 1:4) = zeros;
ram_im(1:N_bank, 1:4) = zeros;

k = 0;
for i = 1:4 
    for j = 1:N_bank
        k = k + 1;
        ram_re(j, i) = round(signal(k));
    end
end

% graphic of test signal:
figure;
signal_buf(1:N) = [ram_re(:,1), ram_re(:,2), ram_re(:,3), ram_re(:,4)];
plot(signal_buf);
title('Test signal:');
grid on;

clear k; clear j; clear signal_buf;

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

% output mixer:
for i = 1:256
    t = (i-1)*4;
    
    ram_re(1+t, 1:4) = [ram_a_re_buf(1+t, 1), ram_a_re_buf(1+t, 2), ram_a_re_buf(1+t, 3), ram_a_re_buf(1+t, 4)];
    ram_re(2+t, 1:4) = [ram_a_re_buf(2+t, 2), ram_a_re_buf(2+t, 3), ram_a_re_buf(2+t, 4), ram_a_re_buf(2+t, 1)];
    ram_re(3+t, 1:4) = [ram_a_re_buf(3+t, 3), ram_a_re_buf(3+t, 4), ram_a_re_buf(3+t, 1), ram_a_re_buf(3+t, 2)];
    ram_re(4+t, 1:4) = [ram_a_re_buf(4+t, 4), ram_a_re_buf(4+t, 1), ram_a_re_buf(4+t, 2), ram_a_re_buf(4+t, 3)];
end

%% ===========================    6 stage    ===============================

ram_a_re_buf(1:N_bank, 1:4) = zeros;

% input mixer + rotate addr:
for i = 1:256
    t = (i-1)*4;
    
    ram_a_re_buf(1+t, 1:4) = [ram_re(1+t, 1), ram_re(2+t, 4), ram_re(3+t, 3), ram_re(4+t, 2)];
    ram_a_re_buf(2+t, 1:4) = [ram_re(1+t, 2), ram_re(2+t, 1), ram_re(3+t, 4), ram_re(4+t, 3)];
    ram_a_re_buf(3+t, 1:4) = [ram_re(1+t, 3), ram_re(2+t, 2), ram_re(3+t, 1), ram_re(4+t, 4)];
    ram_a_re_buf(4+t, 1:4) = [ram_re(1+t, 4), ram_re(2+t, 3), ram_re(3+t, 2), ram_re(4+t, 1)];
end
%}

fprintf('\n\t\tstart FFT...\n');
%% ===========================    1 stage    ===============================
% butterfly:
    but_re(1:N_bank, 1) = (ram_re(1:N_bank, 1) + ram_re(1:N_bank, 2) + ram_re(1:N_bank, 3) + ram_re(1:N_bank, 4))/4;
    but_re(1:N_bank, 2) = (ram_re(1:N_bank, 1) + ram_im(1:N_bank, 2) - ram_re(1:N_bank, 3) - ram_im(1:N_bank, 4))/4;
    but_re(1:N_bank, 3) = (ram_re(1:N_bank, 1) - ram_re(1:N_bank, 2) + ram_re(1:N_bank, 3) - ram_re(1:N_bank, 4))/4;
    but_re(1:N_bank, 4) = (ram_re(1:N_bank, 1) - ram_im(1:N_bank, 2) - ram_re(1:N_bank, 3) + ram_im(1:N_bank, 4))/4;

    but_im(1:N_bank, 1) = (ram_im(1:N_bank, 1) + ram_im(1:N_bank, 2) + ram_im(1:N_bank, 3) + ram_im(1:N_bank, 4))/4;
    but_im(1:N_bank, 2) = (ram_im(1:N_bank, 1) - ram_re(1:N_bank, 2) - ram_im(1:N_bank, 3) + ram_re(1:N_bank, 4))/4;
    but_im(1:N_bank, 3) = (ram_im(1:N_bank, 1) - ram_im(1:N_bank, 2) + ram_im(1:N_bank, 3) - ram_im(1:N_bank, 4))/4;
    but_im(1:N_bank, 4) = (ram_im(1:N_bank, 1) + ram_re(1:N_bank, 2) - ram_im(1:N_bank, 3) - ram_re(1:N_bank, 4))/4;

% multipiler:
    mult_re(1:N_bank, 1) = but_re(1:N_bank, 1);
    mult_im(1:N_bank, 1) = but_im(1:N_bank, 1);

    mult_re(1:N_bank, 2) = (but_re(1:N_bank, 2).*w_re_1(1:N_bank, 1) - but_im(1:N_bank, 2).*w_im_1(1:N_bank, 1))/w_amp;
    mult_im(1:N_bank, 2) = (but_re(1:N_bank, 2).*w_im_1(1:N_bank, 1) + but_im(1:N_bank, 2).*w_re_1(1:N_bank, 1))/w_amp;

    mult_re(1:N_bank, 3) = (but_re(1:N_bank, 3).*w_re_2(1:N_bank, 1) - but_im(1:N_bank, 3).*w_im_2(1:N_bank, 1))/w_amp;
    mult_im(1:N_bank, 3) = (but_re(1:N_bank, 3).*w_im_2(1:N_bank, 1) + but_im(1:N_bank, 3).*w_re_2(1:N_bank, 1))/w_amp;

    mult_re(1:N_bank, 4) = (but_re(1:N_bank, 4).*w_re_3(1:N_bank, 1) - but_im(1:N_bank, 4).*w_im_3(1:N_bank, 1))/w_amp; 
    mult_im(1:N_bank, 4) = (but_re(1:N_bank, 4).*w_im_3(1:N_bank, 1) + but_im(1:N_bank, 4).*w_re_3(1:N_bank, 1))/w_amp;

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
    but_re(1:N_bank, 1) = (ram_re(1:N_bank, 1) + ram_re(1:N_bank, 2) + ram_re(1:N_bank, 3) + ram_re(1:N_bank, 4))/4;
    but_re(1:N_bank, 2) = (ram_re(1:N_bank, 1) + ram_im(1:N_bank, 2) - ram_re(1:N_bank, 3) - ram_im(1:N_bank, 4))/4;
    but_re(1:N_bank, 3) = (ram_re(1:N_bank, 1) - ram_re(1:N_bank, 2) + ram_re(1:N_bank, 3) - ram_re(1:N_bank, 4))/4;
    but_re(1:N_bank, 4) = (ram_re(1:N_bank, 1) - ram_im(1:N_bank, 2) - ram_re(1:N_bank, 3) + ram_im(1:N_bank, 4))/4;

    but_im(1:N_bank, 1) = (ram_im(1:N_bank, 1) + ram_im(1:N_bank, 2) + ram_im(1:N_bank, 3) + ram_im(1:N_bank, 4))/4;
    but_im(1:N_bank, 2) = (ram_im(1:N_bank, 1) - ram_re(1:N_bank, 2) - ram_im(1:N_bank, 3) + ram_re(1:N_bank, 4))/4;
    but_im(1:N_bank, 3) = (ram_im(1:N_bank, 1) - ram_im(1:N_bank, 2) + ram_im(1:N_bank, 3) - ram_im(1:N_bank, 4))/4;
    but_im(1:N_bank, 4) = (ram_im(1:N_bank, 1) + ram_re(1:N_bank, 2) - ram_im(1:N_bank, 3) - ram_re(1:N_bank, 4))/4;
    
% multipiler:
    mult_re(1:N_bank, 1) = but_re(1:N_bank, 1);
    mult_im(1:N_bank, 1) = but_im(1:N_bank, 1);

    mult_re(1:N_bank, 2) = (but_re(1:N_bank, 2).*w_re_1(1:N_bank, 2) - but_im(1:N_bank, 2).*w_im_1(1:N_bank, 2))/w_amp;
    mult_im(1:N_bank, 2) = (but_re(1:N_bank, 2).*w_im_1(1:N_bank, 2) + but_im(1:N_bank, 2).*w_re_1(1:N_bank, 2))/w_amp;

    mult_re(1:N_bank, 3) = (but_re(1:N_bank, 3).*w_re_2(1:N_bank, 2) - but_im(1:N_bank, 3).*w_im_2(1:N_bank, 2))/w_amp;
    mult_im(1:N_bank, 3) = (but_re(1:N_bank, 3).*w_im_2(1:N_bank, 2) + but_im(1:N_bank, 3).*w_re_2(1:N_bank, 2))/w_amp;

    mult_re(1:N_bank, 4) = (but_re(1:N_bank, 4).*w_re_3(1:N_bank, 2) - but_im(1:N_bank, 4).*w_im_3(1:N_bank, 2))/w_amp;
    mult_im(1:N_bank, 4) = (but_re(1:N_bank, 4).*w_im_3(1:N_bank, 2) + but_im(1:N_bank, 4).*w_re_3(1:N_bank, 2))/w_amp;
    
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

ram_a_re_buf(1:N_bank, 1:4) = zeros;
ram_a_im_buf(1:N_bank, 1:4) = zeros;

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
    but_re(1:N_bank, 1) = (ram_re(1:N_bank, 1) + ram_re(1:N_bank, 2) + ram_re(1:N_bank, 3) + ram_re(1:N_bank, 4))/4;
    but_re(1:N_bank, 2) = (ram_re(1:N_bank, 1) + ram_im(1:N_bank, 2) - ram_re(1:N_bank, 3) - ram_im(1:N_bank, 4))/4;
    but_re(1:N_bank, 3) = (ram_re(1:N_bank, 1) - ram_re(1:N_bank, 2) + ram_re(1:N_bank, 3) - ram_re(1:N_bank, 4))/4;
    but_re(1:N_bank, 4) = (ram_re(1:N_bank, 1) - ram_im(1:N_bank, 2) - ram_re(1:N_bank, 3) + ram_im(1:N_bank, 4))/4;

    but_im(1:N_bank, 1) = (ram_im(1:N_bank, 1) + ram_im(1:N_bank, 2) + ram_im(1:N_bank, 3) + ram_im(1:N_bank, 4))/4;
    but_im(1:N_bank, 2) = (ram_im(1:N_bank, 1) - ram_re(1:N_bank, 2) - ram_im(1:N_bank, 3) + ram_re(1:N_bank, 4))/4;
    but_im(1:N_bank, 3) = (ram_im(1:N_bank, 1) - ram_im(1:N_bank, 2) + ram_im(1:N_bank, 3) - ram_im(1:N_bank, 4))/4;
    but_im(1:N_bank, 4) = (ram_im(1:N_bank, 1) + ram_re(1:N_bank, 2) - ram_im(1:N_bank, 3) - ram_re(1:N_bank, 4))/4;
    
% multipiler:
    mult_re(1:N_bank, 1) = but_re(1:N_bank, 1);
    mult_im(1:N_bank, 1) = but_im(1:N_bank, 1);

    mult_re(1:N_bank, 2) = (but_re(1:N_bank, 2).*w_re_1(1:N_bank, 3) - but_im(1:N_bank, 2).*w_im_1(1:N_bank, 3))/w_amp;
    mult_im(1:N_bank, 2) = (but_re(1:N_bank, 2).*w_im_1(1:N_bank, 3) + but_im(1:N_bank, 2).*w_re_1(1:N_bank, 3))/w_amp;

    mult_re(1:N_bank, 3) = (but_re(1:N_bank, 3).*w_re_2(1:N_bank, 3) - but_im(1:N_bank, 3).*w_im_2(1:N_bank, 3))/w_amp;
    mult_im(1:N_bank, 3) = (but_re(1:N_bank, 3).*w_im_2(1:N_bank, 3) + but_im(1:N_bank, 3).*w_re_2(1:N_bank, 3))/w_amp;

    mult_re(1:N_bank, 4) = (but_re(1:N_bank, 4).*w_re_3(1:N_bank, 3) - but_im(1:N_bank, 4).*w_im_3(1:N_bank, 3))/w_amp;
    mult_im(1:N_bank, 4) = (but_re(1:N_bank, 4).*w_im_3(1:N_bank, 3) + but_im(1:N_bank, 4).*w_re_3(1:N_bank, 3))/w_amp;

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

ram_a_re_buf(1:N_bank, 1:4) = zeros;
ram_a_im_buf(1:N_bank, 1:4) = zeros;

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
    but_re(1:N_bank, 1) = (ram_re(1:N_bank, 1) + ram_re(1:N_bank, 2) + ram_re(1:N_bank, 3) + ram_re(1:N_bank, 4))/4;
    but_re(1:N_bank, 2) = (ram_re(1:N_bank, 1) + ram_im(1:N_bank, 2) - ram_re(1:N_bank, 3) - ram_im(1:N_bank, 4))/4;
    but_re(1:N_bank, 3) = (ram_re(1:N_bank, 1) - ram_re(1:N_bank, 2) + ram_re(1:N_bank, 3) - ram_re(1:N_bank, 4))/4;
    but_re(1:N_bank, 4) = (ram_re(1:N_bank, 1) - ram_im(1:N_bank, 2) - ram_re(1:N_bank, 3) + ram_im(1:N_bank, 4))/4;

    but_im(1:N_bank, 1) = (ram_im(1:N_bank, 1) + ram_im(1:N_bank, 2) + ram_im(1:N_bank, 3) + ram_im(1:N_bank, 4))/4;
    but_im(1:N_bank, 2) = (ram_im(1:N_bank, 1) - ram_re(1:N_bank, 2) - ram_im(1:N_bank, 3) + ram_re(1:N_bank, 4))/4;
    but_im(1:N_bank, 3) = (ram_im(1:N_bank, 1) - ram_im(1:N_bank, 2) + ram_im(1:N_bank, 3) - ram_im(1:N_bank, 4))/4;
    but_im(1:N_bank, 4) = (ram_im(1:N_bank, 1) + ram_re(1:N_bank, 2) - ram_im(1:N_bank, 3) - ram_re(1:N_bank, 4))/4;
    
% multipiler:
    mult_re(1:N_bank, 1) = but_re(1:N_bank, 1);
    mult_im(1:N_bank, 1) = but_im(1:N_bank, 1);

    mult_re(1:N_bank, 2) = (but_re(1:N_bank, 2).*w_re_1(1:N_bank, 4) - but_im(1:N_bank, 2).*w_im_1(1:N_bank, 4))/w_amp;
    mult_im(1:N_bank, 2) = (but_re(1:N_bank, 2).*w_im_1(1:N_bank, 4) + but_im(1:N_bank, 2).*w_re_1(1:N_bank, 4))/w_amp;

    mult_re(1:N_bank, 3) = (but_re(1:N_bank, 3).*w_re_2(1:N_bank, 4) - but_im(1:N_bank, 3).*w_im_2(1:N_bank, 4))/w_amp;
    mult_im(1:N_bank, 3) = (but_re(1:N_bank, 3).*w_im_2(1:N_bank, 4) + but_im(1:N_bank, 3).*w_re_2(1:N_bank, 4))/w_amp;

    mult_re(1:N_bank, 4) = (but_re(1:N_bank, 4).*w_re_3(1:N_bank, 4) - but_im(1:N_bank, 4).*w_im_3(1:N_bank, 4))/w_amp;
    mult_im(1:N_bank, 4) = (but_re(1:N_bank, 4).*w_im_3(1:N_bank, 4) + but_im(1:N_bank, 4).*w_re_3(1:N_bank, 4))/w_amp;
    
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

ram_a_re_buf(1:N_bank, 1:4) = zeros;
ram_a_im_buf(1:N_bank, 1:4) = zeros;

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
    but_re(1:N_bank, 1) = (ram_re(1:N_bank, 1) + ram_re(1:N_bank, 2) + ram_re(1:N_bank, 3) + ram_re(1:N_bank, 4))/4;
    but_re(1:N_bank, 2) = (ram_re(1:N_bank, 1) + ram_im(1:N_bank, 2) - ram_re(1:N_bank, 3) - ram_im(1:N_bank, 4))/4;
    but_re(1:N_bank, 3) = (ram_re(1:N_bank, 1) - ram_re(1:N_bank, 2) + ram_re(1:N_bank, 3) - ram_re(1:N_bank, 4))/4;
    but_re(1:N_bank, 4) = (ram_re(1:N_bank, 1) - ram_im(1:N_bank, 2) - ram_re(1:N_bank, 3) + ram_im(1:N_bank, 4))/4;

    but_im(1:N_bank, 1) = (ram_im(1:N_bank, 1) + ram_im(1:N_bank, 2) + ram_im(1:N_bank, 3) + ram_im(1:N_bank, 4))/4;
    but_im(1:N_bank, 2) = (ram_im(1:N_bank, 1) - ram_re(1:N_bank, 2) - ram_im(1:N_bank, 3) + ram_re(1:N_bank, 4))/4;
    but_im(1:N_bank, 3) = (ram_im(1:N_bank, 1) - ram_im(1:N_bank, 2) + ram_im(1:N_bank, 3) - ram_im(1:N_bank, 4))/4;
    but_im(1:N_bank, 4) = (ram_im(1:N_bank, 1) + ram_re(1:N_bank, 2) - ram_im(1:N_bank, 3) - ram_re(1:N_bank, 4))/4;

% multipiler:
    mult_re(1:N_bank, 1) = but_re(1:N_bank, 1); % 0
    mult_im(1:N_bank, 1) = but_im(1:N_bank, 1);

    mult_re(1:N_bank, 2) = (but_re(1:N_bank, 2).*w_re_1(1:N_bank, 5) - but_im(1:N_bank, 2).*w_im_1(1:N_bank, 5))/w_amp;
    mult_im(1:N_bank, 2) = (but_re(1:N_bank, 2).*w_im_1(1:N_bank, 5) + but_im(1:N_bank, 2).*w_re_1(1:N_bank, 5))/w_amp;

    mult_re(1:N_bank, 3) = (but_re(1:N_bank, 3).*w_re_2(1:N_bank, 5) - but_im(1:N_bank, 3).*w_im_2(1:N_bank, 5))/w_amp;
    mult_im(1:N_bank, 3) = (but_re(1:N_bank, 3).*w_im_2(1:N_bank, 5) + but_im(1:N_bank, 3).*w_re_2(1:N_bank, 5))/w_amp;

    mult_re(1:N_bank, 4) = (but_re(1:N_bank, 4).*w_re_3(1:N_bank, 5) - but_im(1:N_bank, 4).*w_im_3(1:N_bank, 5))/w_amp;
    mult_im(1:N_bank, 4) = (but_re(1:N_bank, 4).*w_im_3(1:N_bank, 5) + but_im(1:N_bank, 4).*w_re_3(1:N_bank, 5))/w_amp;
    
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

ram_a_re_buf(1:N_bank, 1:4) = zeros;
ram_a_im_buf(1:N_bank, 1:4) = zeros;

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
    but_re(1:N_bank, 1) = (ram_re(1:N_bank, 1) + ram_re(1:N_bank, 2) + ram_re(1:N_bank, 3) + ram_re(1:N_bank, 4))/4;
    but_re(1:N_bank, 2) = (ram_re(1:N_bank, 1) + ram_im(1:N_bank, 2) - ram_re(1:N_bank, 3) - ram_im(1:N_bank, 4))/4;
    but_re(1:N_bank, 3) = (ram_re(1:N_bank, 1) - ram_re(1:N_bank, 2) + ram_re(1:N_bank, 3) - ram_re(1:N_bank, 4))/4;
    but_re(1:N_bank, 4) = (ram_re(1:N_bank, 1) - ram_im(1:N_bank, 2) - ram_re(1:N_bank, 3) + ram_im(1:N_bank, 4))/4;

    but_im(1:N_bank, 1) = (ram_im(1:N_bank, 1) + ram_im(1:N_bank, 2) + ram_im(1:N_bank, 3) + ram_im(1:N_bank, 4))/4;
    but_im(1:N_bank, 2) = (ram_im(1:N_bank, 1) - ram_re(1:N_bank, 2) - ram_im(1:N_bank, 3) + ram_re(1:N_bank, 4))/4;
    but_im(1:N_bank, 3) = (ram_im(1:N_bank, 1) - ram_im(1:N_bank, 2) + ram_im(1:N_bank, 3) - ram_im(1:N_bank, 4))/4;
    but_im(1:N_bank, 4) = (ram_im(1:N_bank, 1) + ram_re(1:N_bank, 2) - ram_im(1:N_bank, 3) - ram_re(1:N_bank, 4))/4;

%% output files
fprintf('\n\t\tsave files...\n');

file_a_re = fopen('ram_a_re.txt', 'w');
file_a_im = fopen('ram_a_im.txt', 'w');

for i = 1:N_bank
    fprintf(file_a_re, '%d\t%d\t%d\t%d\n', but_re(i, 1:4)); 
    fprintf(file_a_im, '%d\t%d\t%d\t%d\n', but_im(i, 1:4)); 
end

fclose(file_a_re);
fclose(file_a_im);

fprintf('\n\tComplete\n');