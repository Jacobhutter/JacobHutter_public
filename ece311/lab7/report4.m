load signal.mat;
[A1,D1] = dwt(x,'sym4');
[A2,D2] = dwt(x,'coif1');
xnew1 = idwt(A1,D1,'sym4');
xnew2 = idwt(A2,D2,'coif1');
figure;
plot(x);
hold on;
plot(xnew1);
plot(xnew2);
% plot shows same graph overlayed 3 times 

A1mean = mean(A1);
A2mean = mean(A2);
D1mean = mean(D1);
D2mean = mean(D2);
A1(A1 < A1mean) = 0;
A2(A2 < A2mean) = 0;
D1(D1 < D1mean) = 0;
D2(D2 < D2mean) = 0;
x1 = idwt(A1,[],'sym4');
x2 = idwt([],D1,'sym4');
x3 = idwt(A2,[],'coif1');
x4 = idwt([],D2,'coif1');

figure
subplot(411);
stem(x1);
title('idwt of phi sym4');
subplot(412);
stem(x2);
title('idwt of psi sym4');
subplot(413);
stem(x3);
title('idwt of phi coif1');
subplot(414);
stem(x4);
title('idwt of psi coif1');
