function [  ] = filters(N,wc,w0 )
    d = zeros(1,N*2 + 1);
    d(N+1) = 1; % delta function
    n = N*2+1;
    w = fftshift((0:n-1)/n*2*pi);
    w(1:n/2) = w(1:n/2) - 2*pi;
    N = linspace(-N,N,(N*2)+1); % create -N to N array 
    lpi = (wc/pi).*sinc(wc.*N./pi);
    lpm = fftshift(fft(lpi));
    hpi = d-lpi;
    hpm = fftshift(fft(hpi));
    bpi = cos(w0.*N).*lpi;
    bpm = fftshift(fft(bpi));
    
    figure;
    subplot(211);
    stem(N,lpi);
    title('Low Pass Filter impulse Response');
    ylabel('h[n]');
    xlabel('n');
    subplot(212);
    plot(w,abs(lpm));
    title('Low Pass Filter Magnitude Response');
    ylabel('|Hd(w)|');
    xlabel('w');
    
    figure;
    subplot(211);
    stem(N,hpi);
    title('High Pass Filter impulse Response');
    ylabel('h[n]');
    xlabel('n');
    subplot(212);
    plot(w,abs(hpm));
    title('High Pass Filter Magnitude Response');
    ylabel('|Hd(w)|');
    xlabel('w');
    
    figure;
    subplot(211);
    stem(N,bpi);
    title('Band Pass Filter impulse Response');
    ylabel('h[n]');
    xlabel('n');
    subplot(212);
    plot(w,abs(bpm));
    title('Band Pass Filter Magnitude Response');
    ylabel('|Hd(w)|');
    xlabel('w');
end

