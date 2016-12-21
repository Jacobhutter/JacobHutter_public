#include <stdio.h>


int findpair(int array[], int start, int end);
int main(){
	int N1 = 8, N2= 11, N3 = 7;
	int array1[] = {5, 7, 3, 3, 24, 12, 24, 19};
	int array2[] = {29, 35, 77, 57, 35, 4, 29, 16, 81, 62, 16};
	int array3[] = {16, 13, 25, 16, 1, 10, 16};
	
	printf("%d\n", findpair(array1, 0, 0));
	printf("%d\n", findpair(array1, 0, N1-1));
	printf("%d\n", findpair(array3, 0, N3-1));
	printf("%d\n", findpair(array2, 0, N2-1));
	
	return 0;
}


int findpair(int array[],int start, int end){


  int count = 0;
  int value = 0;
  int target = 0;
  int pair = 0;
  int i = 1;
   if(end==0)
	return count;
   else{ // will be passing incremented address of array until the end is hit 
	value  = array[start];
   while(i<=end&&pair==0){
	target = array[i];   // get next val value
	if(target != 0){   // makes sure to not pair with another zero
	if(target == value){
	  pair = 1;                         // loops to find match within array 
	array[start] = 0;
	array[i] = 0;
	count += 1;
   }	
	else 
	  ++i;
   }
	else 
	++i;
  }
 count += findpair((array+1),start,(end-1));    // calls same function with a new start to the array, one slot to the right, this is accounted for in the decrementing of end  
  return count;
     
 }
  return count;
}



