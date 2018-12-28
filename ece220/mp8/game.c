#include "game.h"
/* This code, written by jacob hutter, will effectively mimic the game 2048.
the functions make game and remake game will initialize a structure variable game board of type game while the functions w a s and d 
shift the board and combine like terms. the last tricky function checks for any possible moves and decide if the game is over. */

game * make_game(int rows, int cols)
/*! Create an instance of a game structure with the given number of rows
    and columns, initializing elements to -1 and return a pointer
    to it. (See game.h for the specification for the game data structure) 
    The needed memory should be dynamically allocated with the malloc family
    of functions.
*/
{   
    //Dynamically allocate memory for game and cells (DO NOT modify this)
    game * mygame = malloc(sizeof(game));
    mygame->cells = malloc(rows*cols*sizeof(cell));
    //YOUR CODE STARTS HERE:  Initialize all other variables in game struct
  
	int i = 0; //row index
	int j = 0; // column index
  (*mygame).rows = rows;
	(*mygame).cols = cols;
	(*mygame).score = 0;
	
		
	 for (i=0;i<rows;i++){
		for (j=0;j<cols;j++){
    (*mygame).cells[i*cols+j] = (-1);       // initializes game board to -1 
 }
}

    return mygame;
}

void remake_game(game ** _cur_game_ptr,int new_rows,int new_cols)
/*! Given a game structure that is passed by reference, change the
	game structure to have the given number of rows and columns. Initialize
	the score and all elements in the cells to -1. Make sure that any 
	memory previously allocated is not lost in this function.	
*/
{
	/*Frees dynamically allocated memory used by cells in previous game,
	 then dynamically allocates memory for cells in new game.  DO NOT MODIFY.*/
	free((*_cur_game_ptr)->cells);
	(*_cur_game_ptr)->cells = malloc(new_rows*new_cols*sizeof(cell));

	 //YOUR CODE STARTS HERE:  Re-initialize all other variables in game struct
	(**_cur_game_ptr).rows = new_rows;
	(**_cur_game_ptr).cols = new_cols;
	(**_cur_game_ptr).score = 0;
int i = 0; //row index
	int j = 0; // column index
	 for (i=0;i<new_rows;i++){
		for (j=0;j<new_cols;j++){
    (**_cur_game_ptr).cells[i*new_cols+j] = (-1);       // initializes game board to -1 
 }
}
	return;	
}

void destroy_game(game * cur_game)
/*! Deallocate any memory acquired with malloc associated with the given game instance.
    This includes any substructures the game data structure contains. Do not modify this function.*/
{
    free(cur_game->cells);
    free(cur_game);
    cur_game = NULL;
    return;
}

cell * get_cell(game * cur_game, int row, int col)
/*! Given a game, a row, and a column, return a pointer to the corresponding
    cell on the game. (See game.h for game data structure specification)
    This function should be handy for accessing game cells. Return NULL
	if the row and col coordinates do not exist.
*/
{
    //YOUR CODE STARTS HERE
		int *x;
	int rows = (*cur_game).rows;
	int cols = (*cur_game).cols;
	 if(rows<row || cols<col)
    return NULL;
	 else{
 	x = &(*cur_game).cells[row*(*cur_game).cols+col];
	return x;
 }
}

int move_w(game * cur_game)
/*!Slides all of the tiles in cur_game upwards. If a tile matches with the 
   one above it, the tiles are merged by adding their values together. When
   tiles merge, increase the score by the value of the new tile. A tile can 
   not merge twice in one turn. If sliding the tiles up does not cause any 
   cell to change value, w is an invalid move and return 0. Otherwise, return 1. 
*/
{
	int i,j,target,last_combined_row,match = 0;
	int test[(*cur_game).cols*(*cur_game).rows];
		for(i=0;i<(*cur_game).rows;i++){
	 for(j=0;j<(*cur_game).cols;j++){
     test[i*(*cur_game).cols +j] = (*cur_game).cells[i*(*cur_game).cols+j];    // make test array
	}
 }
  
	for(i=0;i<(*cur_game).cols;i++){
	 target = 0;	
	 last_combined_row=0;
	 for(j=1;j<(*cur_game).rows;j++){
		target = 0;
	 	if((*cur_game).cells[j*(*cur_game).cols+i] != -1){
	 	 while((*cur_game).cells[target*(*cur_game).cols +i] != -1 && target < j){
	 	  target +=1;
	 }
	    if(target<j){
			//printf("%i %i flag %i\n",i,j,target);
	    (*cur_game).cells[target*(*cur_game).cols+i] = (*cur_game).cells[j*(*cur_game).cols+i];
	    (*cur_game).cells[j*(*cur_game).cols+i] = -1;
	 }
	    if((*cur_game).cells[(target-1)*(*cur_game).cols + i] != last_combined_row){
			 if((*cur_game).cells[(target-1)*(*cur_game).cols + i] == (*cur_game).cells[target*(*cur_game).cols + i]){
					(*cur_game).cells[(target-1)*(*cur_game).cols + i] += (*cur_game).cells[(target-1)*(*cur_game).cols + i]; // this portion will check for combinations
					(*cur_game).cells[target*(*cur_game).cols + i] = -1;
					last_combined_row = (*cur_game).cells[(target-1)*(*cur_game).cols + i];
					(*cur_game).score += last_combined_row;
     }
    }
   }    
  }
 }
	for(i=0;i<(*cur_game).rows;i++){
	 for(j=0;j<(*cur_game).cols;j++){
     if((*cur_game).cells[i*(*cur_game).cols +j] != test[i*(*cur_game).cols + j])    // check if no change has occurred 
			 match += 1;
	 }
	}
	if(match == 0)
		return 0;
		

		
    return 1;
}

