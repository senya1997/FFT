clc;
close all;

% you need massive "res" in unsigned/signed dec
% input parameters:
    file_name = 'rot_coef.mif';
    width = 12;
    depth = 2048;

fprintf('\n	Begin\n');

figure; plot(res);
title('res:'); grid on;

fout = fopen(file_name, 'wt');
 
	fprintf(fout, 'WIDTH=%d;\n', width);
	fprintf(fout, 'DEPTH=%d;\n', depth);
	fprintf(fout, '\n');
	fprintf(fout, 'ADDRESS_RADIX=UNS;\n');
	fprintf(fout, 'DATA_RADIX=HEX;\n');
	fprintf(fout, '\n');
	fprintf(fout, 'CONTENT BEGIN\n');

fprintf('\n		add data in ".mif"...\n');

for i = 1:depth
    m = dec2hex((res(i) < 0)*2^width + res(i), width/4);
    fprintf(fout, '%d\t:\t%s;\n', i - 1, m);
end

fprintf(fout,'END;');   
fclose(fout);

fprintf('\n	Complete\n');