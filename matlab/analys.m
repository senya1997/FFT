clear;
close all;
clc;

fprintf('\n\tStart\n\n');

a_re(1:2048) = zeros;
a_im(1:2048) = zeros;
b_re(1:2048) = zeros;
b_im(1:2048) = zeros;

fprintf('reading file...\n');

ram_a_re = load('D:\SS\fpga\modelsim\fft\ram_a_re.txt');
ram_a_im = load('D:\SS\fpga\modelsim\fft\ram_a_im.txt');
ram_b_re = load('D:\SS\fpga\modelsim\fft\ram_b_re.txt');
ram_b_im = load('D:\SS\fpga\modelsim\fft\ram_b_im.txt');

for i = 1:2048
   ind =  bitget(i - 1, 1)*2^10 + bitget(i - 1, 2)*2^9 + bitget(i - 1, 3)*2^8 +...
        + bitget(i - 1, 4)*2^7 + bitget(i - 1, 5)*2^6 + bitget(i - 1, 6)*2^5 +...
        + bitget(i - 1, 7)*2^4 + bitget(i - 1, 8)*2^3 + bitget(i - 1, 9)*2^2 +...
        + bitget(i - 1, 10)*2^1 + bitget(i - 1, 11)*2^0;
   
   %fprintf('ind = %4d\ti = %4d\n', ind, i - 1);
   
   a_re(i) = ram_a_re(ind + 1);
   a_im(i) = ram_a_im(ind + 1);
   b_re(i) = ram_b_re(ind + 1);
   b_im(i) = ram_b_im(ind + 1);
end


a_re = a_re';
a_im = a_im';
b_re = b_re';
b_im = b_im';

afc_a = sqrt(a_re.^2 + a_im.^2);
afc_b = sqrt(b_re.^2 + b_im.^2);

half_afc_a_1 = afc_a(1:1024);
half_afc_a_2 = afc_a(1025:2048);

sub(1:1024) = zeros;
for i = 1:1024
  sub(i) = half_afc_a_1(i) - half_afc_a_2(i);
end

fprintf('building graph...\n');
    figure;    
    plot(afc_a);
    title('AFC from RAM "A":');
    grid on;

    figure;
    plot(afc_b);
    title('AFC from RAM "B":');
    grid on;

    
    figure;
    plot(afc_a + afc_b);
    title('AFC:');
    grid on; 
    

x(1:2048) = zeros;
time = 0;

for i = 1:2048
    %x(i) = 10*sin(2*3.14*2000*time);
    %x(i) = 10*(sin(i) + sin(2*time) + sin(3*time)); 
    x(i) = 100;
    
    time = time + 1;
end
   
y = fft(x, 2048);
Pyy = y.*conj(y)/2048;
%f = 

    figure;
    plot(Pyy);
    title('ref AFC:');
    grid on; 
 
    figure;
    plot(x);
    title('x:');
    grid on; 
    
fprintf('\n\tComplete\n');