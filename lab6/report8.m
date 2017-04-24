
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

% start of PCA transform
A_pca = PCAtransform(Ux,U,A);
% end of PCA transform

A_pca(1,100:4800) = 0; % limit noise

%%%%%%%%%%%%obtained pca version%%%%%%%%%%%%%
%start of inv PCA transform
A_orig = invPCAtransform(Ux,U,A_pca);
%end of inv PCA transform
figure;
imagesc(reshape(A_orig,[60,80]));
colormap gray
