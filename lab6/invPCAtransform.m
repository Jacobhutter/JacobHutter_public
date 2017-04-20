function [ x_orig ] = invPCAtransform( Ux, V, x_pca )
    x_orig = V*(x_pca - Ux) + Ux;
end
