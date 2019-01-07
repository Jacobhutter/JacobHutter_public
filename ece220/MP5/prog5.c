/*			
 *
 * prog5.c - source file adapted from UIUC ECE198KL Spring 2013 Program 4
 *           student code -- GOLD VERSION by Steven S. Lumetta
 */


/*
 * The functions that you must write are defined in the header file.
 * Blank function prototypes with explanatory headers are provided
 * in this file to help you get started.
 */
// This code, written by Jacob Hutter, simulates the game codebreaker. 
// A user must enter a single integer seed value which generates a predictable random 
// string of 4 integers from 1 to 8. the user then has 12 gueses to match the code 
// the program will return the number of perfect and mismatched answers as well.
// a user also must only enter 4 integers from 1-8 when guessing.


#include <stdio.h>
#include <stdlib.h>

#include "prog5.h"


/*
 * You will need to keep track of the solution code using file scope
 * variables as well as the guess number.
 */

static int guess_number;
static int solution1;
static int solution2;
static int solution3;
static int solution4;


/*
 * set_seed -- This function sets the seed value for pseudorandom
 * number generation based on the number the user types.
 * The input entered by the user is already stored in the string seed_str by the code in main.c.
 * This function should use the function sscanf to find the integer seed value from the 
 * string seed_str, then initialize the random number generator by calling srand with the integer
 * seed value. To be valid, exactly one integer must be entered by the user, anything else is invalid. 
 * INPUTS: seed_str -- a string (array of characters) entered by the user, containing the random seed
 * OUTPUTS: none
 * RETURN VALUE: 0 if the given string is invalid (string contains anything
 *               other than a single integer), or 1 if string is valid (contains one integer)
 * SIDE EFFECTS: initializes pseudo-random number generation using the function srand. Prints "set_seed: invalid seed\n"
 *               if string is invalid. Prints nothing if it is valid.
 */
int
set_seed (const char seed_str[])
{
 int seed;
 char post[2];
 if(sscanf(seed_str, "%d%1s", &seed, post)!=1){
	printf("set_seed: invalid seed\n");
	return 0;
       }
 srand(seed); 
 return 1;	
}



/*
 * start_game -- This function is called by main.c after set_seed but before the user makes guesses.
 *               This function creates the four solution numbers using the approach
 *               described in the wiki specification (using rand())
 *               The four solution numbers should be stored in the static variables defined above. 
 *               The values at the pointers should also be set to the solution numbers.
 *               The guess_number should be initialized to 1 (to indicate the first guess)
 * INPUTS: none
 * OUTPUTS: *one -- the first solution value (between 1 and 8)
 *          *two -- the second solution value (between 1 and 8)
 *          *three -- the third solution value (between 1 and 8)
 *          *four -- the fourth solution value (between 1 and 8)
 * RETURN VALUE: none
 * SIDE EFFECTS: records the solution in the static solution variables for use by make_guess, set guess_number
 */
void
start_game (int* one, int* two, int* three, int* four)
{
    *one = ((rand()%8)+1);
   // printf("%i",*one);
    *two = (rand()%8)+1;
    //printf("%i",*two);
    *three = (rand()%8)+1;      //sets random number to pointers 
   // printf("%i",*three);
    *four = (rand()%8)+1;
    //printf("%i",*four);
    solution1 = *one;
    solution2 = *two;
    solution3 = *three;
    solution4 = *four;         // assigns random numbers to the solutions
    guess_number = 1;          // sets initial guess num to 1
}

/*
 * make_guess -- This function is called by main.c after the user types in a guess.
 *               The guess is stored in the string guess_str. 
 *               The function must calculate the number of perfect and misplaced matches
 *               for a guess, given the solution recorded earlier by start_game
 *               The guess must be valid (contain only 4 integers, within the range 1-8). If it is valid
 *               the number of correct and incorrect matches should be printed, using the following format
 *               "With guess %d, you got %d perfect matches and %d misplaced matches.\n"
 *               If valid, the guess_number should be incremented.
 *               If invalid, the error message "make_guess: invalid guess\n" should be printed and 0 returned.
 *               For an invalid guess, the guess_number is not incremented.
 * INPUTS: guess_str -- a string consisting of the guess typed by the user
 * OUTPUTS: the following are only valid if the function returns 1 (A valid guess)
 *          *one -- the first guess value (between 1 and 8)
 *          *two -- the second guess value (between 1 and 8)
 *          *three -- the third guess value (between 1 and 8)
 *          *four -- the fourth guess value (between 1 and 8)
 * RETURN VALUE: 1 if the guess string is valid (the guess contains exactly four
 *               numbers between 1 and 8), or 0 if it is invalid
 * SIDE EFFECTS: prints (using printf) the number of matches found and increments guess_number(valid guess) 
 *               or an error message (invalid guess)
 *               (NOTE: the output format MUST MATCH EXACTLY, check the wiki writeup)
 */
int
make_guess (const char guess_str[], int* one, int* two, 
	    int* three, int* four)
{

 int w,x,y,z,misplaced,pair[4],check;
 char post[2];
 pair[0] = solution1;
 pair[1] = solution2;
 pair[2] = solution3;
 pair[3] = solution4;
 misplaced = 0;
check = sscanf(guess_str, "%d%d%d%d%1s", &w, &x, &y, &z, post);
 if(check != 4){
	printf("make_guess: invalid guess\n");
	return 0;
    }
 int str[4];
 str[0] = w;
 str[1] = x;
 str[2] = y;
 str[3] = z;
 *one = w;
 *two = x;
 *three = y;
 *four = z;
 
	
	if((w<1)||(w>8)){
	printf("make_guess: invalid guess\n");
	return 0;
        }
	if((x<1)||(x>8)){
	printf("make_guess: invalid guess\n");
	return 0;
        }
	if((y<1)||(y>8)){
	printf("make_guess: invalid guess\n");
	return 0;
        }
	if((z<1)||(z>8)){
	printf("make_guess: invalid guess\n");
	return 0;
        }
  int match;
  match = 0;
  if(w==solution1){
    match += 1;
    pair[0] = 0;
    str[0]  =0; }
  if(x==solution2){
    match += 1;
    pair[1] = 0;
    str[1] = 0 ;
}
  if(y==solution3){
    match += 1;
    pair[2] = 0;
    str[2]  = 0;
  }
  if(z==solution4){
    match += 1;
    pair[3] = 0;
    str[3] = 0;
   }
//printf("%i %i %i %i",pair[0],pair[1],pair[2],pair[3]);	
  int i,k;
  for(i=0;i<=3;i+=1){
   if(pair[i]!=0){
    for(k=0;k<=3;k+=1){
     if(str[k]!=0){
     if(str[k]== pair[i]){
      str[k] = 0;
      pair[i] = 0;
      misplaced += 1;
      }
     }
    }
   }
  }
printf("With guess %d, you got %d perfect matches and %d misplaced matches.\n",guess_number,match,misplaced);
guess_number = guess_number + 1;
return 1;
}

