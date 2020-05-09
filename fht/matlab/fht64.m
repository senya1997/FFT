clear;
clc;

N = 64;
N_bank = 4;

%test = 'sin';
test = 'const';
%test = 'num';

Fd = 44100;

amp_1 = 10000; % e.g. 16 bit ADC
amp_2 = 5000; % 2nd sine

freq_1 = 9000; % Hz
freq_2 = 4500;

phase_1 = 0; % grad
phase_2 = 37;

bias = 0;
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

row = round(N/N_bank);

k = 0;
ram(1:row, 1:N_bank) = zeros;
test_signal(1:N) = zeros;

for i = 1:N_bank
    for j = 1:row
        k = k + 1;
        
        if(strcmp(test, 'sin'))
            test_signal(k) = round(signal(k));
        elseif(strcmp(test, 'const'))
            test_signal(k) = 100;
        elseif(strcmp(test, 'num'))
            test_signal(k) = k - 1;
        end
        
        if(N_bank == 4)
            switch(i)
                case 1
                    ram(j, 1) = test_signal(k);
                case 2
                    ram(j, 3) = test_signal(k);
                case 3
                    ram(j, 2) = test_signal(k);
                case 4
                    ram(j, 4) = test_signal(k);
            end
        else
            error('number ofbank must be equal 4 because of stage writing points bank number must be 1,3,2,4');
        end
    end
end

figure;
plot(time, test_signal);
grid on;

% fft:
temp_fft = fft(test_signal, N)/N;
cnt = 1;

ram_fft(1:row, 1:N_bank) = zeros;
for i = 1:row
    ram_fft(i, 1:4) = real(temp_fft((1 + (i-1)*4) : (4*i))) -...
                      imag(temp_fft((1 + (i-1)*4) : (4*i)));
    cnt = cnt + 1;
end
clear cnt;

%{
% fft:
% 1 stage
ram_buf(1:row, 1:N_bank) = zeros;
for i = 1:row
   ram_buf(i,:) = fft_but4(ram(i,:), N, i-1);
end

ram(1:4, 1:4) =     [ram_buf(1:4,   1), ram_buf(1:4,   2), ram_buf(1:4,   3), ram_buf(1:4,   4)];
ram(5:8, 1:4) =     [ram_buf(5:8,   2), ram_buf(5:8,   3), ram_buf(5:8,   4), ram_buf(5:8,   1)];
ram(9:12, 1:4) =    [ram_buf(9:12,  3), ram_buf(9:12,  4), ram_buf(9:12,  1), ram_buf(9:12,  2)];
ram(13:16, 1:4) =	[ram_buf(13:16, 4), ram_buf(13:16, 1), ram_buf(13:16, 2), ram_buf(13:16, 3)];

clear ram_buf;
ram_buf(1:4, 1:4) =     [ram(1:4, 1), ram(5:8, 4), ram(9:12, 3), ram(13:16, 2)];
ram_buf(5:8, 1:4) =     [ram(1:4, 2), ram(5:8, 1), ram(9:12, 4), ram(13:16, 3)];
ram_buf(9:12, 1:4) =    [ram(1:4, 3), ram(5:8, 2), ram(9:12, 1), ram(13:16, 4)];
ram_buf(13:16, 1:4) =   [ram(1:4, 4), ram(5:8, 3), ram(9:12, 2), ram(13:16, 1)];

ram = ram_buf;

% 2 stage
clear ram_buf;
ram_buf(1:row, 1:N_bank) = zeros;
cnt = 0;
for i = 1:row 
   ram_buf(i,:) = fft_but4(ram(i,:), N/4, cnt);
   
   if(cnt == 3)
       cnt = 0;
   else
       cnt = cnt + 1;
   end
end

for i = 1:4
    t = (i-1)*4;
    
    ram(1+t, 1:4) = [ram_buf(1+t, 1), ram_buf(1+t, 2), ram_buf(1+t, 3), ram_buf(1+t, 4)];
    ram(2+t, 1:4) = [ram_buf(2+t, 2), ram_buf(2+t, 3), ram_buf(2+t, 4), ram_buf(2+t, 1)];
    ram(3+t, 1:4) = [ram_buf(3+t, 3), ram_buf(3+t, 4), ram_buf(3+t, 1), ram_buf(3+t, 2)];
    ram(4+t, 1:4) = [ram_buf(4+t, 4), ram_buf(4+t, 1), ram_buf(4+t, 2), ram_buf(4+t, 3)];
end

clear ram_buf;
ram_buf(1:row, 1:N_bank) = zeros;

for i = 1:4
    t = (i-1)*4;
    
    ram_buf(1+t, 1:4) = [ram(1+t, 1), ram(2+t, 4), ram(3+t, 3), ram(4+t, 2)];
    ram_buf(2+t, 1:4) = [ram(1+t, 2), ram(2+t, 1), ram(3+t, 4), ram(4+t, 3)];
    ram_buf(3+t, 1:4) = [ram(1+t, 3), ram(2+t, 2), ram(3+t, 1), ram(4+t, 4)];
    ram_buf(4+t, 1:4) = [ram(1+t, 4), ram(2+t, 3), ram(3+t, 2), ram(4+t, 1)];
end
    
ram = ram_buf;

% 3 stage
clear ram_buf;
ram_buf(1:row, 1:N_bank) = zeros;
for i = 1:row 
   ram_buf(i,:) = fft_but4(ram(i,:), N/4/4, 4);
end

re = real(ram_buf);
im = imag(ram_buf);
%}
  
