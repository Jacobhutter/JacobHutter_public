function [ y ] = myDFTConv( x, h )

%transfer over to frequency domain
l = size(x,2) + size(h,2) - 1;
x_w = fft(x,l);
h_w = fft(h,l);

%element multiplication to get y_w
y_w = x_w.*h_w;

%return to discrete domain
y = ifft(y_w);

%plot my result
figure;
subplot(211);
stem(y);
title('myDFTConv');

%plot key 
subplot(212);
stem(conv(x,h));
title('conv(x,h)');


end

