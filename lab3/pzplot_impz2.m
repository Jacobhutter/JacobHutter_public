function [  ] = pzplot_impz2( a,b )
S = tf(b,a);
N = 35;

figure;
subplot(121);
pzplot(S);
subplot(122);
impz(b,a,N);

end