% fht:
ram_buf(1:row, 1:N_bank) = zeros;  % 0 stage
for i = 1:row
   temp = fht_double_but([ram(i, 1), ram(i, 2), 0],...
                         [ram(i, 3), ram(i, 4), 0], 0, 0, 1);
   ram_buf(i, :) = [temp(1), temp(3), temp(2), temp(4)];
end

ram(1:row, 1:N_bank) = zeros;  % 1 stage
div = N/8;
for i = 1:div
   temp = fht_double_but([ram_buf(i, 1), ram_buf(i, 2), ram_buf(i, 2)],...
                         [ram_buf(i, 3), ram_buf(i, 4), ram_buf(i, 4)], 0, 1, 4);
   ram(i, 1) = temp(1);
   ram(i, 3) = temp(2);
   ram(i + div, 2) = temp(3);
   ram(i + div, 4) = temp(4);
end
for i = (div + 1):(N/N_bank)
   temp = fht_double_but([ram_buf(i, 1), ram_buf(i, 2), ram_buf(i, 2)],...
                         [ram_buf(i, 3), ram_buf(i, 4), ram_buf(i, 4)], 0, 1, 4);
   ram(i - div, 2) = temp(1);
   ram(i - div, 4) = temp(2);
   ram(i, 1) = temp(3);
   ram(i, 3) = temp(4); 
end

ram_buf(1:row, 1:N_bank) = zeros;  % 2 stage
div = N/16;
for j = 1:2
    for i = (1 + (j-1)*2*div):(div + (j-1)*2*div)
        if(j == 1)
            temp = fht_double_but([ram(i, 1), ram(i, 2), ram(i, 2)],...
                                  [ram(i, 3), ram(i, 4), ram(i, 4)], 0, 2, 8);
        else
            temp = fht_double_but([ram(i, 2), ram(i, 1), ram(i, 3)],...
                                  [ram(i, 4), ram(i, 3), ram(i, 1)], 1, 3, 8);
        end
        
        ram_buf(i, 1) = temp(1);
        ram_buf(i, 3) = temp(2);
        ram_buf(i + div, 2) = temp(3);
        ram_buf(i + div, 4) = temp(4);
    end
    for i = (div + 1 + (j-1)*2*div):(2*div + (j-1)*2*div)
        if(j == 1)
            temp = fht_double_but([ram(i, 1), ram(i, 2), ram(i, 2)],...
                                  [ram(i, 3), ram(i, 4), ram(i, 4)], 0, 2, 8);
        else
            temp = fht_double_but([ram(i, 2), ram(i, 1), ram(i, 3)],...
                                  [ram(i, 4), ram(i, 3), ram(i, 1)], 1, 3, 8);
        end
        
        ram_buf(i - div, 2) = temp(1);
        ram_buf(i - div, 4) = temp(2);
        ram_buf(i, 1) = temp(3);
        ram_buf(i, 3) = temp(4); 
    end  
