clear;
clc;

Nx = 6;
Nh = 3;

N = Nx + Nh - 1;

x(1 : 12) = [1, 3, 2, -3, 0, 2, -1, 0, -2, 3, -2, 1];
h(1 : Nh) = [1, 0, 1];

h_temp(1 : Nh) = h(1 : Nh);
h_temp(Nh + 1 : N) = zeros;

dht_h = dht(h_temp, N);

y_old(1 : Nh - 1) = zeros;

for i = 1:1:round((length(x)/Nx))
    low = Nx*(i - 1) + 1;
    high = i*Nx;
    
    x_temp(1 : Nx) = x(low : high);
    x_temp(Nx + 1 : N) = zeros;
    
	dht_x = dht(x_temp, N);
    
    dht_y = 0.5*(dht_x.*dht_h + dht_x.*wrev(dht_h) + wrev(dht_x).*dht_h - wrev(dht_x).*wrev(dht_h));
    idht_y = idht(dht_y, N);
    
    y_new(1 : Nh - 1) = idht_y(1 : Nh - 1) + y_old(1 : Nh - 1);
    y_new(Nh : Nx) = idht_y(Nh : Nx);
    
    y_old = idht_y(Nx + 1 : N);
    
    y_out_dht(low : high) = y_new;
end

h_temp(1 : Nh) = round(h(1 : Nh));
h_temp(Nh + 1 : N) = zeros;

fft_h = fft(h_temp, N);

y_old(1 : Nh - 1) = zeros;

for i = 1:1:round((length(x)/Nx))
    low = Nx*(i - 1) + 1;
    high = i*Nx;
    
    x_temp(1 : Nx) = x(low : high);
    x_temp(Nx + 1 : N) = zeros;
    
	fft_x = fft(x_temp, N);
    
    fft_y = fft_x.*fft_h;
    ifft_y = ifft(fft_y, N);
    
    y_new(1 : Nh - 1) = ifft_y(1 : Nh - 1) + y_old(1 : Nh - 1);
    y_new(Nh : Nx) = ifft_y(Nh : Nx);
    
    y_old = ifft_y(Nx + 1 : N);
    
    y_out_fft(low : high) = y_new;
end