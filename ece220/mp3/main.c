#include <stdio.h>
#include <stdlib.h>
#include <math.h>
// Written by Jacob Hutter
//	this code, when given an input of omega1,omega2 and omegac will utilize a low pass
//	filter by using a discretized differnetial equation of how it is normally done
//	in signal processing. 
int main()
{
	double omega1, omega2, omegac, T, dt;
	int N;
	double outside,term1,term2,term3; 		 //calling this the outside portion of the brackets
							 //printf("enter the values of omega1, omega2 and omegac");
							 //Scan the inputs from the user.
	scanf("%lf %lf %lf", &omega1, &omega2, &omegac); // gets vals of omegac
	
	T = 3 * 2 * M_PI / omega1;      		 // Total time
    	N = 20 * T / (2 * M_PI / omega2);   		 // Total number of time steps
    	dt = T / N;             			 // Time step
	int n;
	double Voutnew = 0, Voutcur = 0, Voutprev = 0;

	if(N > 0)
	  {						//calculating Voutnew
	   

	   for(n=0;n<N;n++)
		{	//Voutnew = (1/((1/(sqrt(2)*dt*omegac))+(1/((dt*dt)*(omegac*omegac)))))*( (((2/((dt*dt)*(omegac*omegac)))-1)*Voutcur) + (((1/(sqrt(2)*dt*omegac))-(1/((dt*dt)*(omegac*omegac))))*Voutprev) +(sin((omega1)*(n)*(dt))+.5*(sin(omega2*n*dt))));	
			printf("%lf\n",Voutnew); //prints the result of 
	   		outside = 1.0f/((1.0f/(sqrt(2.000000f)*dt*omegac))+(1.0000f/((dt*dt)*(omegac*omegac))));
	   		term1 = ((2.0000f/((dt*dt)*(omegac*omegac)))-1.0000f)*Voutcur;
	   		term2 = (1.0f/(sqrt(2.0f)*dt*omegac)-(1.00000f/((dt*dt)*(omegac*omegac))))*Voutprev;  // calculating individual terms
	   		term3 = sin((omega1)*(n)*(dt))+0.5f*(sin((omega2*n*dt)));
	  		Voutnew = term1+term2+term3;
           		Voutnew = outside * Voutnew ; // calculates entire sum 
			Voutprev = Voutcur; // V[N-1]=V[N]
			Voutcur = Voutnew;  // V[N]= V[N+1]
			//printf("%lf\n",Voutnew); //prints the result of 
			//Voutnew = 0;        // V[N+1]=0 resets val of V[N+1]
		}
	    }
		

	else
	  {Voutnew = 0;
	  printf("%lf\n",Voutnew);}  // if value of n is less than zero then will zero
	return 0;
}