end

ram(1:row, 1:N_bank) = zeros;  % 3 stage
div = N/32;
for j = 1:4
    for i = (1 + (j-1)*2*div):(div + (j-1)*2*div)
        switch(j)
            case 1
                temp = fht_double_but([ram_buf(i, 1), ram_buf(i, 2), ram_buf(i, 2)],...
                                      [ram_buf(i, 3), ram_buf(i, 4), ram_buf(i, 4)], 0, 4, 16);
            case 2
                temp = fht_double_but([ram_buf(i, 2), ram_buf(i, 1), ram_buf(i, 3)],...
                                      [ram_buf(i, 4), ram_buf(i, 3), ram_buf(i, 1)], 2, 6, 16);
            case 3
                temp = fht_double_but([ram_buf(i, 1), ram_buf(i, 2), ram_buf(i + 2*div, 3)],...
                                      [ram_buf(i, 3), ram_buf(i, 4), ram_buf(i + 2*div, 1)], 1, 5, 16);
            case 4
                temp = fht_double_but([ram_buf(i, 2), ram_buf(i, 1), ram_buf(i - 2*div, 4)],...
                                      [ram_buf(i, 4), ram_buf(i, 3), ram_buf(i - 2*div, 2)], 3, 7, 16);
        end
        
        ram(i, 1) = temp(1);
        ram(i, 3) = temp(2);
        ram(i + div, 2) = temp(3);
        ram(i + div, 4) = temp(4);
    end
    for i = (div + 1 + (j-1)*2*div):(2*div + (j-1)*2*div)
        switch(j)
            case 1
                temp = fht_double_but([ram_buf(i, 1), ram_buf(i, 2), ram_buf(i, 2)],...
                                      [ram_buf(i, 3), ram_buf(i, 4), ram_buf(i, 4)], 0, 4, 16);
            case 2
                temp = fht_double_but([ram_buf(i, 2), ram_buf(i, 1), ram_buf(i, 3)],...
                                      [ram_buf(i, 4), ram_buf(i, 3), ram_buf(i, 1)], 2, 6, 16);
            case 3
                temp = fht_double_but([ram_buf(i, 1), ram_buf(i, 2), ram_buf(i + 2*div, 3)],...
                                      [ram_buf(i, 3), ram_buf(i, 4), ram_buf(i + 2*div, 1)], 1, 5, 16);
            case 4
                temp = fht_double_but([ram_buf(i, 2), ram_buf(i, 1), ram_buf(i - 2*div, 4)],...
                                      [ram_buf(i, 4), ram_buf(i, 3), ram_buf(i - 2*div, 2)], 3, 7, 16);
        end
        
        ram(i - div, 2) = temp(1);
        ram(i - div, 4) = temp(2);
        ram(i, 1) = temp(3);
        ram(i, 3) = temp(4); 
    end  
end

ram_buf(1:row, 1:N_bank) = zeros;  % 4 stage
div = N/64;

sector_size = 1;
sector_cnt = 2;

cos_cnt = 0;
bit_depth = 4; % = number of stage (0..n)

