#include <stdio.h>
#include <stdlib.h>
#include "permutation.h"

int main(int argc, const char *argv[])
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

  // Read perm data
  int perm_len;
  fscanf(file, "%d", &perm_len);

  char *perm = (char *)malloc((perm_len + 1) * sizeof(char));
  fscanf(file, "%s", perm);

  // Read search data
  int search_len;
  fscanf(file, "%d", &search_len);

  char *search = (char *)malloc((search_len + 1) * sizeof(char));
  fscanf(file, "%s", search);

  // Find permutations
  find_permutations(perm, perm_len, search, search_len);

  return 0;
}
