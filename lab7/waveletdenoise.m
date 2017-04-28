clc, clear all, close all

[xorig,fs] = audioread('original.wav');
[xnoise,fs] = audioread('noisy.wav');

wname = 'db1';
a1thresh = 0.0; % Must be positive.
d1thresh = 0.0; % Must be positive.
a2thresh = 0.0; % Must be positive.
d2thresh = 0.0; % Must be positive.
a3thresh = 0.0; % Must be positive.
d3thresh = 0.0; % Must be positive.
a4thresh = 0.0; % Must be positive.
d4thresh = 0.0; % Must be positive.
a5thresh = 0.0; % Must be positive.
d5thresh = 0.0; % Must be positive.

% DWT
x = xnoise;
[a1,d1] = dwt(x,wname);
[a2,d2] = dwt(a1,wname);
[a3,d3] = dwt(a2,wname);
[a4,d4] = dwt(a3,wname);
[a5,d5] = dwt(a4,wname);

% Inverse DWT
a5_ = (abs(a5)>a5thresh).*a5;
d5_ = (abs(d5)>d5thresh).*d5;
a4t = idwt(a5_,d5_,wname);
a4_ = (abs(a4t)>a4thresh).*a4t;
d4_ = (abs(d4)>d4thresh).*d4;
a3t = idwt(a4_,d4_,wname);
a3_ = (abs(a3t)>a3thresh).*a3t;
d3_ = (abs(d3)>d3thresh).*d3;
a2t = idwt(a3_,d3_,wname);
a2_ = (abs(a2t)>a2thresh).*a2t;
d2_ = (abs(d2)>d2thresh).*d2;
a1t = idwt(a2_,d2_,wname);
a1_ = (abs(a1t)>a1thresh).*a1t;
d1_ = (abs(d1)>d1thresh).*d1;
x_ = idwt(a1_,d1_,wname);

% Output
figure;
subplot(221); stem(a5); title('a5','fontsize',14);
subplot(222); stem(d5); title('d5','fontsize',14);
subplot(223); stem(a5_); title('a5 filtered','fontsize',14);
subplot(224); stem(d5_); title('d5 filtered','fontsize',14);
figure;
subplot(221); stem(a4); title('a4','fontsize',14);
subplot(222); stem(d4); title('d4','fontsize',14);
subplot(223); stem(a4_); title('a4 filtered','fontsize',14);
subplot(224); stem(d4_); title('d4 filtered','fontsize',14);
figure;
subplot(221); stem(a3); title('a3','fontsize',14);
subplot(222); stem(d3); title('d3','fontsize',14);
subplot(223); stem(a3_); title('a3 filtered','fontsize',14);
subplot(224); stem(d3_); title('d3 filtered','fontsize',14);
figure;
subplot(221); stem(a2); title('a2','fontsize',14);
subplot(222); stem(d2); title('d2','fontsize',14);
subplot(223); stem(a2_); title('a2 filtered','fontsize',14);
subplot(224); stem(d2_); title('d2 filtered','fontsize',14);
figure;
subplot(221); stem(a1); title('a1','fontsize',14);
subplot(222); stem(d1); title('d1','fontsize',14);
subplot(223); stem(a1_); title('a1 filtered','fontsize',14);
subplot(224); stem(d1_); title('d1 filtered','fontsize',14);

E = norm(x_ - xorig)/norm(xorig)*100;
disp(['Percent Relative Error: ', num2str(E)]);
soundsc(x_,fs);