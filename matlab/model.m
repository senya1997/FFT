clear;
close all;
clc;

ram_a_re(1:512, 1:4) = zeros;
ram_a_im(1:512, 1:4) = zeros;

ram_b_re(1:512, 1:4) = zeros;
ram_b_im(1:512, 1:4) = zeros;

time = 0;

for i = 1:4
    for j = 1:512
        %ram_a_re(j, i) = round(32767*(sin(2*3.14*2000*time) + sin(2*3.14*3500*time))/2) - 1;
        %ram_a_re(j, i) = round(32767*sin(2*3.14*2000*time)) - 1;
        ram_a_re(j, i) = 100;
        
        time = time + 1;
    end
end

for i = 1:512
    
end