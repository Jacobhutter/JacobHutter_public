#include <fstream>
#include <iostream>

#include "stack.h"

int main(int argc, const char *argv[])
{
  // Check args
  if (argc != 2)
  {
    return 0;
  }

  // Open file
  std::ifstream file(argv[1]);
  if (file.fail())
  {
    return 0;
  }

  // Create list
  Stack stck;

  // Read data
  int data;
  while (file >> data)
  {
    stck.push(data);
  }
  file.close();

  // Print out the stack
  std::cout << stck << std::endl;

  size_t sz1 = stck.get_size(), sz2 = 0;

  // Check size
  if (!stck.is_empty())
  {
    stck.pop();
    sz2 = stck.get_size();
  }

  std::cout << sz1 << " " << sz2 << std::endl;
}
