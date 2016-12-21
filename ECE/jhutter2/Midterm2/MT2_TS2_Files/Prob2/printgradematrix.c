#include <stdio.h>
#include "matrix.h"

int iabs(int in){
    if(in<0){return in*-1;}
    return in;
}
int main()
{
    int matrix_A1[4]={1,2,3,4};
    int n_rows_A1=1, n_cols_A1=4;
    int matrix_A2[12] = {-1, 3, 4, 
                         -2, 8, 9, 
                         10, 1, -1, 
                          8, 7, 3};
    int n_rows_A2=4, n_cols_A2=3;
    int matrix_A3[16] ={1, 2, 3, 4,
                        6, 7, 8, 9,
                        11,12,13,14,
                        16,17,18,19};
    int n_rows_A3=4, n_cols_A3=4;


    int matrix_B1[4]={5,6,7,8};
    int matrix_B2[12] = {2, -3, 5, 
                         6, 8, 10, 
                         9, 1, -2, 
                         3, 2, 4};
    int matrix_B3[16] = {-2, 1, 4, 5,
                         8, 1, 3, -2, 
                         2, 6, 1, 9,
                         -9, 2, 3, 4};


    int matrix_C1[4];
    int matrix_C2[12];
    int matrix_C3[16];

    int matrix_goldC1[4]={6, 8, 10, 12}; 
    int matrix_goldC2[12]={1, 0, 9, 
4, 16, 19, 
19, 2, -3, 
11, 9, 7}; 
    int matrix_goldC3[16]={-1, 3, 7, 9, 
14, 8, 11, 7, 
13, 18, 14, 23, 
7, 19, 21, 23}; 

    int addpass = 0;
    printf("*****Testing add_matrix*****\n");
    printf("Test 1: "); //matrix_A1+matrix_B1
    int i;
    add_matrix(matrix_A1,matrix_B1,matrix_C1,n_rows_A1,n_cols_A1);
    int error = 0;
    for(i=0;i<4;i++){error = error+iabs(matrix_goldC1[i]-matrix_C1[i]);}
    if(error==0){printf("PASS\n");
    addpass++;}
    else{printf("FAIL\n");}
    printf("Student C_matrix: \n");
    for(i=0;i<4;i++){
        printf("%d ", matrix_C1[i]);
        if(i%n_cols_A1 == n_cols_A1-1){
                printf("\n");
        }
    } 
    printf("Gold C_matrix: \n");
    for(i=0;i<4;i++){
        printf("%d ", matrix_goldC1[i]);
        if(i%n_cols_A1 == n_cols_A1-1){
                printf("\n");
        }
    }
    printf("Test 2: ");//matrix_A2+matrix_B2
    add_matrix(matrix_A2,matrix_B2,matrix_C2,n_rows_A2,n_cols_A2);
    error = 0;
    for(i=0;i<4;i++){error = error+iabs(matrix_goldC2[i]-matrix_C2[i]);}
    if(error==0){printf("PASS\n");
    addpass++;}
    else{printf("FAIL\n");}
    printf("Student C_matrix: \n");
    for(i=0;i<12;i++){
        printf("%d ", matrix_C2[i]);
        if(i%n_cols_A2 == n_cols_A2-1){
                printf("\n");
        }
    } 
    printf("Gold C_matrix: \n");
    for(i=0;i<12;i++){
        printf("%d ", matrix_goldC2[i]);
        if(i%n_cols_A2 == n_cols_A2-1){
                printf("\n");
        }
    }
    printf("Test 3: ");//matrix_A2+matrix_B2
    add_matrix(matrix_A3,matrix_B3,matrix_C3,n_rows_A3,n_cols_A3);
    error = 0;
    for(i=0;i<16;i++){error = error+iabs(matrix_goldC3[i]-matrix_C3[i]);}
    if(error==0){printf("PASS\n");
    addpass++;}
    else{printf("FAIL\n");}
    printf("Student C_matrix: \n");
    for(i=0;i<16;i++){
        printf("%d ", matrix_C3[i]);
        if(i%n_cols_A3 == n_cols_A3-1){
                printf("\n");
        }
    } 
    printf("Gold C_matrix: \n");
    for(i=0;i<16;i++){
        printf("%d ", matrix_goldC3[i]);
        if(i%n_cols_A3 == n_cols_A3-1){
                printf("\n");
        }
    }

    int matrix_in1[4]={1,2,3,4};
    int n_rows_in1=1, n_cols_in1=4;
    int matrix_in2[12] = {-1, 3, 4, 
                         -2, 8, 9, 
                         10, 1, -1, 
                          8, 7, 3};
    int n_rows_in2=4, n_cols_in2=3;
    int matrix_in3[16] ={1, 2, 3, 4,
                        6, 7, 8, 9,
                        11,12,13,14,
                        16,17,18,19};
    int n_rows_in3=4, n_cols_in3=4;
    int out_goldA1[4]={1, 
2, 
3, 
4}; 
    int out_goldA2[12]={-1, -2, 10, 8, 
3, 8, 1, 7, 
4, 9, -1, 3}; 
    int out_goldA3[16]={1, 6, 11, 16, 
2, 7, 12, 17, 
3, 8, 13, 18, 
4, 9, 14, 19}; 

    int out_A1[4];
    int out_A2[12];
    int out_A3[16];

    int transposepass=0;
    printf("*****Testing transpose_matrix*****\n");
    printf("Test 1: "); 
    transpose_matrix(matrix_in1,n_rows_in1,n_cols_in1,out_A1);
    error = 0;
    for(i=0;i<4;i++){error = error+iabs(out_goldA1[i]-out_A1[i]);}
    if(error==0){printf("PASS\n");
    transposepass++;}
    else{printf("FAIL\n");}
    printf("Student out matrix: \n");
    for(i=0;i<4;i++){
        printf("%d ", out_A1[i]);
        if(i%n_cols_in1 == n_cols_in1-1){
                printf("\n");
        }
    } 
    printf("Gold out matrix: \n");
    for(i=0;i<4;i++){
        printf("%d ", out_goldA1[i]);
        if(i%n_cols_in1 == n_cols_in1-1){
                printf("\n");
        }
    }

    printf("Test 2: "); 
    transpose_matrix(matrix_in2,n_rows_in2,n_cols_in2,out_A2);
    error = 0;
    for(i=0;i<12;i++){error = error+iabs(out_goldA2[i]-out_A2[i]);}
    if(error==0){printf("PASS\n");
    transposepass++;}
    else{printf("FAIL\n");}
    printf("Student out matrix: \n");
    for(i=0;i<12;i++){
        printf("%d ", out_A2[i]);
        if(i%n_cols_in2 == n_cols_in2-1){
                printf("\n");
        }
    } 
    printf("Gold out matrix: \n");
    for(i=0;i<12;i++){
        printf("%d ", out_goldA2[i]);
        if(i%n_cols_in2 == n_cols_in2-1){
                printf("\n");
        }
    }

    printf("Test 3: "); 
    transpose_matrix(matrix_in3,n_rows_in3,n_cols_in3,out_A3);
    error = 0;
    for(i=0;i<16;i++){error = error+iabs(out_goldA3[i]-out_A3[i]);}
    if(error==0){printf("PASS\n");
    transposepass++;}
    else{printf("FAIL\n");}
    printf("Student out matrix: \n");
    for(i=0;i<16;i++){
        printf("%d ", out_A3[i]);
        if(i%n_cols_in3 == n_cols_in3-1){
                printf("\n");
        }
    } 
    printf("Gold out matrix: \n");
    for(i=0;i<16;i++){
        printf("%d ", out_goldA3[i]);
        if(i%n_cols_in3 == n_cols_in3-1){
                printf("\n");
        }
    }

    printf("\n");
    if(addpass==3){
       printf("add_matrix: 15/15\n");        
    }else{
       printf("add_matrix partial credit:\n");
    }
    if(transposepass==3){
       printf("transpose_matrix: 15/15\n");        
    }else{
       printf("transpose_matrix partial credit:\n");
    }
    if(transposepass==3 && addpass==3){
       printf("TOTAL_SCORE: 30/30\n");
    }else{
       printf("TOTAL_SCORE: \n");
    }
    return 0;
}


