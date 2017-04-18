function [ Y ] = compMeanVec( X )

sum = zeros(1,4800);
for i=1:165
    sum = sum + X(i,:);
end
sum = sum/165;
Y = sum;
end

