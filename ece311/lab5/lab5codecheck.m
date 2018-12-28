clc, clear all, close all

x1 = [1,5,2,4,3,5];
score = 5;
X1 = myFFT(x1);
X1_ = fft(x1);
tol = 1e-5;
if(norm(X1-X1_) > tol)
    score = score + 0;
else
    score = score + 30;
end

x2 = [1,2,3,2,2];
X2 = myFFT(x2);
X2_ = fft(x2);
if(norm(X2-X2_) > tol)
    score = score + 0;
else
    score = score + 30;
end

figure;
subplot(211);
k1 = 0:length(X1)-1;
stem(k1,real(X1),'k','linewidth',3);
title(['Score: ',num2str(score)],'fontsize',14);
hold on;
plot(k1,real(X1_),'k--','linewidth',3);
stem(k1,imag(X1),'r','linewidth',3);
plot(k1,imag(X1_),'r--','linewidth',3);
legend('Real','Real','Imag','Imag');
hold off;
subplot(212);
k2 = 0:length(X2)-1;
stem(k2,real(X2),'k','linewidth',3);
hold on;
plot(k2,real(X2_),'k--','linewidth',3);
stem(k2,imag(X2),'r','linewidth',3);
plot(k2,imag(X2_),'r--','linewidth',3);
legend('Real','Real','Imag','Imag');
hold off;

