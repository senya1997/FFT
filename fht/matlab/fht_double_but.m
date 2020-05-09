function fht_double_but = fht_double_but(x, y, n_x, n_y, N) % length 'x' = 8: double DHT-4


% test mixers:
%{
fht_double_but(1) = x(1);
fht_double_but(2) = x(2);

fht_double_but(3) = y(1);
fht_double_but(4) = y(2);
%}

fht_double_but(1) = (x(1) + cos(n_x*(2*pi/N))*x(2) + sin(n_x*(2*pi/N))*x(3))/2;
fht_double_but(2) = (x(1) - cos(n_x*(2*pi/N))*x(2) - sin(n_x*(2*pi/N))*x(3))/2;

fht_double_but(3) = (y(1) + cos(n_y*(2*pi/N))*y(2) + sin(n_y*(2*pi/N))*y(3))/2;
fht_double_but(4) = (y(1) - cos(n_y*(2*pi/N))*y(2) - sin(n_y*(2*pi/N))*y(3))/2;
