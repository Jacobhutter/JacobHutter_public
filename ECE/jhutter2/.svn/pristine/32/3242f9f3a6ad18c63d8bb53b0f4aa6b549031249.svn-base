#include <stdio.h>
#include <stdlib.h>
#include "count_steps.h"

int main(int argc, const char *argv[])
{
  // Check input
  if (argc != 2)
  {
    return 0;
  }

  // Get number of levels
  int num_steps = atoi(argv[1]);

  // Count number of ways
  int total_ways = count_steps(num_steps);
  printf("%d\n", total_ways);

  return 0;
}
