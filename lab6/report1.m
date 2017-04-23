x = [ 1 4 -4 -3 2 5 -6];
h = [1 2 3 4 5];
a = convmtx(h,length(x));
figure;
imagesc(a);
title('Plot of convolution matrix');

cx = x*a;
c = conv(x,h);

figure;
subplot(211);
stem(cx);
title('Convotution using convmtx');
ylabel('Conv of x and h');
xlabel('n');
subplot(212);
stem(c);
title('Convolution using conv');
ylabel('Conv of x and h');
xlabel('n');