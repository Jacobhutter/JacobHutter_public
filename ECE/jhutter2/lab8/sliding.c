#include "sliding.h"
/*  Slide all values of array up
*/
void slide_up(int* my_array, int rows, int cols){
	int i,j,target;
	for(i=0;i<cols;i++){
	 target = 0;	
	 for(j=1;j<rows;j++){
	 	if(my_array[j*cols+i] != -1){
	 	 while(my_array[target*cols +i] != -1 && target <j){
	 	  target +=1;
	 }
	    if(target<j){
	    my_array[target*cols+i] = my_array[j*cols+i];
	    my_array[j*cols+i] = -1;
	 }
   }    
  }
 }
		
    return;
}
