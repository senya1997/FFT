clear; close all;

[x, freq_x] = getDataHex('sample_in_16bit.hex');
[h, freq_h] = getDataHex('c1000_16bit.hex');

if(freq_x ~= freq_h)
    fprintf('\nSAMPLE RATE of input signal and impulse are DIFFERENT!\n');
end

if(length(h) > 10000)
    [h_cut] = filCut(h, 1);
else
    h_cut = h;
end

fprintf('\nstart apply filter...\n');
y(1:length(x)) = zeros;

% like c++ code:
for i = 1:length(x) % sample length
    for j = 1:length(h_cut) % impulse length
        if(i-j >= 1)
            y(i) = y(i) + h_cut(j)*x(i-j);
        end
    end
end

% like FPGA:
%{
temp_x(1:length(h)) = x(1:length(h));
temp_y(1:length(h)) = zeros;

%for i = 1:(length(x) - length(h) - 1)
for i = 1:(length(x)/4)
    for k = 1:length(h)
        for j = 1:length(h) % impulse length
            if((k-j) >= 1)
                temp_y(k) = temp_y(k) + h(j)*temp_x(k-j);
            end
        end
    end
    
    y(i) = temp_y(round(k/2)); % merge output sample in packet
    temp_x = x((i + 1) : (i + length(h))); % input sample
end
%}

y_h(1:length(y)) = zeros;
for i = 1:length(y)
    if(y(i) >= 0) 
        y_h(i) = dec2hex(y(i)); 
    else 
        y_h(i) = dec2hex(y(i) + 2^32); 
    end
end

y = y';

fprintf('building graph...\n');

figure;
plot(h); hold on;
plot(h_cut); grid on;
title('impulses:'); legend('original', 'applied');

figure;
plot(x); hold on;
plot(y); grid on;
title('signal:'); legend('input', 'output');

audiowrite('sample_out.wav', y/65535, freq_x);
fprintf('\ncomplete\n');