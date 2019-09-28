function [data, freq] = getDataHex(file_name)

fprintf('\nreading file: %s\n', file_name);

fid = fopen(file_name);
h_hex = textscan(fid, '%s');
h_hex = h_hex{1};

q = quantizer('ufixed', 'nearest', 'saturate', [8 0]); % quantizer obj for num2hex function
    comp =          hex2num(q, h_hex(1));
    ch =            hex2num(q, h_hex(2));
    bit_sample =	hex2num(q, h_hex(4));
    
    comp =          cell2mat(comp);
    ch =            cell2mat(ch);
    bit_sample =	cell2mat(bit_sample);
    
    fprintf('     compression:	%d\n', comp);
    fprintf('     channels:      %d\n', ch);
    fprintf('     bit sample:	%d\n', bit_sample);
    
q = quantizer('ufixed', 'nearest', 'saturate', [32 0]);
    freq = hex2num(q, h_hex(3));
    freq = cell2mat(freq);
    fprintf('     sample rate:	%d\n', freq);
    
q = quantizer('fixed', 'nearest', 'saturate', [bit_sample 0]);
    data = hex2num(q, h_hex(5:length(h_hex)));
    data = cell2mat(data);

fclose(fid);
fprintf('complete\n\n');