function [ x_pca ] = PCAtransform( Ux, V, x_orig )
    %[height,width] = size(x_orig);
    x_hat = x_orig - Ux;
    
   %{ for i=1:height
   %    x_hat(i,:) = x_orig(i,:) - Ux;
   %end
    x_pca =  inv(V) * x_hat';
end
