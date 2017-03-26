clc, clear all, close all
f = [54,64];
a = [1,0];
rp = [2];
rs = 50;
fs = 300;
dev = [(10^(rp/20)-1)/(10^(rp/20)+1)  10^(-rs/20)]; 
[n,fo,mo,w] = firpmord(f, a, dev, fs);
b = firpm(n,fo,mo,w);
freqz(b,1);
figure
impz(b,1);
