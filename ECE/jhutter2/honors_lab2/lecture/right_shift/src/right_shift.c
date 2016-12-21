#include <stdio.h>
#include <stdint.h>
#include <assert.h>

//Function to perform right shift
int32_t right_shift(int32_t in, uint8_t amount)
{
  int32_t mask_in = 0x1;
  int32_t mask_out = 0x1;
  int32_t rs = 0;
  uint8_t i;

  //Checking input
  if (amount > 31)
  {
    return 0;
  }

  //Shift the mask
  for (i = 0; i < amount; i++)
  {
    mask_out *= 2;
  }

  //Performing right shift
  for (i = amount; i < 32; i++)
  {
    rs |= (mask_in & in) ? mask_out : 0;
    mask_in *= 2;
    mask_out *= 2;
  }

  return rs ;
}

void test_shift()
{
  printf("%d, %d\n", 7 << 31, right_shift(7, 31));
  assert((7 << 31) == right_shift(7, 31));
}

int main()
{
  test_shift();

  return 0;
}
