#include <iostream>
#include <vector>
using namespace std;

int depthUpTree(vector<int> uptree, int index)
{
  int i = 0;
  if((size_t)index >= uptree.size())
	return -1;
  while(uptree[index] > 0){
        index = uptree[index];
	if((size_t)index >= uptree.size())
	  return -1;
	if((size_t)i >= uptree.size()) // cycle detection
	  return -1;
	i++;
}
  return i;
}

