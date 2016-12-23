#include <stdio.h>
#include <stdlib.h>




int derp(x,n){
	if (n==0)
		return 1;
	if (n%2 == 0)
		return derp(x*x,n/2);
	return x * derp(x*x,(n-1)/2);
}
int main(){
int x = 2;
int n = 12;
int result = derp(x,n);
printf("%i",result);
return 0;
}
