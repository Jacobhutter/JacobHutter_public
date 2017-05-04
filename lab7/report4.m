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

x1 = idwt(A1(A1<mean(A1)),[],'sym4');
x2 = idwt([],D1(D1<mean(D1)),'sym4');
x3 = idwt(A2(A2<mean(A2)),[],'coif1');
x4 = idwt([],D2(D2<mean(D2)),'coif1');

figure
subplot(411);
plot(x1);
title('idwt of phi sym4');
subplot(412);
plot(x2);
title('idwt of psi sym4');
subplot(413);
plot(x3);
title('idwt of phi coif1');
subplot(414);
plot(x4);
title('idwt of psi coif1');
