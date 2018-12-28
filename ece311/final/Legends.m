clear all;
clc;

load q1_signal.mat;
N = length(x);

w = fftshift((0:N-1)/N*2*pi);
w(1:N/2) = w(1:N/2) - 2*pi; % get freq in radians
w = w';
figure;
subplot(211);
x_w = fftshift(fft(x));
plot(w,abs(x_w));
title('Magnitude of X(w)');
xlabel('w');
ylabel('magnitude');
subplot(212);
plot(w,angle(x_w));
title('Phase of X(w)');
xlabel('w');
ylabel('phase');
%%%%%%%%%%%%%%% end part 1 %%%%%%%%%%%%%

sig_w = fftshift(fft(sig)); 
N2 = length(sig);
w2 = fftshift((0:N2-1)/N2*2*pi);
w2(1:N2/2) = w2(1:N2/2) - 2*pi; % get freq in radians
figure;
subplot(211);
stem(w2,abs(sig_w));
title('Magnitude of SIG(w)');
xlabel('w');
ylabel('magnitude');
subplot(212);
plot(w2,angle(sig_w));
title('Phase of SIG(w)');
xlabel('w');
ylabel('phase');

%%%%%%%% end part 2 %%%%%%%%%%%%%%%% 


% filter x 
for i=1:length(x_w)
    if(w(i) < -2*pi/3 || w(i) > 2*pi/3)
        x_w(i) = 0;
    end
    if(abs(w(i)) < pi/3)
        x_w(i) = 0;
    end
    
end

figure;
subplot(211);
plot(w,abs(x_w));
title('Filtered magnitude X(w)');
xlabel('w');
ylabel('phase');
subplot(212);
plot(w,angle(x_w));
title('Filtered phase X(w)');
xlabel('w');
ylabel('phase');


x_new = ifft(ifftshift(x_w));
figure;
plot(x_new);
title('Filtered X(n)');
xlabel('n');
ylabel('magnitude');

