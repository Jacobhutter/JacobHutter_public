function [ x_pca ] = PCAtransform( Ux, V, x_orig )
    x_pca = inv(V) * ( x_orig - Ux);
end
