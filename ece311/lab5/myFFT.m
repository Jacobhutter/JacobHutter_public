function [ X ] = myFFT( x )

 N = length(x); % get length
 if(N>= 2)
    if(mod(N,2)) % base case
        X = myDFT(x);
    else
        Xe = myFFT(x(1:2:N-1));
        Xo = myFFT(x(2:2:N));
        X = [Xe, Xe] + exp(-1i*2*pi*(0:N-1)/N).*[Xo,Xo];
    end
 else
     X = myDFT(x);
 end
end
function [ K ] = myDFT( n )
    K = zeros(1,size(n,2)); % default K to size of n initialized to zero
    for f = 0:(size(n,2) -1 ) % k loop)
        for j = 0:(size(n,2) -1 ) % n loop
            K(f+1) = K(f+1) +  (n(j + 1) * exp((-1i*2*pi*f*j)/size(n,2)));
        end
    end
end
