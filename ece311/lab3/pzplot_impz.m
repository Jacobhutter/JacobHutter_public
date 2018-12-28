function [  ] = pzplot_impz( a,b )
S = tf(b,a);
N = 20;

figure;
subplot(121);

pzplot(S);
grid on;
subplot(122);
impz(b,a,N);

end

