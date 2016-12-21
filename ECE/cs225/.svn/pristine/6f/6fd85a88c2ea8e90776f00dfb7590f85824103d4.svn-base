#include "common.h"
#include <iostream>
#include <algorithm>

/*
	The algorithm library is included if needed, for the function:
	max: returns the largest of the values passed as arguments.
*/

using namespace std;

void updateMax(Node<int> *&root)
{	
	
	if(root == NULL) // null checker
	 return;
	int L = 0;
	int R = 0;
	if(root->left){	 
	 updateMax(root->left);
	 L = root->left->data; // check after to check for changed conditions
	 
	}
	if(root->right){ 
	 updateMax(root->right);
	 R = root->right->data; // check after to check for changed conditions
	}
	if(L == 0 && R == 0) // leaf node
	 return;
	root->data += std::max(L,R);
	return;
}