for j = 1:8
    cur_cos_0 = bin2dec(fliplr(dec2bin(cos_cnt, bit_depth)));
    cur_cos_1 = bin2dec(fliplr(dec2bin(cos_cnt + 1, bit_depth)));
    
    for i = (1 + (j-1)*2*div):(2*div + (j-1)*2*div) %(div + (j-1)*2*div)
        if(j == 1)
            temp = fht_double_but([ram(i, 1), ram(i, 2), ram(i, 2)],...
                                  [ram(i, 3), ram(i, 4), ram(i, 4)], cur_cos_0, cur_cos_1, 32);   
        elseif(j == 2)
            temp = fht_double_but([ram(i, 2), ram(i, 1), ram(i, 3)],...
                                  [ram(i, 4), ram(i, 3), ram(i, 1)], cur_cos_0, cur_cos_1, 32);
        elseif(mod(j, 2) == 1)
            temp = fht_double_but([ram(i, 1), ram(i, 2), ram(i + sector_cnt*2*div, 3)],...
                                  [ram(i, 3), ram(i, 4), ram(i + sector_cnt*2*div, 1)],...
                                   cur_cos_0, cur_cos_1, 32);
        else
            temp = fht_double_but([ram(i, 2), ram(i, 1), ram(i + sector_cnt*2*div, 4)],...
                                  [ram(i, 4), ram(i, 3), ram(i + sector_cnt*2*div, 2)],...
                                   cur_cos_0, cur_cos_1, 32);
        end
        
        if(i > (div + (j-1)*2*div))
            ram_buf(i - div, 2) = temp(1);
            ram_buf(i - div, 4) = temp(2);
            ram_buf(i, 1) = temp(3);
            ram_buf(i, 3) = temp(4); 
        else
            ram_buf(i, 1) = temp(1);
            ram_buf(i, 3) = temp(2);
            ram_buf(i + div, 2) = temp(3);
            ram_buf(i + div, 4) = temp(4);
        end
        
        cos_cnt = cos_cnt + 1; % step ?
    end
    
    if((sector_cnt == -(sector_size - 1)) && (j >= 2))
        sector_size = 2*sector_size;
        sector_cnt = sector_size - 1;
    else
        sector_cnt = sector_cnt - 2;
    end
end

ram(1:row, 1:N_bank) = zeros;  % 5 stage
div = N/128;

sector_size = 1;
sector_cnt = 2;

cos_cnt = 0;
bit_depth = 5; % = number of stage (0..n)

for j = 1:16
    cur_cos_0 = bin2dec(fliplr(dec2bin(cos_cnt, bit_depth)));
    cur_cos_1 = bin2dec(fliplr(dec2bin(cos_cnt + 1, bit_depth)));
    
    for i = (1 + (j-1)*2*div):(2*div + (j-1)*2*div) %(div + (j-1)*2*div)
        if(j == 1)
            temp = fht_double_but([ram_buf(i, 1), ram_buf(i, 2), ram_buf(i, 2)],...
                                  [ram_buf(i, 3), ram_buf(i, 4), ram_buf(i, 4)], cur_cos_0, cur_cos_1, 64);   
        elseif(j == 2)
            temp = fht_double_but([ram_buf(i, 2), ram_buf(i, 1), ram_buf(i, 3)],...
                                  [ram_buf(i, 4), ram_buf(i, 3), ram_buf(i, 1)], cur_cos_0, cur_cos_1, 64);
        elseif(mod(j, 2) == 1)
            temp = fht_double_but([ram_buf(i, 1), ram_buf(i, 2), ram_buf(i + sector_cnt*2*div, 3)],...
                                  [ram_buf(i, 3), ram_buf(i, 4), ram_buf(i + sector_cnt*2*div, 1)],...
                                   cur_cos_0, cur_cos_1, 64);
        else
            temp = fht_double_but([ram_buf(i, 2), ram_buf(i, 1), ram_buf(i + sector_cnt*2*div, 4)],...
                                  [ram_buf(i, 4), ram_buf(i, 3), ram_buf(i + sector_cnt*2*div, 2)],...
                                   cur_cos_0, cur_cos_1, 64);
        end
        
%         if(i > (div + (j-1)*2*div))
%             ram(i - 0, 2) = temp(1);
%             ram(i - 0, 4) = temp(2);
%             ram(i, 1) = temp(3);
%             ram(i, 3) = temp(4); 
%         else
            ram(i, 1) = temp(1);
            ram(i, 2) = temp(2);
            ram(i, 3) = temp(3);
            ram(i, 4) = temp(4);
%         end
        
        cos_cnt = cos_cnt + 2;
    end
    
    if((sector_cnt == -(sector_size - 1)) && (j >= 2))
        sector_size = 2*sector_size;
        sector_cnt = sector_size - 1;
    else
        sector_cnt = sector_cnt - 2;
    end
end