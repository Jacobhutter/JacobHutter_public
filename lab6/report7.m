clc;
clear all;
X= loadImages('yalefaces');
Y = compMeanVec(X);
X_hat = zeros(165,4800);
for i=1:165
    X_hat(i,:) = X(i,:) - Y;
end
R = (X_hat')*(X_hat);
[U,S,V] = svd(R);
s = svd(R);
figure;
s = s(1:100,1);
plot(s);
title('Plot of first 100 eigenvalues');


figure;
imagesc(reshape(U(1,:),[60,80]));
title('1st eigenvector');

figure;
imagesc(reshape(U(2,:),[60,80]));
title('2nd eigenvector');

figure;
imagesc(reshape(U(3,:),[60,80]));
title('3rd eigenvector');

figure;
imagesc(reshape(U(4,:),[60,80]));
title('4th eigenvector');

figure;
imagesc(reshape(U(50,:),[60,80]));
title('50th eigenvector');

figure;
imagesc(reshape(U(100,:),[60,80]));
title('100th eigenvector');
