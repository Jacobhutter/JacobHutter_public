[y fs] = audioread('sound2.wav');
%soundsc(y);
N = length(y);
w = fftshift((0:N-1)/N*2*pi); % define omega as you would for FFT
w(1:N/2) = w(1:N/2) - 2*pi;   %

yw = fftshift(fft(y));
figure;
plot(w,abs(yw));
title('sound2.wav magnitude response prior to filtering');
xlabel('radians');
ylabel('magnitude');
figure;
m = 5000;
d = 5;
p = 1024;
mySTDFT(y',m,d,p,fs);

f= [0 .1 .2 1];
a = [1 0 0 0];
b = firpm(50,f,a);
b_w = fftshift(fft(b,length(y)))'; % get filter

yw = b_w .* yw; % apply filter
figure;
plot(w,abs(yw));
ylabel('magnitude');
xlabel('radians');
title('magnitude spectrum of sound2.wav after filter');


y = ifft(ifftshift(yw));
figure;
mySTDFT(y',m,d,p,fs);
soundsc(y);
filename = 'filtered2.wav';
audiowrite(filename,y,fs);
