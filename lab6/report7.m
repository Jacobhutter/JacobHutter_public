clc;
clear all;
X= loadImages('yalefaces');
Y = compMeanVec(X);
X_hat = X - Y;
R = (X_hat')*(X_hat);
[U,S,V] = svd(R);
s = svd(R);
figure;
s = s(1:100,1);
plot(s);
title("Plot of  first eigenvalues");


figure;
imagesc(reshape(R(1,:),[60,80]));
title('1st eigenvector');

figure;
imagesc(reshape(R(2,:),[60,80]));
title('2nd eigenvector');

figure;
imagesc(reshape(R(3,:),[60,80]));
title('3rd eigenvector');

figure;
imagesc(reshape(R(4,:),[60,80]));
title('4th eigenvector');

figure;
imagesc(reshape(R(50,:),[60,80]));
title('50th eigenvector');

figure;
imagesc(reshape(R(100,:),[60,80]));
title('100th eigenvector');
