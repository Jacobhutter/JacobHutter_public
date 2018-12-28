function [ y_n ] = sys1( a,N )

%get delta function
x_n = zeros(1,N);
x_n(1) = 1;

%get shifted delta function
x_n_1 = zeros(1,N);
x_n_1(2) = 1;

y_n = zeros(1,N+1);

for i = 1:N,
    y_n(i+1) = a.*y_n(i) + 0.3.*x_n(i) -2.*x_n_1(i);
end
y_n = y_n(2:length(y_n)); % remove first element to get to N
figure;
stem(y_n);
title('a = 2, N = 64');
ylabel('y_n');
xlabel('N');
end

