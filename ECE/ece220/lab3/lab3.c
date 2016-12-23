#include <stdio.h>
#include <math.h>
#define PI 3.14159265359

int main()
{
	double omega1;
	double omega2;
	int n;
	double xi,result;
	int i=0;
	printf("enter values of n, omega1, and omega2 respectively with spaces in between ");
	scanf("%i %lf %lf",&n,&omega1,&omega2);
//	printf("enter the value of n");
//	scanf("%i",&n);
//	printf("enter the value of omega1"); // get values of n, omega1, and omega2 from the user
//	scanf("%lf",&omega1);
//	printf("enter the value of omega2");
//	scanf("%lf",&omega2); 
	for(i=0;i<n;i++)
		{
			xi = (i*PI)/n;
			result = sin((omega1)*(xi))+0.5*(sin(omega2*xi));
			printf("(%f,%f)\n",xi,result);
		}
	 return 0;
	
	
}
	
