clear all;
clc;

load samplerate.mat;
fs = 40;
N = 40;

w = fftshift((0:N-1)/N*2*pi);
w(1:N/2) = w(1:N/2) - 2*pi; % get freq in radians
x_w = fftshift(fft(x));
t = linspace(0,N-1,N) * 1/fs;
w = 40 * w/(2*pi);
figure;
subplot(211);
plot(w,abs(x_w));
title('fs = 40 magnitude plot');
xlabel('omega');
ylabel('magnitude');
subplot(212);
stem(t,x);
title('fs = 40 time plot');
xlabel('time');
ylabel('magnitude');


x_up = upsample(x,3);
x_up_w = fftshift(fft(x_up));
N = length(x_up);
t = linspace(0,N-1,N) .* 1/N;
w = fftshift((0:N-1)/N*2*pi);
w(1:N/2) = w(1:N/2) - 2*pi; 
w = 120 * w/(2*pi);
figure;
subplot(211);

plot(w,abs(x_up_w));
title('fs = 120 magnitude plot');
xlabel('omega');
ylabel('magnitude');
subplot(212);
stem(t,x_up);
title('fs = 120 time plot');
xlabel('time');
ylabel('magnitude');

for i = 1:length(x_up)
    if(abs(w(i)) > 25)
        x_up_w(i) = 0;
    end
end
figure;
subplot(211);
plot(w,abs(x_up_w));
title('fs = 120 filtered magnitude plot');
xlabel('omega');
ylabel('magnitude');
subplot(212);
x_up = ifft(ifftshift(x_up_w));
plot(t,abs(x_up));
title('fs = 120 filtered time plot');
xlabel('time');
ylabel('magnitude');

x_down = downsample(x_up,2);
N = N/2;
t = linspace(0,N-1,N)/N;
w = fftshift((0:N-1)/N*2*pi);
w(1:N/2) = w(1:N/2) - 2*pi;
w = N * w/(2*pi);
figure;
subplot(211);
plot(t,abs(x_down));
title('fs = 60 filtered time plot');
xlabel('time');
ylabel('magnitude');
subplot(212);
plot(w,abs(fftshift(fft(x_down))));
title('fs = 60 filtered magnitude plot');
xlabel('omega');
ylabel('magnitude');