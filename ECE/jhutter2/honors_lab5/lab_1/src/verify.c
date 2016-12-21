#include <stdio.h>
#include <regex.h>
#include <string.h>
#include "verify.h"

#define DATA_LINES 3
#define BUFFER_LEN 100

/* 
 * verify
 *   DESCRIPTION: verifies the format of all the lines the provided file
 *   INPUT: file -- file containing the data
 *   OUTPUT: none
 *   RETURN VALUE: 0 (success) if the data is valid and 1 (failure) if it is not
 *   SIDE EFFECTS: none
 */
int verify(FILE *file)
{
  // Variables
  int reg_flags = REG_EXTENDED;
  char buffer[BUFFER_LEN];

  return -1;
}
