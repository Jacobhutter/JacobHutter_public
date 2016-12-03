#include "common.h"
#include <iostream>
#include <queue>

/*
  As a reminder, useful STL queue methods include:
  empty : Test whether container is empty (public member function)
  size : Return size (public member function)
  front : Access next element (public member function)
  push : Insert element (public member function)
  pop : Remove next element (public member function)
*/

using namespace std;

int insertAt(queue<int> &q, int data, int pos)
{	int size = q.size();
	if(pos < 0 || pos > size) // check for negative indices or greater than biggest indicie plus one 
		return -1;
	 int x = 0;
	
	if(pos == size){
	 q.push(data);
	return 1;
 }
	while(x < size){
	  if(x == pos)
	   q.push(data);
	q.push(q.front());
	q.pop();
	x++;
 }
	// YOUR CODE HERE!
	return 1;
}
