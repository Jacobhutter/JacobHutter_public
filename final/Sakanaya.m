clear all;
clc;

load signal.mat;

N = length(x);

w = fftshift((0:N-1)/N*2*pi);
w(1:N/2) = w(1:N/2) - 2*pi; % get freq in radians

% using w = Big w * T with T = 1/100, big omega = w * 100 / 2pi 
w = w.*100/(2*pi);

x_w = fftshift(fft(x));

figure;
subplot(211);
plot(w,abs(x_w));
title('Magnitude plot of X(?)');
xlabel('Big Omgega');
ylabel('Magnitude');

subplot(212);
plot(w,angle(x_w));
title('Phase plot of X(?)');
xlabel('Big Omgega');
ylabel('Phase');
