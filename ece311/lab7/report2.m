[PHI1,PSI1,t1] = wavefun('coif1',5);
[PHI2,PSI2,t2] = wavefun('db1',5);
[PHI3,PSI3,t3] = wavefun('sym4',5);

w = fftshift((0:511)/512*2*pi);
w(1:512/2) = w(1:512/2) - 2*pi;

PH1w = fftshift(fft(PHI1,512));
PH2w = fftshift(fft(PHI2,512));
PH3w = fftshift(fft(PHI3,512));
PS1w = fftshift(fft(PSI1,512));
PS2w = fftshift(fft(PSI2,512));
PS3w = fftshift(fft(PSI3,512));

figure;
subplot(311);
plot(w,abs(PH1w));
title('Magnitude plot of coif1, db1 and sym4 waves respectively for PHI');

subplot(312);
plot(w,abs(PH2w));
subplot(313);
plot(w,abs(PH3w));


figure;

subplot(311);
plot(w,abs(PS1w));
title('Magnitude plot of coif1, db1 and sym4 waves respectively for PSI');
subplot(312);
plot(w,abs(PS2w));
subplot(313);
plot(w,abs(PS3w));
