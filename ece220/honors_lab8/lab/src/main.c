#include <stdio.h>

#include "dlist.h"

int main(int argc, const char *argv[])
{
	
  // Check args
  if (argc != 2)
  {
    return 0;
  }

  // Open test file
  FILE *file = fopen(argv[1], "r");
  if (file == NULL)
  {
    return 0;
  }

  // Initialize doubly linked list
  DList *dlist;
  init_dlist(&dlist);

  // Get input length
  int len, start, end;
  fscanf(file, "%d %d %d\n", &len, &start, &end);

  // Read the input
  int in;
  int idx = 0;
  for (; len > 0; len--)
  {
    fscanf(file, "%d", &in);
    insert_dlist(dlist, in, idx++);
  }

  // NOTE uncomment for debugging
  //print_dlist(dlist);

  // Reverse list
  reverse_dlist(dlist, start, end);

  // Print list
  print_dlist(dlist);

  // Free memor
  fclose(file);
  free_dlist(dlist);

  return 0;
}