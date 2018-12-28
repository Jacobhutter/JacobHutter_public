#include <stdio.h>
#include <stdlib.h>

extern int find_max_asm(int arr[], int len);

/*
 * find_max_c
 *   DESCRIPTION: finds the max value in the array
 *   INPUTS: arr -- array
 *           len -- length of the array
 *   OUTPUTS: none
 *   RETURN VALUE: max value
 *   SIDE EFFECTS: none
 */
int find_max_c(int arr[], int len)
{
  if (arr == NULL || len <= 0)
  {
    return 0;
  }

  int max = arr[0];
  for (int i = 1; i < len; i++)
  {
    //Comparing max
    if (arr[i] > max)
    {
      max = arr[i];
    }
  }

  return max;
}

int main()
{
  const int len = 15;
  int arr[len];
  int max_asm = 0, max_c = 0;

  //Generating random list of ints betwen -50 and 50
  for (int i = 0; i < len; i++)
  {
    arr[i] = (rand() % 101) - 50;

    static char separator = '\0';
    printf("%c%i", separator, arr[i]);
    separator = ',';
  }
  printf("\n");

  //Calling asm function
  max_asm = find_max_asm(arr, len);
  printf("ASM max: %d\n", max_asm);

  //Calling C function
  max_c = find_max_c(arr, len);
  printf("C max: %d\n", max_c);

  return 0;
}
