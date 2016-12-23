#include <stdlib.h>
#include "count_steps.h"
#include <stdio.h>

/*
 * count_steps
 *   DESCRIPTION: counts the total number of ways to reach the nth step by
 *                climbing either 1, 2, or 3 steps at a single time
 *   INPUTS: num_steps -- number of steps to climb
 *   OUTPUTS: none
 *   RETURN VALUE: total number of ways to reach top
 *   SIDE EFFECTS: none
 */
/*int count_steps(int num_steps);

int main(){
int steps=0,sum=0;

printf("enter a num \n");
scanf("%i",&steps);
sum = count_steps(steps);
printf("%i ways\n",sum);
return 0;

}
*/
int ways = 0;
int count_steps(int num_steps)
{ if(num_steps == 1)
		ways = 1;
	if(num_steps == 2)
     ways = 2;
	if(num_steps <= 0)
		 ways = 0;
	if(num_steps == 3)
		ways = 4;
	if(num_steps == 4)
		ways = 7;
		 
  // Allocate step array
  int *step_arr = (int *)malloc(num_steps * sizeof(int));
//	step_arr[0] = 3;
//	step_arr[1] = 2;
//	step_arr[2] = 1;

if(num_steps > 4 )
ways = count_steps(num_steps-1) + count_steps(num_steps-2) + count_steps(num_steps-3);
	
  // Free memory
  free(step_arr);
  


	//printf("%i",ways);
  return ways;
}
