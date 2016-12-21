#include "common.h"
#include <iostream>
#include <algorithm>
#include <queue>
/*
	The algorithm library is included if needed, for the function:
	max: returns the largest of the values passed as arguments.
*/

using namespace std;

void recLCA(Node<int> *&root, queue<int> & q, int val){
	if(!root)
	 return;
	//std::cout << val << " ";
	q.push(root->data); // push new value onto stack
	//std::cout << q.front() << std::endl;
	if(val > root->data)
	  recLCA(root->right,q,val);
	else if(val < root->data)
	  recLCA(root->left,q,val);
	else
	  return; // base case 
	
}

Node<int>* find(Node<int> *&root, int val){
	if(!root)
	  return NULL;
	if(val == root->data)
	  return root;
	if(val > root->data)
	  return find(root->right,val);
	else
	 return find(root->left,val);
	
}

Node<int>* findLCA(Node<int> *&root, int val1, int val2)
{
	if(!root)
	  return NULL;
	if(find(root,val1) == NULL || find(root,val2) == NULL)
	  return NULL;
	if(val1 == val2)
	  return root;
	queue<int> q1; // get path for val1
	
	recLCA(root,q1,val1);
	//std::cout << q1.front() << std::endl;
	queue<int> q2;
	recLCA(root,q2,val2); // get path for val2
	int global_LCA = -169827363;
	
	while(!q1.empty()){
	 queue<int> q3 = q2;
	 while(!q3.empty()){
	  int path_one = q1.front();
	  int path_two = q3.front();
	  if(path_one == path_two)
		global_LCA = path_one;
	  q3.pop();
  }
	  q1.pop();
 }
	  return find(root,global_LCA);
}
