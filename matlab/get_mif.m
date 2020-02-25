clc;
clear;

%    in '.mif' complex coef save in one data where   %
%    1st half MSB is imag part of coef               %
%    2ns LSB is real part, e.g. for 12 bit coef:     %
%                imag(1) | real(2)                   %
%                23...12 | 11...0                    %

%mode = 'home';
mode = 'work';

%data = 'hex';
data = 'bin';

width = 24;
depth = 1024;

%% read files:
if(strcmp(mode, 'work'))
    w_2(1:depth, 2) = load('D:\work\fft\matlab\w_re_1.txt');
    w_2(1:depth, 1) = load('D:\work\fft\matlab\w_im_1.txt');

    w_3(1:depth, 2) = load('D:\work\fft\matlab\w_re_2.txt');
    w_3(1:depth, 1) = load('D:\work\fft\matlab\w_im_2.txt');

    w_4(1:depth, 2) = load('D:\work\fft\matlab\w_re_3.txt');
    w_4(1:depth, 1) = load('D:\work\fft\matlab\w_im_3.txt');
    
        file_1 = fopen('D:\work\fft\matlab\rom_1.mif', 'wt');
        file_2 = fopen('D:\work\fft\matlab\rom_2.mif', 'wt');
        file_3 = fopen('D:\work\fft\matlab\rom_3.mif', 'wt');
elseif(strcmp(mode, 'home'))
    w_2(1:depth, 2) = load('D:\SS\fpga\fft\matlab\w_re_1.txt');
    w_2(1:depth, 1) = load('D:\SS\fpga\fft\matlab\w_im_1.txt');

    w_3(1:depth, 2) = load('D:\SS\fpga\fft\matlab\w_re_2.txt');
    w_3(1:depth, 1) = load('D:\SS\fpga\fft\matlab\w_im_2.txt');

    w_4(1:depth, 2) = load('D:\SS\fpga\fft\matlab\w_re_3.txt');
    w_4(1:depth, 1) = load('D:\SS\fpga\fft\matlab\w_im_3.txt');
    
        file_1 = fopen('D:\SS\fpga\fft\matlab\rom_1.mif', 'wt');
        file_2 = fopen('D:\SS\fpga\fft\matlab\rom_2.mif', 'wt');
        file_3 = fopen('D:\SS\fpga\fft\matlab\rom_3.mif', 'wt');
else
    error('"mode" is wrong');
end

fprintf('\n\tBegin\n');

	fprintf(fout, 'WIDTH=%d;\n', width);
	fprintf(fout, 'DEPTH=%d;\n', depth);
	fprintf(fout, '\n');
	fprintf(fout, 'ADDRESS_RADIX=UNS;\n');
    
    if(strcmp(data, 'hex'))
        fprintf(fout, 'DATA_RADIX=HEX;\n');
    elseif(strcmp(data, 'bin'))
        fprintf(fout, 'DATA_RADIX=BIN;\n');
    else
        error('\n\twrong data type');
    end
        
	fprintf(fout, '\n');
	fprintf(fout, 'CONTENT BEGIN\n');

fprintf('\n\t\tadd data in ".mif"...\n');

for i = 1:depth
    if(strcmp(data, 'hex'))
        m = dec2hex((res(i) < 0)*2^width + res(i), width/4);
    else
        m = dec2bin((res(i) < 0)*2^width + res(i), width/4);
    end
    
    fprintf(fout, '%d\t:\t%s;\n', i - 1, m);
end

fprintf(file_1,'END;'); fprintf(file_2,'END;'); fprintf(file_3,'END;');
fclose(file_1); fclose(file_2); fclose(file_3);

fprintf('\n\tComplete\n');