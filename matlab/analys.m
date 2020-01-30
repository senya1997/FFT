clear;
clc;

mode = 'home';
%mode = 'work';

%model = 'fpga';
model = 'math';

fprintf('\n\tStart\n\n');

a_re(1:2048) = zeros;
a_im(1:2048) = zeros;
b_re(1:2048) = zeros;
b_im(1:2048) = zeros;

%% load files
fprintf('reading file...\n');

if(strcmp(mode, 'work'))
    if(strcmp(model, 'math'))
        file_a_re = load('D:\work\fft\matlab\ram_a_re.txt');
        file_a_im = load('D:\work\fft\matlab\ram_a_im.txt');
    elseif(strcmp(model, 'fpga'))
        file_a_re = load('D:\work\modelsim\fft\ram_a_re.txt');
        file_a_im = load('D:\work\modelsim\fft\ram_a_im.txt');
        file_b_re = load('D:\work\modelsim\fft\ram_b_re.txt');
        file_b_im = load('D:\work\modelsim\fft\ram_b_im.txt');
    else
        error('"model" is wrong');
    end
elseif(strcmp(mode, 'home'))
    if(strcmp(model, 'math'))
        file_a_re = load('D:\SS\fpga\fft\matlab\ram_a_re.txt');
        file_a_im = load('D:\SS\fpga\fft\matlab\ram_a_im.txt');
    elseif(strcmp(model, 'fpga'))
        file_a_re = load('D:\SS\fpga\modelsim\fft\ram_a_re.txt');
        file_a_im = load('D:\SS\fpga\modelsim\fft\ram_a_im.txt');
        file_b_re = load('D:\SS\fpga\modelsim\fft\ram_b_re.txt');
        file_b_im = load('D:\SS\fpga\modelsim\fft\ram_b_im.txt');
    else
        error('"model" is wrong');
    end
else
    error('"mode" is wrong');
end

ram_a_re(1:512)     = file_a_re(1:512, 1); ram_a_im(1:512)     = file_a_im(1:512, 1);
ram_a_re(513:1024)  = file_a_re(1:512, 2); ram_a_im(513:1024)  = file_a_im(1:512, 2);
ram_a_re(1025:1536) = file_a_re(1:512, 3); ram_a_im(1025:1536) = file_a_im(1:512, 3);
ram_a_re(1537:2048) = file_a_re(1:512, 4); ram_a_im(1537:2048) = file_a_im(1:512, 4);

if(strcmp(model, 'fpga'))
    ram_b_re(1:512)     = file_b_re(1:512, 1); ram_b_im(1:512)     = file_b_im(1:512, 1);
    ram_b_re(513:1024)  = file_b_re(1:512, 2); ram_b_im(513:1024)  = file_b_im(1:512, 2);
    ram_b_re(1025:1536) = file_b_re(1:512, 3); ram_b_im(1025:1536) = file_b_im(1:512, 3);
    ram_b_re(1537:2048) = file_b_re(1:512, 4); ram_b_im(1537:2048) = file_b_im(1:512, 4);
end

%{
for i = 1:512
    ram_a_re(1, (i+(i-1)*4) : (i*4)) = file_a_re(i, 1:4);
    ram_a_im(1, (i+(i-1)*4) : (i*4)) = file_a_im(i, 1:4);
end

ram_a_re = ram_a_re';
ram_a_im = ram_a_im';
%}

%% bit reverse change to normal
for i = 1:2048
   ind =  bitget(i - 1, 1)*2^10 + bitget(i - 1, 2)*2^9 + bitget(i - 1, 3)*2^8 +...
          bitget(i - 1, 4)*2^7 +  bitget(i - 1, 5)*2^6 + bitget(i - 1, 6)*2^5 +...
          bitget(i - 1, 7)*2^4 +  bitget(i - 1, 8)*2^3 + bitget(i - 1, 9)*2^2 +...
          bitget(i - 1, 10)*2^1 + bitget(i - 1, 11)*2^0;
   
   fprintf('\tind = %4d\ti = %4d\n', ind, i - 1);
   
   a_re(i) = ram_a_re(ind + 1);
   a_im(i) = ram_a_im(ind + 1);
   
   if(strcmp(model, 'fpga'))
       b_re(i) = ram_b_re(ind + 1);
       b_im(i) = ram_b_im(ind + 1);
   end
end

a_re = a_re';
a_im = a_im';

if(strcmp(model, 'fpga'))
    b_re = b_re';
    b_im = b_im';
end

%% AFC from "A" RAM
afc_a = sqrt(a_re.^2 + a_im.^2);
ram_afc_a = sqrt(ram_a_re.^2 + ram_a_im.^2);

%afc_b = sqrt(b_re.^2 + b_im.^2);

%% subtraction first half from second, mirror left and right part of AFC
half_afc_a_1 = afc_a(1:1024);
half_afc_a_2 = afc_a(1025:2048);

sub(1:1024) = zeros;
for i = 1:1024
	sub(i) = half_afc_a_1(i) - half_afc_a_2(i);
end
sub = sub';

%% graphics
fprintf('building graph...\n');
    figure;    
    plot(afc_a);
    title('AFC from RAM "A":');
    grid on;

    figure;    
    plot(ram_afc_a);
    title('AFC from RAM "A" without change position harm:');
    grid on;

    figure;
    plot(sub);
    title('subtraction:');
    grid on;
    
fprintf('\n\tComplete\n');