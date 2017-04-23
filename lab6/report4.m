clc;
clear all;
x = [1 1 4 -4 -3 2 5 -6 3 2 4 -2 5 9 -8 4]';
F = dftmtx(length(x));
X = F*x;
r = real(F);
a = angle(F);
figure;
subplot(211);
plot(r);
title('Real part of F');
ylabel('Amplitude of real');
xlabel('n');
subplot(212);
plot(a);
title('Imaginary part of F');
xlabel('n');
ylabel('Amplitude of imaginary');

figure;
subplot(211);
imagesc(r);
title('plot of real');
subplot(212);
imagesc(a);
title('plot of imaginary');

