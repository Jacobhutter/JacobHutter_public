#include <stdio.h>
#include "vector.h"
#include "tree.h"
#include <stdlib.h>

// FUNCTION DEFINITIONS
void findPathRecursive(node * root, int expectedSum, int currentSum, vector * path);
void findPath(node * root, int expectedSum);


// Don't change the main function
int main(int argc, char * argv[])
{
    if (argc < 1)
    {
        printf("Not enough arguments\n");
        return -1;
    }

    node * root = create_tree(argv[1]);
    int sum;
    printf("Please enter a sum: ");
    scanf("%d", &sum);

    findPath(root, sum);
    delete_tree(root);
}

// Recursive helper function for printing paths within a tree
// that add up to an expected sum
void findPathRecursive(node * root, int expectedSum, int currentSum, vector * path)
{   currentSum += root->value;
		pushBack(path,root->value);
		if(currentSum > expectedSum){
		currentSum -= root->value;
		popBack(path);
		return;
}
		if(currentSum == expectedSum){
			while(isEmpty(path)!=1){
			printf("%i ",path->back);
}
			popBack(path);
			printf("\n");
			currentSum -= root->value;
			return;
}
    if(root->left != NULL)
			findPathRecursive(root->left,expectedSum,currentSum,path);
		if(root->right != NULL)
			findPathRecursive(root->left,expectedSum,currentSum,path);
			
	currentSum -= root->value;
	popBack(path);
	return;
}

// Finds and prints all paths within a tree that add to an expected sum
void findPath(node * root, int expectedSum)
{		vector * path = (vector *)malloc(sizeof(vector));
		vectorInit(path);
   	findPathRecursive(root,expectedSum,0,path);
		free(path);
		if(root->left != NULL)
			findPath(root->left,expectedSum);
		if(root->right != NULL)
			findPath(root->right,expectedSum);
	return;
}
