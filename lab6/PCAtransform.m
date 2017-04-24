function [ x_pca ] = PCAtransform( Ux, V, x_orig )
x_hat = x_orig - Ux;
x_pca =  x_hat * V;
end
