
[y fs] = audioread('sound1.wav');

N = length(y);
w = fftshift((0:N-1)/N*2*pi); % define omega as you would for FFT
w(1:N/2) = w(1:N/2) - 2*pi;   %
y_w = fftshift(fft(y));
figure;
plot(w,abs(y_w));
ylabel('magnitude');
xlabel('radians');
title('magnitude spectrum of sound1.wav before filter');
m = 5000;
d = 5;
p = 1024;
mySTDFT(y',m,d,p,fs);
        
        
        
f= [0 .4 .5 1];
a = [1 1 0 0];
b = firpm(50,f,a);
b_w = fftshift(fft(b,length(y)))'; % get filter

y_w = b_w .* y_w; % apply filter
figure;
plot(w,abs(y_w));
ylabel('magnitude');
xlabel('radians');
title('magnitude spectrum of sound1.wav after filter');

y = ifft(ifftshift(y_w));
soundsc(y);
filename = 'filtered1.wav';
audiowrite(filename,y,fs);
mySTDFT(y',m,d,p,fs);
