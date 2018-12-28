#include <stdio.h>
#include "permutation.h"

/*
 * find_permutations
 *   DESCRIPTION: finds all permutations of perm in search
 *   INPUTS: perm -- array containing permutation to search for
 *           perm_len -- length of permutation string
 *           search -- array to be searched over for permutations
 *           search_len -- length of search string
 *   OUTPUTS: none
 *   RETURN VALUE: none
 *   SIDE EFFECTS: none
 */
void find_permutations(const char perm[], int perm_len, const char search[], int search_len)
{
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
}
