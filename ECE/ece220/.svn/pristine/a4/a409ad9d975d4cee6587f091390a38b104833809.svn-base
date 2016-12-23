#include <stdio.h>
#include <stdlib.h>

int main()
{ char search[] = "taccat";
	int search_len = 6;
	int perm_len = 3;
	char perm[]= "cat";
  int i,j,k,l,match=0;
	char A,B,C;
  char test[20];
  
  for(i=0;(i+perm_len)<=search_len;i++){
	A = search[i];     // first char to look in 
		for(j=0;j<=perm_len;j++){
		 B = perm[j];     //first char to look for 
		  if(A==B){
	     match += 1;
			 break; }
		  else
			 match = 0;
	}
	if(match == 1){     //calculates total matches in search
		for(k=1;(k)<(perm_len);k++){
			C=search[(i+k)];
			if(A!=C){
				for(j=0;j<=perm_len;j++){
		 			B = perm[j];     //first char to look for 
		  		if(C==B){
	     			match += 1;
						break; }
		  		}
				}
		}
 }
 if(match == perm_len){
   for(l=0;(l+1)<=perm_len;l++){
		test[l] = search[l+i];
	}
 test[l] = '\0';
 printf("%s ",test);
 }
 match = 0; //reset match
 }
 printf("\n");
return 0;
}
