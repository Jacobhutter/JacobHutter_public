clear all;
clc;
A = [1,4,-2
     3,11,5
     7,7,7];
AH = A';

AAH = A*AH;
AHA = AH*A;

e1 = eig(AAH);
e2 = eig(AHA);

B = svd(A)
e1 
e2
