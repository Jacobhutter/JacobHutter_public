#include <stdio.h>
#include "verify.h"

int main(int argc, char *argv[])
{
  // Check input
  if (argc != 2)
  {
    return 0;
  }
  
  // Open file
  FILE *file = fopen(argv[1], "r");
  if (file == NULL)
  {
    return 0;
  }

  // Call verify data function
  int result = verify(file);

  printf("%d\n", result);

  return 0;
}
