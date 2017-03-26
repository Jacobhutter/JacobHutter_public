
y = load('speechsig.mat');
x = y.x;
xnoise = y.xnoise;

N = length(xnoise);
w = fftshift((0:N-1)/N*2*pi); % define omega as you would for FFT
w(1:N/2) = w(1:N/2) - 2*pi;   %

xnoisew = fftshift(fft(xnoise));

h = hamming(N);
xnoisewh = xnoisew .* h;

xnoise = ifft(ifftshift(xnoisewh),N);
%soundsc(real(xnoise));

r = zeros(N,1);
r(2000:4999,1) = rectwin(3000);

xnoisewr = xnoisew .* r;
plot(abs(xnoisew));
xnoise = ifft(ifftshift(xnoisewr));


%soundsc(real(xnoise));
