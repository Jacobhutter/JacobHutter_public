#include "sparsemat.h"

#include <stdio.h>
#include <stdlib.h>
/*
This code, written by Jacob Hutter, will load data in any order of a matrix that is mostly zeroes. this code will then store it as a linked set
and be accessible in row major order for operations such as multiplication and additon, it can also store the sorted and or modified matrix in a file.
after that it will free the data allocated to the sets.
*/


int row_major(int original_row, int original_col, int new_row, int new_col){ // one means switch zero means dont 
 if(original_row > new_row)
 	return 1;
 if(original_row == new_row){
 	if(original_col > new_col)
 		return 1;
 	else
 		return 0;
}
 else 
 	return 0;

}



sp_tuples * load_tuples(char* input_file)
{	
    sp_tuples * new_tuple = (sp_tuples *)malloc(sizeof(sp_tuples));
	new_tuple->tuples_head=NULL;
	double temp = 0;
	int i,j;
	int count=0;
	int * new_address;
	new_address = NULL;
  FILE * fp = fopen(input_file,"r");
		if(fp == NULL){
		printf("FILE COULD NOT BE READ\n");
		return NULL;
}
		fscanf(fp,"%i %i ",&(new_tuple->m),&(new_tuple->n));  // get rows and col
		while(fscanf(fp,"%i %i %lf ",&i,&j,&temp) != EOF){
			set_tuples(new_tuple,i,j,temp); 
			if(temp != 0)
			 ++count; 
		}
		new_tuple->nz = count;
		
    return new_tuple; 
}



double gv_tuples(sp_tuples * mat_t,int row,int col)
{		double val=0;
 		sp_tuples_node * cur; // give the value of this node the address of the next 
		cur = mat_t->tuples_head;
		while(cur->row != row && cur->col != col){
			if(cur->next == NULL)
				break;
			cur = cur->next; // move to next node in the list 
}
	 if((row == cur->row) && (col == cur->col));
		 val = cur->value;
			
    return val;

}



void set_tuples(sp_tuples * mat_t, int row, int col, double value)
{	if(mat_t == NULL)
		return;
	if(value == 0){
	return;
}
	else{
		
		sp_tuples_node * current; 
		if(mat_t->tuples_head==NULL){  //empty list
			current =  (sp_tuples_node *)malloc(sizeof(sp_tuples_node));
			current->row = row;
			current->col = col;
			current->value = value;  // if current node is first then declare it as the head node for now 
			current->next = NULL;
			mat_t->tuples_head = current;
			//printf("initialize\n");
			return;
 		}
 
 		//
 		current = mat_t->tuples_head;
 		sp_tuples_node * follower;
 		sp_tuples_node * add  = (sp_tuples_node *)malloc(sizeof(sp_tuples_node));
 		add->row = row;
 		add->col = col; // node to be added
 		add->value = value;
 		if(row_major(mat_t->tuples_head->row,mat_t->tuples_head->col,row,col)){ //if current head is bigger than the possible node
 			add->next = mat_t->tuples_head;
 			mat_t->tuples_head = add;
 			return;
 	}
		if(mat_t->tuples_head->row == row && mat_t->tuples_head->col == col){
			mat_t->tuples_head->value += value;
			return;
}
 		while(current!=NULL){
		if(current->row == row && current->col == col){
			current->value += value;
			return;
}
 		 follower = current;
 		 current = current->next;
 		if(current != NULL){
 		 if(row_major(current->row,current->col,row,col)){  // if we find one that is bigger 
 		 	follower->next = add; // have the following node be the node that points to added
 		 	add->next = current; // have add point to current which is bigger
 		 	return;
 		 }
 		 }
 	    }
 	    follower->next = add; // have the following node be the node that points to added
 		 	add->next = current; // have add point to current which is bigger
 		 	//if current ends up being null it means our potential add is the biggest on the current list
   
}
    return;
}


void save_tuples(char * file_name, sp_tuples * mat_t)
{	if(mat_t == NULL)
		return;
	sp_tuples_node * cur;
	int max_cols;
	int max_rows;
	max_cols = mat_t->n; // get matrix columns
	max_rows = mat_t->m; // get matrix rows
	cur = mat_t->tuples_head;
	
		FILE * fp = fopen(file_name,"w");
			if(fp == NULL)
				printf("COULD NOT OPEN FILE\n");
		fprintf(fp,"%i %i\n",max_rows,max_cols);
		while(cur != NULL){	
			if(cur->value != 0){
			fprintf(fp,"%d %d %lf\n",cur->row,cur->col,cur->value);
			}
			cur = cur->next; // because current starts off pointing to head	
}
		fclose(fp);
	return;
	
}



sp_tuples * add_tuples(sp_tuples * matA, sp_tuples * matB){
	if (matA == NULL || matB == NULL)
		return 0;
	sp_tuples * matC = (sp_tuples *)malloc(sizeof(sp_tuples));
	matC->m = matA->m;
	matC->n = matA->n;
	sp_tuples_node * A = matA->tuples_head;
	while(A != NULL){
		set_tuples(matC,A->row,A->col,A->value); // uses set_tuples to add the vals to C 
		A=A->next;

}
	sp_tuples_node * B = matB->tuples_head;
	while(B != NULL){
		set_tuples(matC,B->row,B->col,B->value);
		B=B->next;
}	
	sp_tuples_node * C = matC->tuples_head;
	while(C != NULL){
	if(C->value != 0)
		++matC->nz;
	C = C->next;

}
	 
	return matC;
	
	
}



sp_tuples * mult_tuples(sp_tuples * matA, sp_tuples * matB){ 
	if(matA == NULL || matB == NULL)
		return 0;
	if(matA->n != matB->m)
		return 0;
	double val = 0;
	sp_tuples * matC = (sp_tuples *)malloc(sizeof(sp_tuples));
	matC->m=matA->m;
	matC->n=matB->n; // set rows and cols
	sp_tuples_node * A = matA->tuples_head;
	sp_tuples_node * B = matB->tuples_head;
		while(A!=NULL){
 			while(B!=NULL){
 				if(B->row == A->col){
 					val = A->value * B->value;
 				set_tuples(matC,A->row,B->col,val);
  }
 		B = B->next;
  }
  		A=A->next;
  		B = matB->tuples_head;
 }
 
 
 	sp_tuples_node * C = matC->tuples_head;
	while(C != NULL){
	if(C->value != 0)
		++matC->nz;
	C = C->next;
	}
    return matC;
    
    return 0;
}

void recursive_free(sp_tuples_node * head){
 	if(head == NULL)
		return;
	if(head->next == NULL){
		free(head); // calls recursively to go through the lisst
		return;
}
	else
		recursive_free(head->next);
 return;
}
	
void destroy_tuples(sp_tuples * mat_t){
	if(mat_t != NULL){
	recursive_free(mat_t->tuples_head);
}
	free(mat_t);
    return;
}  





