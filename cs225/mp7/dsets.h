#ifndef DSETS_H
#define DSETS_H
#include <iostream>
#include <vector>

class DisjointSets
{
  public :
    void 	addelements (int num);
    int 	find (int elem);
    void 	setunion (int a, int b);
    void printsets() const{
      for(size_t i = 0; i < set.size(); i++)
        std::cout << set[i].index << " ";
      std::cout << std::endl;
        for(size_t i = 0; i < set.size(); i++)
          std::cout << set[i].parent << " ";
      std::cout << std::endl;
    }
    struct node{
      int parent;
      int index;
      node(int par, int in){
          index = in;
          parent = par;
      }
    };
  private:
    std::vector<node> set;
    bool isBigger(int a, int b);
};
#endif
