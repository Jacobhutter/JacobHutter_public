//  This function adds two matrices such that C=A+B
//  Input:
//  A_matrix: pointer to an array containing the values of a matrix with n_rows and n_cols, in row major order
//  B_matrix: pointer to an array containing the values of a matrix with n_rows and n_cols, in row major order
//  C_matrix: pointer to an array containing the values of a matrix with n_rows and n_cols, in row major order
//  n_rows: the number of rows, assume>0
//  n_cols: the number of cols, assume>0
//  Return: None
//  Output: C=A+B 
void add_matrix(int* A_matrix, int* B_matrix, int* C_matrix, int n_rows, int n_cols){
  //YOUR CODE HERE
int i;
int total = n_rows*n_cols;
	for(i=0;i<total;i++)
	 C_matrix[i] = A_matrix[i] + B_matrix[i];
 
}



//  This function transposes in_matrix 
//  Input:
//  in_matrix: pointer to an array containing the values of a matrix with n_rows and n_cols, in row major order
//  n_rows: the number of rows in in_matrix, assume>0
//  n_cols: the number of cols in in_matrix, assume>0
//  Return: None
//  Output: out_matrix, pointer to an array containing the values of a matrix 

void transpose_matrix(int* in_matrix, int n_rows, int n_cols, int* out_matrix){
  //YOUR CODE HERE
int i,j;
	for(i=0;i<n_cols;i++){
	 for(j=0;j<n_rows;j++){
	  out_matrix[j*n_cols+i] = in_matrix[i*n_cols+j]; 
  }
 }
}


