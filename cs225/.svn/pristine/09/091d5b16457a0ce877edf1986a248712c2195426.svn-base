#include "common.h"
#include "quadtree.h"

#include <iostream>
#include <algorithm>

/*
	The algorithm library is included if needed, for the function:
	max: returns the largest of the values passed as arguments.
*/

using namespace std;

void Quadtree::tallyDeviants(RGBAPixel const & target, 
    QuadtreeNode const * curNode, int tolerance, int & running) const {
		if(curNode == NULL)
		  return;
		if(curNode->nwChild == NULL){ // leaf node
		//  int maxDev(RGBAPixel const& target, QuadtreeNode const* curNode) const;
		   int distance = maxDev(target,curNode); // calculate distance between target and node element 
		   if(distance > tolerance){ // if distance is greater than tolerance than increment running total
			running++;
 }
		   return;
 }
		else{
	tallyDeviants(target,curNode->nwChild,tolerance,running); // if not leaf node then continue through the tree
	tallyDeviants(target,curNode->neChild,tolerance,running);
	tallyDeviants(target,curNode->swChild,tolerance,running);
	tallyDeviants(target,curNode->seChild,tolerance,running);
  }
}

int Quadtree::tallyDeviants(RGBAPixel const & target, 
    QuadtreeNode const * curNode, int tolerance) const {
    
    int running = 0;
    tallyDeviants(target,curNode,tolerance,running);
    return running;
}

void Quadtree::prunish(int tolerance, double percent, QuadtreeNode * curNode) { // calculates res 
	if(!curNode)
	  return; 
	int res = tallyDeviants(curNode->element, curNode, -1); // calc total number of leaves using low tolerance
	prunish(curNode,tolerance,res,percent); // prune current node

	prunish(tolerance,percent,curNode->nwChild);
	prunish(tolerance,percent,curNode->neChild);
	prunish(tolerance,percent,curNode->swChild);
	prunish(tolerance,percent,curNode->seChild);
	
 }

void Quadtree::prunish(int tolerance, double percent) {
    if(!root)
	return;
    prunish(tolerance, percent, root);
    return;
 
} 

void Quadtree::prunish(QuadtreeNode * curNode, int tolerance, int res, double percent) {
    int deviants = tallyDeviants(curNode->element,curNode,tolerance); // calc deviants 
   if(res == 0){ // ie is leaf node
	return;
   }
    double deviancy = deviants/res;
    if(deviancy >= percent){ // prune 
	clear(curNode->nwChild);
	clear(curNode->neChild);
	clear(curNode->swChild);
	clear(curNode->seChild);
 }

	return;
}



























