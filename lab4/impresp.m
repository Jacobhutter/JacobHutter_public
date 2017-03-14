load impulseresponse.mat
% variable name is h 
figure;
subplot
subplot(311);
stem(h);
n = 74;
w = fftshift((0:n-1)/n*2*pi);
w(1:n/2) = w(1:n/2) - 2*pi;
title('Impulse Response of h');
xlabel('n');
ylabel('h[n]');
subplot(312);
h_m = abs(fftshift(fft(h)));
h_m = mag2db(h_m);
plot(w,h_m);
title('Magnitude Response of h');
xlabel('w');
ylabel('db');
subplot(313);
h_p = angle(fftshift(fft(h)));
plot(w,h_p);
title('Phase Response of h');
xlabel('w');
ylabel('angle of Hd(w)');

%find pass band ripple
top = max(h_m);
bottom_range = h_m(28:48);
bottom = min(bottom_range);
passband_ripple = top - bottom;
% result is 8.0126
%passband edge is approximately .75 rad to 1.25 rad so .5 rad

