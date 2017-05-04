load signal.mat;
[A1,D1] = dwt(x,'sym4');
[A2,D2] = dwt(x,'coif1');

figure;
subplot(211);
stem(A1);
title('Phi coefficients for sym4');
subplot(212);
stem(D1);
title('Psi coefficients for sym4');

figure;
subplot(211);
stem(A2);
title('Phi coefficients for coif1');
subplot(212);
stem(D2);
title('Psi coefficients for coif1');