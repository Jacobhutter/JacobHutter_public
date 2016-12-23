#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <float.h>
//
//
//
//	This code, written by Jacob Hutter, will calculate the root of a polynomial 
//	within a certain interval. It will probe for a zero for every interval of .5 within
//	the given interval. It uses two different theorems to first tell how many possible 
//	roots there are and then calculate it. it is possible to have a root that 
//	does not diverge in that case a message will be printed.
//
//
double fx_val(double a, double b, double c, double d, double e, double x)
{   double part1,part2,part3,part4,part5,sum;
	part1 = a*(x*x*x*x); //ax^4
	part2 = b*(x*x*x);
	part3 = c*(x*x);
	part4 = d*(x);
	part5 = e;
	sum = part1 + part2 + part3 + part4 + part5;
    //Change this to return the value of the polynomial at the value x
	//printf("%lf",sum);
    return sum;
}

double fx_dval(double a, double b, double c, double d, double e, double x)
{ 
    double part1,part2,part3,part4 ; // declare individual sums
    double sum;      // declare sum
	part1 = 4.0f *a*(x*x*x);
	part2 = 3.0f *b*(x*x);
	part3 = 2.0f *c*x;
	part4 = d;
	sum = part1 + part2 + part3 + part4;
	//printf("%lf",sum);
	
	
	
    //Change this to return the value of the derivative of the polynomial at the value x
    return sum;
   
}


double fx_ddval(double a, double b, double c, double d, double e, double x)
{   double part1,part2,part3,sum;

	part1 = 12.0f *a*(x*x);
	part2 = 6.0f *b*(x);
	part3 = 2.0f *c;
	sum = part1 + part2 + part3;
    //Change this to return the root found starting from the initial point x
    return sum;
}

double double_abs(double x)
{
    x *= x;
    x = sqrt(x);
    return x;
}

double newrfind_halley(double a, double b, double c, double d, double e, double x)
{   //x is initial guess 
    //Change this to return the root found starting from the initial point x
	double function,dfunction,ddfunction,i,dif,x_1;
	double safety=0;
	dif = 1;
	i = 0.0000001;
	//printf("flag\n");;
	//a2 =12;
	//printf("%i",a2);
	//printf("flag\n");
	for(i=.0000001f;i<dif;x=x_1)
	    {		//printf("flag\n");
			function = fx_val(a,b,c,d,e,x); // finds function val
			dfunction = fx_dval(a,b,c,d,e,x); // finds d/dx*f(x) val
			ddfunction = fx_ddval(a,b,c,d,e,x); // finds d^2/dx^2*f(x) val
			x_1 = x - ((2.0f*function*dfunction)/((2.0f*(dfunction*dfunction))-(function*ddfunction)));
			dif = x_1 - x;
			dif = double_abs(dif);
			++safety;
			if(safety>=10000)
		  	{	
		  		printf("no roots found\n");
		  		return safety;  
		  	}		
		}
    
    return x_1;
}

double lr_gap(double a, double b, double c, double d, double e, double l, double r)
{	double guess;
	for(l=l;l<=r;l+=.50f)
		{
			guess = newrfind_halley(a,b,c,d,e,l);	
			if(guess!=10000)
				printf("Root found: %lf\n",guess);
		}
	return 0.0f;
}




int rootbound(double a, double b, double c, double d, double e, double r, double l)
{	double e1,d1,c1,b1,a1; //duplicate vars to hold vals 
	int P,V_L=0,V_R=0; //left and right bound sign changes 
    
    //Using binomial theorem and condensing coefficients i was able to simplify the end
    // equation for VL and VR to this.... using budan's theorem
	e1 = ((l*l*l*l)*a)+((l*l*l)*b)+((l*l)*c)+(l*d)+e;
	d1 = (4.0f*a*(l*l*l))+(3.0f*b*(l*l))+(2.0f*c*l)+d;
	c1 = (6.0f*a*(l*l))+(3.0f*b*l)+c;
	b1 = (4.0f*a*l)+b;
	a1 = a; 
	

	if(a1>0)
	  a1=0;
	else 
	  a1=1;
	if(b1>0)
	  b1=0;
	else 
	  b1=1;
	if(c1>0)    // turns all the a1..... into one or zero
	  c1=0;
	else 
	  c1=1;
	if(d1>0)
	  d1=0;
	else 
	  d1=1;
	if(e1>0)
	  e1=0;
	else
	  e1=1;

	if(a1!=b1)
	  V_L += 1;
	if(b1!=c1)
	  V_L += 1; 
	if(c1!=d1)
	  V_L += 1;
	if(d1!=e1)
	  V_L += 1;      //finished calculating V_L
	e1 = ((r*r*r*r)*a)+((r*r*r)*b)+((r*r)*c)+(r*d)+e;
	d1 = (4.0f*a*(r*r*r))+(3.0f*b*(r*r))+(2.0f*c*r)+d;
	c1 = (6.0f*a*(r*r))+(3.0f*b*r)+c;
	b1 = (4.0f*a*r)+b;
	a1 = a; 			 //begin calculating V_R
	if(a1>0)
	  a1=0;
	else 
	  a1=1;
	if(b1>0)
	  b1=0;
	else 
	  b1=1;
	if(c1>0)    // turns all the a1..... into one or zero
	  c1=0;
	else 
	  c1=1;
	if(d1>0)
	  d1=0;
	else 
	  d1=1;
	if(e1>0)
	  e1=0;
	else
	  e1=1;
	if(a1!=b1)
	  V_R += 1;
	if(b1!=c1)
	  V_R += 1; 
	if(c1!=d1)
	  V_R += 1;
	if(d1!=e1)
	  V_R += 1;      //finished calculating V_L

	P = V_L - V_R;    // p is the maximum number of roots a function has 
	P = double_abs(P);
	//printf("%i",P);
    return P;
}

int main(int argc, char **argv)
{
	double a, b, c, d, e, l, r;//guess,//function;
	FILE *in;

	if (argv[1] == NULL) {
		printf("You need an input file.\n");
		return -1;
	}
	in = fopen(argv[1], "r");
	if (in == NULL)
		return -1;
	fscanf(in, "%lf", &a);
	fscanf(in, "%lf", &b);
	fscanf(in, "%lf", &c);
	fscanf(in, "%lf", &d);
	fscanf(in, "%lf", &e);
	fscanf(in, "%lf", &l);
	fscanf(in, "%lf", &r);
	double hold;
	int roots=0;
	if(l>r)
	  {
		hold =r;
		r=l;
		l=hold;
	  }	
	roots = rootbound(a,b,c,d,e,r,l);
	if(roots==0)	
	   printf("The polynomial has no roots in the given interval.\n");
	else //rest of code relies on the fact that there is at least one real root
	{
		lr_gap(a,b,c,d,e,l,r); //just calling this function is sufficient to handle the rest
	}
		
    
    //Write the code to call the appropriate functions and perform the task described in the writeup.
    
    
    fclose(in);
    
    return 0;
}