int move_s(game * cur_game) //slide down
{
    	int i,j,target,last_combined_row,match = 0;
	    int test[(*cur_game).cols*(*cur_game).rows];
		for(i=0;i<(*cur_game).rows;i++){
	 for(j=0;j<(*cur_game).cols;j++){
     test[i*(*cur_game).cols +j] = (*cur_game).cells[i*(*cur_game).cols+j];    // make test array
	 }
	}
  
	for(i=0;i<(*cur_game).cols;i++){
	 target = ((*cur_game).rows-1);	
	 last_combined_row = 0;
	 for(j=(*cur_game).rows-1;j>=0;j--){
		target = ((*cur_game).rows-1);
	 	if((*cur_game).cells[j*(*cur_game).cols+i] != -1){
	 	 while((*cur_game).cells[target*(*cur_game).cols +i] != -1 && target > j){ // changes here 
	 	  target -=1;
	 }
	    if(target>j){
	    (*cur_game).cells[target*(*cur_game).cols+i] = (*cur_game).cells[j*(*cur_game).cols+i];
	    (*cur_game).cells[j*(*cur_game).cols+i] = -1;
	 }
	    if((*cur_game).cells[(target+1)*(*cur_game).cols + i] != last_combined_row){
			 if((*cur_game).cells[(target+1)*(*cur_game).cols + i] == (*cur_game).cells[target*(*cur_game).cols + i]){
					(*cur_game).cells[(target+1)*(*cur_game).cols + i] += (*cur_game).cells[(target+1)*(*cur_game).cols + i];
					(*cur_game).cells[target*(*cur_game).cols + i] = -1;
					last_combined_row = (*cur_game).cells[(target+1)*(*cur_game).cols + i];
					(*cur_game).score += last_combined_row;
     }
    }
   }    
  }
 }
	for(i=0;i<(*cur_game).rows;i++){
	 for(j=0;j<(*cur_game).cols;j++){
     if((*cur_game).cells[i*(*cur_game).cols +j] != test[i*(*cur_game).cols + j])     // check if no change has occurred 
			 match += 1;
	 }
	}
	if(match == 0)
		return 0;

    return 1;
}

int move_a(game * cur_game) //slide left
{
 	int i,j,target,last_combined_col,match = 0;
	int test[(*cur_game).cols*(*cur_game).rows];
		for(i=0;i<(*cur_game).rows;i++){
	 for(j=0;j<(*cur_game).cols;j++){
     test[i*(*cur_game).cols +j] = (*cur_game).cells[i*(*cur_game).cols+j];    // make test array
	}
 }
  
	for(j=0;j<(*cur_game).rows;j++){
	 target = 0;	
	 last_combined_col=-1;
	 for(i=1;i<(*cur_game).cols;i++){
		target = 0;
	 	if((*cur_game).cells[j*(*cur_game).cols+i] != -1){
	 	 while((*cur_game).cells[j*(*cur_game).cols +target] != -1 && (target < i)){
	 	  target +=1;
	 }
	    if(target<i){
	    (*cur_game).cells[j*(*cur_game).cols+target] = (*cur_game).cells[j*(*cur_game).cols+i];
	    (*cur_game).cells[j*(*cur_game).cols+i] = -1;
	 }
	    if((target-1) != last_combined_col){
			 if((*cur_game).cells[j*(*cur_game).cols + (target-1)] == (*cur_game).cells[j*(*cur_game).cols + target]){
					(*cur_game).cells[j*(*cur_game).cols + (target-1)] += (*cur_game).cells[j*(*cur_game).cols + (target-1)];       //// 
					(*cur_game).cells[j*(*cur_game).cols + target] = -1;
					last_combined_col = target - 1; 
					cur_game->score += cur_game->cells[j*cur_game->cols + (target - 1)]; 
     }
    }
   }    
  }
 }
	for(i=0;i<(*cur_game).rows;i++){
	 for(j=0;j<(*cur_game).cols;j++){
     if((*cur_game).cells[i*(*cur_game).cols +j] != test[i*(*cur_game).cols + j])    // check if no change has occurred 
			 match += 1;
	 }
	}
	if(match == 0)
		return 0;
		

		
    return 1;
}

