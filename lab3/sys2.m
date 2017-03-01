function [ y_n ] = sys2( x_n, a )
N = 64; % length always 64
y_n = zeros(1,N+1);

for i = 1:64,
    y_n(i+1) = a*y_n(i) + x_n(i).^2;
end
    y_n = y_n(2:length(y_n)); % remove first element to shorten to 64
    
    figure;
    stem(y_n);
    title('difference equation with a = 2');
    xlabel('n');
    ylabel('y(n)');
end

