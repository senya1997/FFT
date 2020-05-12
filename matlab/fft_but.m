function fft_but = fft_but(x, N, n) % length 'x' = 4: DFT-4

but_re(1) = (real(x(1)) + real(x(2)) + real(x(3)) + real(x(4)))/4;
but_re(2) = (real(x(1)) + imag(x(2)) - real(x(3)) - imag(x(4)))/4;
but_re(3) = (real(x(1)) - real(x(2)) + real(x(3)) - real(x(4)))/4;
but_re(4) = (real(x(1)) - imag(x(2)) - real(x(3)) + imag(x(4)))/4;

but_im(1) = (imag(x(1)) + imag(x(2)) + imag(x(3)) + imag(x(4)))/4;
but_im(2) = (imag(x(1)) - real(x(2)) - imag(x(3)) + real(x(4)))/4;
but_im(3) = (imag(x(1)) - imag(x(2)) + imag(x(3)) - imag(x(4)))/4;
but_im(4) = (imag(x(1)) + real(x(2)) - imag(x(3)) - real(x(4)))/4;

w(1) = cos(0*n*(2*pi/N)) - 1i*sin(0*n*(2*pi/N));
w(2) = cos(1*n*(2*pi/N)) - 1i*sin(1*n*(2*pi/N));
w(3) = cos(2*n*(2*pi/N)) - 1i*sin(2*n*(2*pi/N));
w(4) = cos(3*n*(2*pi/N)) - 1i*sin(3*n*(2*pi/N));

fft_but(1) = but_re(1) + 1i*but_im(1);
fft_but(2) = but_re(2) + 1i*but_im(2);
fft_but(3) = but_re(3) + 1i*but_im(3);
fft_but(4) = but_re(4) + 1i*but_im(4);

fft_but(1) = fft_but(1)*w(1);
fft_but(2) = fft_but(2)*w(2);
fft_but(3) = fft_but(3)*w(3);
fft_but(4) = fft_but(4)*w(4);