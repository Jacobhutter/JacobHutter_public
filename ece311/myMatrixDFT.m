function [ K ] = myMatrixDFT(x_n)
Z = zeros(size(x_n,2),size(x_n,2));
for i=1:size(x_n,2),
    for j = 1:size(x_n,2),
    Z(j,i) = exp(-1i*2*pi*(j-1)*(i-1)/size(x_n,2));
    end
end
K = x_n*Z;
end

