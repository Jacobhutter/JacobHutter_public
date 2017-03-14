N = 25;
M = (N-1)/2;
w = fftshift((0:N-1)/N*2*pi); % 1. define omega as you would for FFT
w(1:N/2) = w(1:N/2) - 2*pi;   %
i=sqrt(-1);
for j=1:N
    if(abs(w(j)) < pi/3), % 2.
        g_w(j) = 1 * exp(-i*M*w(j)); 
    else
        g_w(j) = 0;
    end
end

g_n = ifft(fftshift(g_w)); % 3. find g[n], should be shifted
w_n = hamming(N)'; % window (transposed)
h_n = g_n .* w_n;% h_n is impulse response
figure;
subplot(311);
plot(abs(h_n));
title('Magnitude of h[n]');
xlabel('n');
ylabel('abs(h[n])');
subplot(312);
plot(w,mag2db(abs(fftshift(fft(h_n)))));
title('Magnitude of Hd(w)');
xlabel('w');
ylabel('db');
subplot(313);
plot(w,angle(fftshift(fft(h_n))));
title('Phase of Hd(w)');
xlabel('w');
ylabel('radians');



