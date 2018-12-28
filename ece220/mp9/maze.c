#include <stdio.h>
#include <stdlib.h>
#include "maze.h"
#include <math.h>

/* This code, written by Jacob Hutter, will solve a maze given that it is solvable in the first place. 
		it uses the DFS manhattan heuristic to find the shortest path from any point and use that to make an educated guess.
		if it reaches a dead end, it will mark the path it took as dead with a ~ and backtrack back to the last choice it had to 
		make. it will recurse until it finds E
*/


/*
 * createMaze -- Creates and fills a maze structure from the given file
 * INPUTS:       fileName - character array containing the name of the maze file
 * OUTPUTS:      None 
 * RETURN:       A filled maze structure that represents the contents of the input file
 * SIDE EFFECTS: None
 */
maze_t * createMaze(char * fileName)
{		int i,j,tmp=0;
    maze_t * newMaze = (maze_t *)malloc(sizeof(maze_t));
		FILE * fp;
		fp = fopen(fileName,"r");	
		
			if(fp == NULL){
				printf ("file could not be read \n");
			return NULL;
           }
           
		fscanf(fp,"%i %i",&(newMaze->width),&(newMaze->height)); // get height and width 

		newMaze->cells = (char **)calloc(newMaze->height,sizeof(char *));
		for(i=0;i<newMaze->height;i++)
		newMaze->cells[i] = (char *)calloc(newMaze->width,sizeof(char));
		fgetc(fp); // eliminate initial \n 
		for(i = newMaze->height-1;i>=0;i--){
		 for(j = 0;j<newMaze->width;j++){
		 	tmp = fgetc(fp);
		 	if(tmp != '\n')
		newMaze->cells[i][j] = tmp;
			else
				--j; // account for fact that \n will increment the columns
		if(newMaze->cells[i][j] == 'S'){
			newMaze->startRow = i+1;
			newMaze->startColumn = j+1;    // marks begining 
   }
		if(newMaze->cells[i][j] == 'E'){
			newMaze->endRow = i+1;
			newMaze->endColumn = j+1;     // marks end
   }
  }
 }
    return newMaze;
}

/*
 * destroyMaze -- Frees all memory associated with the maze structure, including the structure itself
 * INPUTS:        maze -- pointer to maze structure that contains all necessary information 
 * OUTPUTS:       None
 * RETURN:        None
 * SIDE EFFECTS:  All memory that has been allocated for the maze is freed
 */
void destroyMaze(maze_t * maze)
{ 
   free(maze->cells);
	 free(maze); // frees all memory
}

/*
 * printMaze --  Prints out the maze in a human readable format (should look like examples)
 * INPUTS:       maze -- pointer to maze structure that contains all necessary information 
 *               width -- width of the maze
 *               height -- height of the maze
 * OUTPUTS:      None
 * RETURN:       None
 * SIDE EFFECTS: Prints the maze to the console
 */
void printMaze(maze_t * maze)
{	
    int i,j;
		printf("%i %i",maze->height,maze->width);
		printf("\n");
		for(i = maze->height-1;i>=0;i--){	
		 for(j = 0;j<maze->width;j++)
			printf("%c",maze->cells[i][j]);
  
  printf("\n");
 }
}

/*
 * solveMazeManhattanDFS -- recursively solves the maze using depth first search and a manhattan distance heuristic
 * INPUTS:               maze -- pointer to maze structure with all necessary maze information
 *                       col -- the column of the cell currently beinging visited within the maze
 *                       row -- the row of the cell currently being visited within the maze
 * OUTPUTS:              None
 * RETURNS:              0 if the maze is unsolvable, 1 if it is solved
 * SIDE EFFECTS:         Marks maze cells as visited or part of the solution path
 */ 
int solveMazeManhattanDFS(maze_t * maze, int col, int row)
{		int i,swap=1,temp = 0,temp2 = 0,set = 0;

			if(maze->cells[row-1][col-1] == '%'){
				return 0;
 }
			if(maze->cells[row-1][col-1] == '~'){
				return 0;
 }
	    if(col > maze->width || col < 1 || row < 1 || row > maze->height){
			return 0;
 }
		if(maze->cells[row-1][col-1] == 'E')
			return 1;
		if(maze->cells[row-1][col-1] != 'S')
		maze->cells[row-1][col-1] = '.'; 
		int Row = maze->endRow;
		int Col = maze->endColumn;
		int MD1,MD2,MD3,MD4;
		
		MD1 = abs((Row)-(row-1))+abs(Col-col);
		MD2 = abs((Row)-(row+1))+abs(Col-col);
		MD3 = abs((Row)-(row))+abs(Col-(col-1));   // calculates manhattan distance
		MD4 = abs((Row)-(row-1))+abs(Col-(col+1));
		int ARRAY[4][2];
			ARRAY[0][0] = MD1;
			ARRAY[0][1] = 1;
			ARRAY[1][0] = MD2;
			ARRAY[1][1] = 2;
			ARRAY[2][0] = MD3;    // makes a table of MD(N) with corresponding tag to tell which order they are in
			ARRAY[2][1] = 3;
			ARRAY[3][0] = MD4;
			ARRAY[3][1] = 4;
		while(swap!=0){
			swap = 0;
		for(i=1;i<=3;i++){
			if(ARRAY[i][0] < ARRAY[i-1][0]){
				temp = ARRAY[i][0];
				temp2 = ARRAY[i][1]; // get case 
				ARRAY[i][0] = ARRAY[i-1][0];
				ARRAY[i][1] = ARRAY[i-1][1];          // sorts in lowest to biggest 
				ARRAY[i-1][0] = temp;
				ARRAY[i-1][1] = temp2;
				++swap;
   }		
  }
 }
	for(i=0;i<=3;i++){
	 set = ARRAY[i][1];	//get next smallest value 
	 switch(set){
  
	case 1: 
	if(maze->cells[row-2][col-1] != '.'){
	if(solveMazeManhattanDFS(maze,col,row-1)==1)  // the if '.' will assure no infinite loops of going backwards unless it has to
			return 1;
  }
	break;

  case 2:
		if(maze->cells[row][col-1] != '.'){
		if(solveMazeManhattanDFS(maze,col,row+1)==1)
			return 1; 
    }
		break;

  case 3:
		if(maze->cells[row-1][col-2] != '.'){
		if(solveMazeManhattanDFS(maze,col-1,row)==1)
			return 1; 
		}
		break;
	
	case 4:
		if(maze->cells[row-1][col] != '.'){
		if(solveMazeManhattanDFS(maze,col+1,row)==1)
			return 1;
    }
		break;

	default:
		break;
 }
}	
	if(maze->cells[row-1][col-1] == '.')   // this will make sure no cells that arent visitied are marked with ~ 
	   maze->cells[row-1][col-1] = '~';
    return 0;
}

