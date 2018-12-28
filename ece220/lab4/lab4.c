#include <stdio.h>
#include "prime.h"
// written by Jacob Hutter 
// calculates and prints all primes below and equal to a number entered by a user 
int main() {
	int test,i=0,n=0;
	printf("Enter the value of n: ");     // gets user input to list all primes below or equal to n 
	scanf("%d",&n); 
	printf("Printing primes less than or equal to %d:\n",n);
	
	
	for(i=2;i<=n;i++)                // notice that the for loop starts at 2 to save some loops assuming 1 and zero are not prime 
		{
			test = is_prime(i);           // calls is_prime to decide if number is prime or not
			if(test==1)
				
				printf("%d, ",i);      // if number is prime then print the counter 
			
	
		} 
	printf("\b\b.");	
	printf("\n");	
	return 0;
}
