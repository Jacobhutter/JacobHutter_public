
#include <vector>
#include <iostream>

size_t insertion_idx(const std::vector<int>& elements, const int val)
{
  if(elements.empty())
    return 0;
    //T element = elements[low];
  size_t low = 0;
  size_t high = elements.size(); // high index
  if()

    while(1){
      if(low == high)
        break;
       int element = elements[(high + low)/2];
       if(element == val)
        return (high+low)/2;
      if(element > val)
        high = high -  (high - low)/2 - 1;
      else
        low = low + (high-low)/2 + 1;
    }
    return low;
    /* TODO Your code goes here! */
    //return 5;
}
int main(){
  std::vector<int> v;
//v.push_back();
v.push_back(5);
v.push_back(99);
//v.push_back(5);
//v.push_back(7);



  std::cout << insertion_idx(v,23) << std::endl;
  return 0;
}
