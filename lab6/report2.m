clear all;
clc;
A = [1,4,-2
     3,11,5
     7,7,7];
AH = A';

AAH = A*AH;
AHA = AH*A;

[V1,D1,W1] = eig(AAH);
[V2,D2,W2] = eig(AHA);

[U3,S3,V3] = svd(A);

V1
V2
W1
W2
U3
V3
