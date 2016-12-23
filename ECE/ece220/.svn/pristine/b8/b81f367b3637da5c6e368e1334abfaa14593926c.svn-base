#include <stdio.h>
#include "matrix.h"

int main()
{
    int matrix_A1[12] = {-1, 3, 4, 
                         -2, 8, 9, 
                         10, 1, -1, 
                          8, 7, 3};
    int n_rows_A1=4, n_cols_A1=3;
    int matrix_A2[16] ={1, 2, 3, 4,
                        6, 7, 8, 9,
                        11,12,13,14,
                        16,17,18,19};
    int n_rows_A2=4, n_cols_A2=4;


    int matrix_B1[12] = {2, -3, 5, 
                         6, 8, 10, 
                         9, 1, -2, 
                         3, 2, 4};
    int matrix_B2[16] = {-2, 1, 4, 5,
                         8, 1, 3, -2, 
                         2, 6, 1, 9,
                         -9, 2, 3, 4};


    int matrix_C1[12];
    int matrix_C2[16];


    printf("*****Testing add_matrix*****\n");
    printf("Test 1\n"); //matrix_A1+matrix_B1
    int i;
    add_matrix(matrix_A1,matrix_B1,matrix_C1,n_rows_A1,n_cols_A1);
    printf("C_matrix: \n");
    for(i=0;i<12;i++){
        printf("%d ", matrix_C1[i]);
        if(i%n_cols_A1 == n_cols_A1-1){
                printf("\n");
        }
    } 
 
    printf("Test 2\n");//matrix_A2+matrix_B2
    add_matrix(matrix_A2,matrix_B2,matrix_C2,n_rows_A2,n_cols_A2);
    printf("C_matrix: \n"); 
    for(i=0;i<16;i++){
        printf("%d ", matrix_C2[i]);
        if(i%n_cols_A2 == n_cols_A2-1){
                printf("\n");
        }
    }


    int out_A1[12];
    int out_A2[16];

    printf("*****Testing transpose_matrix*****\n");
    printf("Test 1\n");//transpose matrix_A1
    printf("in_matrix A1: \n");
    for(i=0;i<12;i++){
	printf("%d ", matrix_A1[i]);
	if(i%n_cols_A1 == n_cols_A1-1){
		printf("\n");
	}
    }
    transpose_matrix(matrix_A1,n_rows_A1,n_cols_A1,out_A1);
    printf("out_matrix A1: \n");
    for(i=0;i<12;i++){
        printf("%d ", out_A1[i]);
        if(i%n_rows_A1 == n_rows_A1-1){
                printf("\n");
        }
    }

    printf("Test 2\n");//transpose matrix_A2
    printf("in_matrix A2: \n");
    for(i=0;i<16;i++){
        printf("%d ", matrix_A2[i]);
        if(i%n_cols_A2 == n_cols_A2-1){
                printf("\n");
        }
    }
    transpose_matrix(matrix_A2,n_rows_A2,n_cols_A2,out_A2);
    printf("out_matrix A2: \n");
    for(i=0;i<16;i++){
        printf("%d ", out_A2[i]);
        if(i%n_rows_A2 == n_rows_A2-1){
                printf("\n");
        }
    }


    return 0;
}


