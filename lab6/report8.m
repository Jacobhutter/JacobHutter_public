
clc;
clear all;
X = loadImages('yalefaces');
Y = compMeanVec(X);
Ux = Y;
X_hat = zeros(165,4800);
for i=1:165
    X_hat(i,:) = X(i,:) - Y;
end
R = (X_hat')*(X_hat);
[U,S,V] = svd(R);

%%%%%%%%% get U and Ux
A = imread('noisy_face.png');
A = im2double(A); % convert integer precision to double precision for mean
A = reshape(A,[1,4800]);

A_hat = A - Ux;
A_pca =  A_hat * U';
figure;
imagesc(reshape(A_pca,[60,80]));
colormap gray;

%%%%%%%%%%%%obtained pca version%%%%%%%%%%%%%
A_pca = reshape(A_pca,[1,4800]);
A_hat = A_pca - Ux;
A_orig = U*A_pca' + Ux';
figure;
imagesc(reshape(A_orig,[60,80]));
colormap gray




