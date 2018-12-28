//#include <ncursesw/curses.h>
#include <curses.h>
#include <stdlib.h>
#include <wchar.h>
#include "game_of_life.h"

enum status
{
  RESPAWN = -1,
  DEAD,
  ALIVE, 
  KILL
};

/*
 * mod
 *   DESCRIPTION: computes a mod b
 *   INPUTS: a -- value to be modded
 *           b -- modding value
 *   OUTPUTS: none
 *   RETURN VALUE: a mod b
 *   SIDE EFFECTS: none
 */
int mod(int a, int b)
{
  int ret = a % b;
  return (ret < 0) ? ret + b : ret;
}

/*
 * free_array2d
 *   DESCRIPTION: frees the memory occupied by a 2d array
 *   INPUTS: arr -- pointer to array to be freed
 *           rows -- number of rows in the array
 *   OUTPUTS: none
 *   RETURN VALUE: none
 *   SIDE EFFECTS: none
 */
void free_array2d(int **arr, int rows)
{
  // Check if arr valid
  if (arr == NULL)
  {
    return;
  }

  // Free inner arrays
  for (int i = 0; i < rows; i++)
  {
    free(arr[i]);
  }

  // Free outer arrays
  free(arr);

  return;
}

/*
 * fprint_array2d
 *   DESCRIPTION: prints the array to the provided file pointer
 *   INPUTS: stream -- file pointer where data will be printed to
 *           arr -- array whose contents will be printed
 *           rows -- number of rows in arr
 *           cols -- number of cols in arr
 *   OUTPUTS: none
 *   RETURN VALUE: none
 *   SIDE EFFECTS: none
 */
void fprint_array2d(FILE *stream, int **arr, int rows, int cols)
{
  // Check if arr valid
  if (arr == NULL)
  {
    return;
  }

  for (int row = 0; row < rows; row++)
  {
    for (int col = 0; col < cols; col++)
    {
      fprintf(stream, "%d ", arr[row][col]);
    }
    fprintf(stream, "\n");
  }
}

/*
 * malloc_array2d
 *   DESCRIPTION: allocates a 2d array of size rows x cols
 *   INPUTS: rows -- number of rows in the 2d array
 *           cols -- number of columns in the 2d array
 *   OUTPUTS: none
 *   RETURN VALUE: pointer to the 2d array
 *   SIDE EFFECTS: none
 */
int **malloc_array2d(int rows, int cols)
{
  // Check if dimensions valid
  if (rows <= 0 || cols <= 0)
  {
    return NULL;
  }
  
  // Malloc outer array
  int **arr = (int **)malloc(rows * sizeof(int *));

  // Malloc inner arrays
  for (int i = 0; i < rows; i++)
  {
    arr[i] = (int *)malloc(cols * sizeof(int));
  }

  // Initialize all cells to 0 
  for (int row = 0; row < rows; row++)
  {
    for (int col = 0; col < cols; col++)
    {
      arr[row][col] = -1;
    }
  }

  // Return array
  return arr;
}

/*
 * update_array2d
 *   DESCRIPTION: updates the 2d array according to the rules specified in 
 *                Conway's Game of Life
 *   INPUTS: arr -- array to be updated
 *           rows -- number of rows in arr
 *           cols -- number of cols in arr
 *   OUTPUTS: none
 *   RETURN VALUES: none
 *   SIDE EFFECTS: none
 */
void update_array2d(int **arr, int rows, int cols)
{	
	int count = 0,x,y; // x is rows, y is columns
	int duplicate[rows][cols];
	for(x=0;x<rows;x++){
		for(y=0;y<cols;y++){
		duplicate[x][y] = arr[x][y];    // create duplicate array
 }
}
	for(x=0;x<rows;x++){
		for(y=0;y<cols;y++){
		if(arr[mod(x+1,rows)][y])
				count += 1;
		if(arr[x][mod(y+1,cols)])
				count += 1;
		if(arr[x][mod(y-1,cols)])
				count += 1;
		if(arr[mod(x+1,rows)][mod(y-1,cols)])
				count += 1;
		if(arr[mod(x-1,rows)][y])
				count += 1; 
		if(arr[mod(x-1,rows)][mod(y-1,cols)])    // calclulate the neighbors aliveness
				count += 1; 
		if(arr[mod(x-1,rows)][mod(y+1,cols)])
				count += 1;
		if(arr[mod(x+1,rows)][mod(y+1,cols)])
				count += 1;
		
		if(arr[x][y]){
			if(count<2)
				duplicate[x][y] = 0;
			if(count == 2 || count == 3)  // apply game rules 
				duplicate[x][y] = 1;
			if(count>3)
				duplicate[x][y] = 0;	
   }
			else{
			if(count == 3)
				duplicate[x][y] = 1;
   }
		count = 0; //reset the count
  }
 }
		for(x = 0;x<rows;x++){
			for(y=0;y<cols;y++){       // move the new board to the old 
			arr[x][y] = duplicate[x][y];
  }
 }
}

/*
 * read_data
 *   DESCRIPTION: reads the data from the file into the array
 *   INPUTS: file -- pointer to file where data is located
 *   OUTPUTS: arr -- pointer to 2d array where data will be read into
 *            rows -- pointer to rows data
 *            cols -- pointer to cols data
 *   RETURN VALUE: none
 *   SIDE EFFECTS: none
 */
void read_data(FILE *file, int ***arr, int *rows, int *cols)
{// printf("start1\n");
	int i = 0,j=0;
	int temp;
  // Malloc array
	fscanf(file,"%d %d\n ",rows,cols); // because rows and cols are already addresses
  *arr = malloc_array2d(*rows, *cols);
	for(i=0;i<(*rows);i++){
	 for(j=0;j<(*cols);j++){
    temp = fgetc(file);
    if(temp != '\n' && temp != 32){
			temp -= '0';
    		(*arr)[i][j] = temp;
  }
    else
    j--;
  }
 }
 
}
	
	
	
/*
 * print_board
 *   DESCRIPTION: prints the array to stdscr
 *   INPUTS: arr -- pointer to array whose data will be printed
 *           rows -- number of rows in arr
 *           cols -- number of cols in arr
 *   OUTPUTS: none
 *   RETURN VALUE: none
 *   SIDE EFFECTS: none
 */
void print_board(int **arr, int rows, int cols)
{
  // Initialize colors
  init_pair(1, COLOR_GREEN, COLOR_BLACK);

  // Print board to stdscr
  for (int row = 0; row < rows; row++)
  {
    for (int col = 0; col < cols; col++)
    {
      if (arr[row][col])
      {
        mvaddwstr(row, col, L"\u2588");
        mvchgat(row, col, 1, A_NORMAL, 1, NULL);
      }
      else
      {
        mvaddch(row, col, ' ');
      }
    }
  }

  // Print exit message
  mvaddstr(rows, 0, "To exit, press 'q'.");
  
  // Print stdscr to terminal
  refresh();
}
