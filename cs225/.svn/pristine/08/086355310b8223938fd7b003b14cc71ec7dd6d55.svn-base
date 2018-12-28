#include "dsets.h"
using namespace std;

void DisjointSets::addelements(int num){
    if(num <= 0)
      return;
    for(int i = 0; i < num; i++){
      node a(-1,set.size());
      set.push_back(a); // push new node onto vector
    }

}

int DisjointSets::find(int elem){
  if(elem <0)
    return -1;
  if(set[elem].parent < 0) return elem;
  else
    return find(set[elem].parent);
}

void DisjointSets::setunion(int a, int b){
  if(set[a].parent > 0) // find representatives of each set
    a = find(a);
  if(set[b].parent > 0) // find representatives of each set
    b = find(b);
  if(set[b].index == set[a].index){ // check to see if the sets that are trying to be unionized are not the same
    //cout << "no union done, same set" << endl;
    return;
  }
  int newSize = set[a].parent + set[b].parent; // get new tree size
  if(isBigger(a,b)){
    set[b].parent = a;
    set[a].parent = newSize;
  }
  else{
    set[a].parent = b;
    set[b].parent = newSize;
  }
/*  for(size_t i = 0; i<set.size(); i++){
    cout << set[i].parent << " ";
  }
    cout << endl;*/
}

bool DisjointSets::isBigger(int a, int b){
  int val1 = set[a].parent;
  int val2 = set[b].parent;
  if(val1 < 0 && val2 < 0 && ( val1 != val2) )
    return val1 < val2;
  if(val1 == val2){
    return set[a].index > set[b].index;
  }
  else return val1 > val2;
}
