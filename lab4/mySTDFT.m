function [a, b, c] = mySTDFT(x, M, D, P, f_s )
a_dim1 = ceil(P/2);
a_dim2 = floor(((length(x) - M)/D) + 1);
dft_mat = zeros(a_dim1,a_dim2);
time_shifts = zeros(1,a_dim2);
for i=1:a_dim2,
    time_shifts(i) = (i*D)/f_s; % vector of shifts 
    time_slice = x((1+D*(i-1)):(((i-1)*D)+M)); % get time slice 
    time_slice = fft(time_slice,P); % dft zero padded to P 
    time_slice = time_slice(1,1:a_dim1); % only take half of P 
    dft_mat(:,i) = time_slice; %assign column in dft_mat
end
    a = dft_mat; % output 1 
    b = linspace(0,f_s,a_dim1); % output 2 
    c = time_shifts; % output 3
    imagesc(c,b,abs(a));
    ylabel('Frequency');
    xlabel('Time');
    str = sprintf('Spectrogram at M = %f',M);
    title(str);
end

