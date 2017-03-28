y = load('speechsig.mat');
x = y.x;
xnoise = y.xnoise;

N = 128; % fft length
w1 = hamming(N);
w2 = rectwin(N);
m = 2; % step size of 2
dim1 = floor(length(xnoise) / N) + 3383; % just found the biggest value i could until breaking it
spec1 = zeros((N/2 +1),dim1);
spec2 = zeros((N/2 +1),dim1);
for i=1:dim1
xi = xnoise(((i-1)*m+1):(i-1)*m+N);
inner2 = xi .* w2;
inner = xi .* w1; % multiply by window
inner = fft(inner); % take fft
inner2 = fft(inner2);
inner = inner(1:N/2 + 1);  % only take first n/2 + 1 elems
inner2 = inner2(1:N/2+1);
outer = abs(inner); % take abs value
outer2 = abs(inner2);
spec1(:,i) = outer;
spec2(:,i) = outer2;
end
figure;
imagesc(spec1);
title('Spectrogram using hamming window');
xlabel('Time');
ylabel('Frequency');

figure;
imagesc(spec2);
title('Spectrogram using rectangular window');
xlabel('Time');
ylabel('Frequency');
