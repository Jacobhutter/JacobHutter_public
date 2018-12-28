function [ Y ] = compMeanVec( X )
[height,width] = size(X);
sum = zeros(1,width);
for i=1:height
    sum = sum + X(i,:);
end
sum = sum/height;
Y = sum;
end