int move_d(game * cur_game){ //slide to the right
    int i,j,target,last_combined_col,match = 0;
	  int test[(*cur_game).cols*(*cur_game).rows];
		for(i=0;i<(*cur_game).rows;i++){
	 for(j=0;j<(*cur_game).cols;j++){
     test[i*(*cur_game).cols +j] = (*cur_game).cells[i*(*cur_game).cols+j];    // make test array
	}
 }
  
	for(j=0;j<(*cur_game).rows;j++){
	 target = (*cur_game).cols-1;	
	 last_combined_col=cur_game->cols;
	 for(i=(*cur_game).cols-2;i>=0;i--){
	 target = (*cur_game).cols-1;
	 	if((*cur_game).cells[j*(*cur_game).cols+i] != -1){
	 	 while((*cur_game).cells[j*(*cur_game).cols +target] != -1 && (target > i)){
	 	  target -=1;
	 }
	    if(target>i){
	    (*cur_game).cells[j*(*cur_game).cols+target] = (*cur_game).cells[j*(*cur_game).cols+i];
	    (*cur_game).cells[j*(*cur_game).cols+i] = -1;
	 }
	    if((target+1) != last_combined_col){
			 if((*cur_game).cells[j*(*cur_game).cols + (target+1)] == (*cur_game).cells[j*(*cur_game).cols + target]){
					(*cur_game).cells[j*(*cur_game).cols + (target+1)] += (*cur_game).cells[j*(*cur_game).cols + (target+1)];           /// errors in here probably
					(*cur_game).cells[j*(*cur_game).cols + target] = -1;
					last_combined_col = (target+1);                                                 /////////
					cur_game->score += cur_game->cells[j*cur_game->cols + (target+1)]; 
     }
    }
   }    
  }
 }
	for(i=0;i<(*cur_game).rows;i++){
	 for(j=0;j<(*cur_game).cols;j++){
     if((*cur_game).cells[i*(*cur_game).cols +j] != test[i*(*cur_game).cols + j])    // check if no change has occurred 
			 match += 1;
	 }
	}
	if(match == 0)
		return 0;
		

		
    return 1;
}

int legal_move_check(game * cur_game)
/*! Given the current game check if there are any legal moves on the board. There are
    no legal moves if sliding in any direction will not cause the game to change.
	Return 1 if there are possible legal moves, 0 if there are none.
 */
{		
	int cur_tile = 0;
	int right_tile = 0;
	int down_tile = 0;
	int i,j;
	int moves = 0;
	for(i=0;i<(*cur_game).rows;i++){
			for(j=0;j<(*cur_game).cols;j++){
			if((*cur_game).cells[i*(*cur_game).cols+j] == -1)  // check if any empty cells
				moves += 1;
  } 
 }

	for(i=0;i<((*cur_game).cols-1);i++){
		for(j=0;j<(*cur_game).rows;j++){
		cur_tile = (*cur_game).cells[(j*(*cur_game).cols+i)];      // sweep right to check 
		right_tile = (*cur_game).cells[(j*(*cur_game).cols+i+1)];
		if(cur_tile == right_tile)
				moves +=1; 
  }
 }
	
	for(j=0;j<((*cur_game).rows-1);j++){
		for(i=0;i<(*cur_game).cols;i++){
		cur_tile = (*cur_game).cells[(j*(*cur_game).cols+i)];      // sweep down to check 
		down_tile = (*cur_game).cells[((j+1)*(*cur_game).cols+i)];
		if(cur_tile == down_tile)
				moves +=1;
  }
 }

			if(moves>0)
				return 1;
			else 
				return 0;
}


/*! code below is provided and should not be changed */

void rand_new_tile(game * cur_game)
/*! insert a new tile into a random empty cell. First call rand()%(rows*cols) to get a random value between 0 and (rows*cols)-1.
*/
{
	
	cell * cell_ptr;
    cell_ptr = 	cur_game->cells;
	
    if (cell_ptr == NULL){ 	
        printf("Bad Cell Pointer.\n");
        exit(0);
    }
	
	
	//check for an empty cell
	int emptycheck = 0;
	int i;
	
	for(i = 0; i < ((cur_game->rows)*(cur_game->cols)); i++){
		if ((*cell_ptr) == -1){
				emptycheck = 1;
				break;
		}		
        cell_ptr += 1;
	}
	if (emptycheck == 0){
		printf("Error: Trying to insert into no a board with no empty cell. The function rand_new_tile() should only be called after tiles have succesfully moved, meaning there should be at least 1 open spot.\n");
		exit(0);
	}
	
    int ind,row,col;
	int num;
    do{
		ind = rand()%((cur_game->rows)*(cur_game->cols));
		col = ind%(cur_game->cols);
		row = ind/cur_game->cols;
    } while ( *get_cell(cur_game, row, col) != -1);
        //*get_cell(cur_game, row, col) = 2;
	num = rand()%20;
	if(num <= 1){
		*get_cell(cur_game, row, col) = 4; // 1/10th chance
	}
	else{
		*get_cell(cur_game, row, col) = 2;// 9/10th chance
	}
}

