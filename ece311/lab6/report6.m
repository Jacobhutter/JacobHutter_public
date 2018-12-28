clc;
clear all;
X = loadImages('yalefaces');
Y = compMeanVec(X);
Z = reshape(Y,[60,80]);
imagesc(Z);
colormap gray