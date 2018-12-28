clear all;
clc;

load q2_signal.mat;

soundsc(x,fs);

s1 = spectrogram(x,hamming(256),128);
figure;
imagesc(abs(s1));
title('original spectrogram');
xlabel('sample number (n)');
ylabel('frequency in Hertz')

% end part 1
xodd = x(1:2:length(x));
soundsc(xodd,fs);
s2 = spectrogram(xodd,hamming(256),128);
figure;
imagesc(abs(s2));
title('badly downsampled spectrogram');
xlabel('sample number (n)');
ylabel('frequency in Hertz')
% end part 2

N = length(x);

x_w = fftshift(fft(x));

w = fftshift((0:N-1)/N*2*pi);
w(1:N/2) = w(1:N/2) - 2*pi; % get freq in radians
for i = 1:length(x) %lpf x_w
    if(abs(w(i)) < pi/2)
        x_w(i) = x_w(i);
    else
        x_w(i) = 0;
    end
    
end
xright = ifft(ifftshift(x_w));
xright = downsample(xright,2);
soundsc(xright,fs);
s3 = spectrogram(xright,hamming(256),128);
figure;
imagesc(abs(s3));
title('correctly downsampled spectrogram');
xlabel('sample number (n)');
ylabel('frequency in Hertz')