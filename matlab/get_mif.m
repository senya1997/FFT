clear;
clc;

%    in '.mif' complex coef save in one data where   %
%    1st half MSB is imag part of coef               %
%    2ns LSB is real part, e.g. for 12 bit coef:     %
%                imag(1) | real(2)                   %
%                23...12 | 11...0                    %

width = 12; % imag and real separate
depth = 1024;

fprintf('\n\tBegin\n');

%% read files:
    w_re(1:depth, 1:3) = [load('w_re_1.txt'), load('w_re_2.txt'), load('w_re_3.txt')];
    w_im(1:depth, 1:3) = [load('w_im_1.txt'), load('w_im_2.txt'), load('w_im_3.txt')];
    
    file_mif(1:3) = [fopen('rom_1.mif', 'wt'), fopen('rom_2.mif', 'wt'), fopen('rom_3.mif', 'wt')];

%% descriptor:
for i = 1:3
	fprintf(file_mif(i), 'WIDTH=%d;\n', 2*width);
	fprintf(file_mif(i), 'DEPTH=%d;\n', depth);
	fprintf(file_mif(i), '\n');
	fprintf(file_mif(i), 'ADDRESS_RADIX=UNS;\n');
    fprintf(file_mif(i), 'DATA_RADIX=HEX;\n');
	fprintf(file_mif(i), '\n');
	fprintf(file_mif(i), 'CONTENT BEGIN\n');
end

fprintf('\n\t\tadd data in ".mif"...\n');

%% add data:
for k = 1:3
    for i = 1:depth
        w_str = [num2str(dec2hex((w_im(i, k) < 0)*2^width + w_im(i, k), width/4)),...
                 num2str(dec2hex((w_re(i, k) < 0)*2^width + w_re(i, k), width/4))];

        fprintf(file_mif(k), '%d\t:\t%s;\n', i - 1, w_str);
    end
end

for i = 1:3
    fprintf(file_mif(i),'END;');
    fclose(file_mif(i));
end

fprintf('\n\tComplete\n');