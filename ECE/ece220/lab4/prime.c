#include "prime.h"
int is_prime(int n) {
	int i2;
	int check;
	int k;
	i2=n;  //stores val of i 	
//	i=1;
	//checker = (i%number);
	//checker == 0? 
	//y--> number is clearly not prime 
	//keep incrementing number until it is one less than i  
	 
	for(k=2;k<n;k++)
	{ check = n%k;
	  if(check == 0)
	    {	n=0;
		return n;
	    }
	}
	if((i2==2)||(i2==3))
		n=1;
	n=1;
	    

	return n;
}
