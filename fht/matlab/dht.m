function dht = dht(x, N)

H(1:N) = zeros;

for k = 1:N
    for n = 1:N
        H(k) = H(k) + x(n)*2^(1/2)*cos(2*pi*(n-1)*(k-1)/N - pi/4)/N;
    end
end
    
dht = H;