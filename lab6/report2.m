clear all;
clc;
A = [1,4,-2; 3,11,5; 7,7,7];
AH = A';
AHA = AH*A;
AAH = A*AH;

[V1,D1] = eig(AAH);
[V2,D2] = eig(AHA);

[U3,S3,V3] = svd(A);

A*AH*U3 - U3*S3^2 % formula given, gives zero matrix

AH*A*V3 - V3*S3^2 % zero matrix returned
