clc;
clear all;
x = [1 1 4 -4 -3 2 5 -6 3 2 4 -2 5 9 -8 4]';
F = dftmtx(length(x));
Fh = (1/length(x))*F';
A = Fh*F;
figure;
subplot(211);
plot(abs(A));
subplot(212);
plot(angle(A));

figure;
imagesc(abs(A));