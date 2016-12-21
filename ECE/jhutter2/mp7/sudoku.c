#include "sudoku.h"
// this code, written by Jacob Hutter, will solve a given sudoku puzzle ****given that it is solveable in the first place***. It accomplishes this task by injecting
// a test number into the slot and testing whether or not it fits, if it fits immediately, then it is placed in and the program increments to the next empty spot. If at 
// any point in the program the puzzle becomes unsolveable given the current conditions, it will go back and re check every number including the first number placed. 
// in the end, this recursive function quickly solves any valid sudoku puzzle.
// Procedure: print_sudoku
void print_sudoku(int sudoku[9][9])
{
  int i, j;
  for(i=0; i<9; i++) {
    for(j=0; j<9; j++) {
      printf("%2d", sudoku[i][j]);
    }
    printf("\n");
  }
}

// Procedure: parse_sudoku
void parse_sudoku(const char fpath[], int sudoku[9][9]) {
  FILE *reader = fopen(fpath, "r");
  assert(reader != NULL);
  int i, j;
  for(i=0; i<9; i++) {
    for(j=0; j<9; j++) {
      fscanf(reader, "%d", &sudoku[i][j]);
    }
  }
  fclose(reader);
}

//-------------------------------------------------------------------------------------------------
// Start coding your MP here.
// ------------------------------------------------------------------------------------------------

// Function: is_val_in_row
// Return true if "val" already existed in ith row of array sudoku.
int is_val_in_row(const int val, const int i, const int sudoku[9][9]) {

  assert(i>=0 && i<9);
int j;
int sum = 0;
  // BEG TODO
	for(j = 0; j<9; j++){
		if(sudoku[i][j] == val)
			sum += 1;    // we look here to see if value is already present in this row
}
   if(sum)
		return true;
	 else           // return a one if there is a repeat number
		 return false;
  // END TODO
}

// Function: is_val_in_col
// Return true if "val" already existed in jth column of array sudoku.
int is_val_in_col(const int val, const int j, const int sudoku[9][9]) {

  assert(j>=0 && j<9);

  // BEG TODO
  int i;
int sum = 0;
  // BEG TODO
	for(i = 0; i<9; i++){
		if(sudoku[i][j] == val)
			sum += 1;    // we look to see if the current column contains the test number

}
	 if(sum)
		return true;
	 else              // if repeat then true
	  return false;	
  // END TODO
}

// Function: is_val_in_3x3_zone
// Return true if val already existed in the 3x3 zone corresponding to (i, j)
int is_val_in_3x3_zone(const int val, const int i, const int j, const int sudoku[9][9]) {
   
  assert(i>=0 && i<9);
  
  // BEG TODO
  int k,L;
	int section = 0;
	int sum = 0; 
	int row_offset = 0;
	int column_offset = 0;
	if((i <= 2)){           // we need to find out in wich section of the puzzle our test case is in and assign it a one digit section number
		if(j <=2)
			section = 1;
    if((j>2)&&(j<=5))
			section = 2;       //     1 2 3
		if((j>=6))           //     4 5 6        this is the section scheme we look to accomplish in this code
			section = 3;       //     7 8 9
 }
	if((i>2)&&(i<=5)){
	  if(j <=2)
			section = 4;
    if((j>2)&&(j<=5))
			section = 5;
		if((j>=6))
			section = 6;
 }
	if((i >=6)){
		if(j <=2)
			section = 7;
    if((j>2)&&(j<=5))
			section = 8;
		if((j>=6))
			section = 9;
 }
	switch(section){
	case 1: row_offset = 0;
					column_offset = 0;
					break;
	case 2: column_offset = 3;
					break;
	case 3: column_offset = 6;
					break;
	case 4: row_offset = 3;
					column_offset = 0;
					break;
	case 5: row_offset = 3;
					column_offset = 3;        // once we know the section code, we must apply the correct row and column offset
					break;
	case 6: row_offset = 3;
					column_offset = 6;
					break;
	case 7: row_offset = 6;
					column_offset = 0;
					break;
	case 8: row_offset = 6;
					column_offset = 3;
					break;
  case 9: row_offset = 6;
					column_offset = 6;
					break;
 }
	for(k = 0; k<3;k++){  // row index
	 for(L = 0; L<3;L++){ // column index
     if(sudoku[k+row_offset][L+column_offset] == val)       // now we will increment through the 9 values looking for repeats
			sum = 1; // looking for duplicate 
  }
 }
	if(sum)   // return true if duplicate found 
		return true;
  else return false;
  // END TODO
}

// Function: is_val_valid
// Return true if the val is can be filled in the given entry.
int is_val_valid(const int val, const int i, const int j, const int sudoku[9][9]) {

  // BEG TODO.
	int sum = 1;
	if(is_val_in_row(val,i,sudoku))
		sum = 0;
	if(is_val_in_col(val,j,sudoku))     // calls individual tests and sums them up
		sum = 0;
	if(is_val_in_3x3_zone(val,i,j,sudoku))
		sum = 0;

  return sum;
  // END TODO.
}

// Procedure: solve_sudoku
// Solve the given sudoku instance.
int solve_sudoku(int sudoku[9][9]) {
  // BEG TODO.
int i,j; //initialize row and column indecies
int sum = 1;
int num;
	for(i=0;i<9;i++){      // begin checking if every sudoku slot is filled
	 for(j=0;j<9;j++){
		if(!sudoku[i][j])
			sum = 0;
  }
 }
	if(sum)
  return sum;
int row =0,column=0;      // to get to this point, we know that there must be at least one unfilled cell 
	for(i=0;i<9;i++){      // look for unfilled slot 
	 for(j=0;j<9;j++){
		if(!sudoku[i][j]){
			row = i;          // after for loops have passed, row and column will contain the last available slot unfilled coordinates i and j
			column = j;
   }
  }
 }
	for(num = 1; num <=9;num++){
 if(is_val_valid(num,row,column,sudoku)){    // if val can be placed in this location
		sudoku[row][column] = num;
    if(solve_sudoku(sudoku)){
     return true;
   }
  sudoku[row][column] = 0;           // if that number is invalid then clear the value 
  }
 }
	 return false; 
  // END TODO.
}