int print_game(game * cur_game) 
{
    cell * cell_ptr;
    cell_ptr = 	cur_game->cells;

    int rows = cur_game->rows;
    int cols = cur_game->cols;
    int i,j;
	
	printf("\n\n\nscore:%d\n",cur_game->score); 
	
	
	printf("\u2554"); // topleft box char
	for(i = 0; i < cols*5;i++)
		printf("\u2550"); // top box char
	printf("\u2557\n"); //top right char 
	
	
    for(i = 0; i < rows; i++){
		printf("\u2551"); // side box char
        for(j = 0; j < cols; j++){
            if ((*cell_ptr) == -1 ) { //print asterisks
                printf(" **  "); 
            }
            else {
                switch( *cell_ptr ){ //print colored text
                    case 2:
                        printf("\x1b[1;31m%04d\x1b[0m ",(*cell_ptr));
                        break;
                    case 4:
                        printf("\x1b[1;32m%04d\x1b[0m ",(*cell_ptr));
                        break;
                    case 8:
                        printf("\x1b[1;33m%04d\x1b[0m ",(*cell_ptr));
                        break;
                    case 16:
                        printf("\x1b[1;34m%04d\x1b[0m ",(*cell_ptr));
                        break;
                    case 32:
                        printf("\x1b[1;35m%04d\x1b[0m ",(*cell_ptr));
                        break;
                    case 64:
                        printf("\x1b[1;36m%04d\x1b[0m ",(*cell_ptr));
                        break;
                    case 128:
                        printf("\x1b[31m%04d\x1b[0m ",(*cell_ptr));
                        break;
                    case 256:
                        printf("\x1b[32m%04d\x1b[0m ",(*cell_ptr));
                        break;
                    case 512:
                        printf("\x1b[33m%04d\x1b[0m ",(*cell_ptr));
                        break;
                    case 1024:
                        printf("\x1b[34m%04d\x1b[0m ",(*cell_ptr));
                        break;
                    case 2048:
                        printf("\x1b[35m%04d\x1b[0m ",(*cell_ptr));
                        break;
                    case 4096:
                        printf("\x1b[36m%04d\x1b[0m ",(*cell_ptr));
                        break;
                    case 8192:
                        printf("\x1b[31m%04d\x1b[0m ",(*cell_ptr));
                        break;
					default:
						printf("  X  ");

                }

            }
            cell_ptr++;
        }
	printf("\u2551\n"); //print right wall and newline
    }
	
	printf("\u255A"); // print bottom left char
	for(i = 0; i < cols*5;i++)
		printf("\u2550"); // bottom char
	printf("\u255D\n"); //bottom right char
	
    return 0;
}

int process_turn(const char input_char, game* cur_game) //returns 1 if legal move is possible after input is processed
{ 
	int rows,cols;
	char buf[200];
	char garbage[2];
    int move_success = 0;
	
    switch ( input_char ) {
    case 'w':
        move_success = move_w(cur_game);
        break;
    case 'a':
        move_success = move_a(cur_game);
        break;
    case 's':
        move_success = move_s(cur_game);
        break;
    case 'd':
        move_success = move_d(cur_game);
        break;
    case 'q':
        destroy_game(cur_game);
        printf("\nQuitting..\n");
        return 0;
        break;
	case 'n':
		//get row and col input for new game
		dim_prompt: printf("NEW GAME: Enter dimensions (rows columns):");
		while (NULL == fgets(buf,200,stdin)) {
			printf("\nProgram Terminated.\n");
			return 0;
		}
		
		if (2 != sscanf(buf,"%d%d%1s",&rows,&cols,garbage) ||
		rows < 0 || cols < 0){
			printf("Invalid dimensions.\n");
			goto dim_prompt;
		} 
		
		remake_game(&cur_game,rows,cols);
		
		move_success = 1;
		
    default: //any other input
        printf("Invalid Input. Valid inputs are: w, a, s, d, q, n.\n");
    }

	
	
	
    if(move_success == 1){ //if movement happened, insert new tile and print the game.
         rand_new_tile(cur_game); 
		 print_game(cur_game);
    } 

    if( legal_move_check(cur_game) == 0){  //check if the newly spawned tile results in game over.
        printf("Game Over!\n");
        return 0;
    }
    return 1;
}
