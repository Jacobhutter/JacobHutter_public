t = 0:.01:5.11;
st = t(t<.5); 

PSI_1_0 = sin(2*pi*(st*2 + .5));
PSI_1_0 = PSI_1_0 * 2^(.5);
PSI_1_0(end:512) = 0;
figure;
subplot(411);
plot(t(1:500),PSI_1_0(1:500));
title('PSI_1_0')
xlabel('t(t<5)');
ylabel('PSI_1_0(t(t<5))');

PSI_0_1 = sin(2*pi*(st - 1 + .5));
PSI_0_1(end:512) = 0;
subplot(412);
plot(t(1:500),PSI_0_1(1:500));
title('PSI_0_1')
xlabel('t(t<5)');
ylabel('PSI_0_1(t(t<5))');

PSI_1_1 = sin(2*pi*(st*2 - 1 + .5));
PSI_1_1 = PSI_1_1 * 2^(.5);
PSI_1_1(end:512) = 0;
subplot(413);
plot(t(1:500),PSI_1_1(1:500));
title('PSI_1_1')
xlabel('t(t<5)');
ylabel('PSI_1_1(t(t<5))');

PSI_2_1 = sin(2*pi*(st*4 - 1 + .5));
PSI_2_1 = PSI_2_1 * 2^(1);
PSI_2_1(end:512) = 0;
subplot(414);
plot(t(1:500),PSI_2_1(1:500));
title('PSI_2_1')
xlabel('t(t<5)');
ylabel('PSI_2_1(t(t<5))');

w = fftshift((0:511)/512*2*pi);
w(1:512/2) = w(1:512/2) - 2*pi;

figure;
subplot(411);
plot(w,abs(fftshift(fft(PSI_1_0))));
title('PSI_1_0')
xlabel('w');
ylabel('abs(fft(PSI_1_0))');
subplot(412);
plot(w,abs(fftshift(fft(PSI_0_1))));
title('PSI_0_1')
xlabel('w');
ylabel('abs(fft(PSI_0_1))');
subplot(413);
plot(w,abs(fftshift(fft(PSI_1_1))));
title('PSI_1_1')
xlabel('w');
ylabel('abs(fft(PSI_1_1))');
subplot(414);
plot(w,abs(fftshift(fft(PSI_2_1))));
title('PSI_2_1')
xlabel('w');
ylabel('abs(fft(PSI_2_1))');

figure;
subplot(411);
plot(w,angle(fftshift(fft(PSI_1_0))));
title('PSI_1_0')
xlabel('w');
ylabel('angle(fft(PSI_1_0))');
subplot(412);
plot(w,angle(fftshift(fft(PSI_0_1))));
title('PSI_0_1')
xlabel('w');
ylabel('angle(fft(PSI_0_1))');
subplot(413);
plot(w,angle(fftshift(fft(PSI_1_1))));
title('PSI_1_1')
xlabel('w');
ylabel('angle(fft(PSI_1_1))');
subplot(414);
plot(w,angle(fftshift(fft(PSI_2_1))));
title('PSI_2_1')
xlabel('w');
ylabel('angle(fft(PSI_2_1))');


