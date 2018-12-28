#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int rev_avg_asm(int arr[], int len);
extern int rev_avg_c(int arr[], int len);

/* print_arr
 *   DESCRIPTION: prints the array
 *   INPUTS: arr -- array
 *           len -- length of the array
 *   OUTPUTS: none
 *   RETURN VALUE: none
 *   SIDE EFFECTS: none */
void print_arr(int arr[], int len)
{
  char separator = '\0'; 
  for (int i = 0; i < len; i++)
  {
    printf("%c%i", separator, arr[i]);
    separator = ',';
  }

  printf("\n");
}

int main(int argc, char *argv[])
{
  //Checking for input
  if (argc != 2)
  {
    return 0;
  }

  //Opening test file
  FILE *file = fopen(argv[1], "r");
  if (file == NULL)
  {
    return 0;
  }

  //Getting input length
  int len = 0;
  fscanf(file, "%d", &len);

  //Reading array
  int *arr = (int*)malloc(len * sizeof(int));
  for (int i = 0; i < len; i++)
  {
    fscanf(file, "%d", arr+i);
  }

  printf("Array: ");
  print_arr(arr, len);

  //Copying the arrays
  int *rev_asm = (int*)malloc(len * sizeof(int));
  int *rev_c = (int*)malloc(len * sizeof(int));
  memcpy(rev_c, arr, len * sizeof(int));
  memcpy(rev_asm, arr, len * sizeof(int));

  //Calling asm function
  int avg_asm = rev_avg_asm(rev_asm, len);
  printf("\nASM avg: %d\nASM array: ", avg_asm);
  print_arr(rev_asm, len);

  //Calling C function
  int avg_c = rev_avg_c(rev_c, len);
  printf("\nC avg: %d\nC array: ", avg_c);
  print_arr(rev_c, len);

  //Freeing memory
  free(arr);
  free(rev_asm);
  free(rev_c);

  return 0;
}
