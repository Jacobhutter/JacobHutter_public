function [ K ] = myDFT( n )
    K = zeros(1,size(n,2)); % default K to size of n initialized to zero
    for f = 0:(size(n,2) -1 ) % k loop)
        for j = 0:(size(n,2) -1 ) % n loop
            K(f+1) = K(f+1) +  (n(j + 1) * exp((-i*2*pi*f*j)/size(n,2)));
                  
        end 
    end
end

