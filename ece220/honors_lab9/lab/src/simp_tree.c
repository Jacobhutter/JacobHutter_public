#include <stdio.h>
#include <stdlib.h>
#include "queue.h"
#include "stack.h"
#include "simp_tree.h"

/* PUBLIC FUNCTIONS */

/*
 * insert_st
 *   DESCRIPTION: inserts new values into the nd
 *   INPUTS: nd -- tree to be operated on
 *           val -- value to be inserted
 *   OUTPUTS: none
 *   RETURN VALUE: handle error
 *   SIDE EFFECTS: none
 */
Handle insert_st(Node **nd, int val)
{
  Node **cur = nd;
  while (*cur != NULL)
  {
    // If less then, go left
    if (val < (*cur)->val)
    {
      cur = &((*cur)->left);
    }
    // If greater than, go right
    else if (val > (*cur)->val)
    {
      cur = &((*cur)->right);
    }
    // If same value, return
    else
    {
      return E_SUCCESS;
    }
  }

  *cur = (Node*)malloc(sizeof(Node));
  (*cur)->val = val; 
  (*cur)->left = NULL;
  (*cur)->right = NULL;

  return E_SUCCESS;
}

/*
 * get_size_st
 *   DESCRIPTION: returns the size of the nd
 *   INPUTS: nd -- tree whose size will be computed
 *   OUTPUTS: sz -- size return value; note that this should be initialized 
 *                  to 0
 *   RETURN VALUE: handle error
 *   SIDE EFFECTS: none
 */
Handle get_size_st(Node *nd, size_t *sz)
{
	if(nd->left!=NULL){
		get_size_st(nd->left,sz);
}
	if(nd->right!=NULL){
		get_size_st(nd->right,sz);
}
	*sz+=1;
  return E_SUCCESS;
}

/*
 * print_pre_st
 *   DESCRIPTION: prints the tree in pre-order
 *   INPUTS: nd -- pointer to node to start from
 *          stream - file stream to print output
 *   OUTPUTS: none
 *   RETURN VALUE: handle error
 *   SIDE EFFECTS: none
 */
Handle print_pre_st(Node *nd, FILE *stream)
{
	fprintf(stream,"%i ",nd->val);
	if(nd->left!=NULL){
		print_pre_st(nd->left,stream);
}
	if(nd->right!=NULL){
		print_pre_st(nd->right,stream);
}
  return E_SUCCESS;
}

/*
 * print_in_st
 *   DESCRIPTION: prints the tree in in-order
 *   INPUTS: nd -- pointer to node to start from
 *          stream - file stream to print output
 *   OUTPUTS: none
 *   RETURN VALUE: handle error
 *   SIDE EFFECTS: none
 */
Handle print_in_st(Node *nd, FILE *stream)
{
	if(nd->left!=NULL){
		print_in_st(nd->left,stream);
}
	fprintf(stream,"%i ",nd->val);
	if(nd->right!=NULL){
		print_in_st(nd->right,stream);
}
  return E_SUCCESS;
}

/*
 * print_post_st
 *   DESCRIPTION: prints the tree in post-order
 *   INPUTS: nd -- pointer to node to start from
 *          stream - file stream to print output
 *   OUTPUTS: none
 *   RETURN VALUE: handle error
 *   SIDE EFFECTS: none
 */
Handle print_post_st(Node *nd, FILE *stream)
{
	if(nd->left!=NULL){
		print_post_st(nd->left,stream);
}
	if(nd->right!=NULL){
		print_post_st(nd->right,stream);
}
	fprintf(stream,"%i ",nd->val);
  return E_SUCCESS;
}

/*
 * print_bfs_st
 *   DESCRIPTION: prints the tree with a BFS traversal
 *   INPUTS: nd -- pointer to node to start from
 *          stream -- file stream to print output
 *   OUTPUTS: none
 *   RETURN VALUE: handle error
 *   SIDE EFFECTS: none
 */
Handle print_bfs_st(Node *nd, FILE *stream)
{	//if(nd == NULL)

	size_t * size = (size_t *)malloc(sizeof(size_t));
	*size = 0;
	get_size_st(nd,size); // get size		

	size_t size1 = *size;
	Queue *queue = NULL;

	init_queue(&queue,size1); // initialize queue

	enqueue(queue,nd,malloc_Node); // add to stack 

	Node * node = (Node *)malloc(sizeof(Node));	
	while((queue)->len != 0){

  dequeue(queue,node,copy_Node,free_Node);
	if(node->left != NULL)
		enqueue(queue,node->left,malloc_Node);
	if(node->right != NULL)
		enqueue(queue,node->right,malloc_Node);

	fprintf(stream,"%i ",node->val);
}
  free(node);
  free(size);
  return E_SUCCESS;
}

/*
 * print_dfs_st
 *    DESCRIPTION: prints the tree with a DFS traversal
 *    INPUTS: nd -- pointer to node to start from
 *          stream -- file stream to print output
 *    OUTPUTS: none
 *    RETURNVALUE: handle error
 *    SIDE EFFECTS: none
 */
Handle print_dfs_st(Node *nd, FILE *stream)
{	
	size_t * size = (size_t *)malloc(sizeof(size_t));
	*size = 0;
	get_size_st(nd,size);
	size_t size1 = *size;
	Stack * stack = (Stack *)malloc(sizeof(stack));
	init_stack(&stack,size1);
	push(stack,nd,malloc_Node);
	Node * node = (Node *)malloc(sizeof(Node));
	while(stack->len != 0){
	pop(stack,node,copy_Node,free_Node);
	if(node->right != NULL)
	push(stack,node->right,malloc_Node);
	if(node->left != NULL)
	push(stack,node->left,malloc_Node);
	fprintf(stream,"%i ",node->val);
}

 	free(node);
 free(size);
	
  return E_SUCCESS;
}

/*
 * print_level_st
 *   DESCRIPTION: prints the kth level of a tree
 *   INPUTS: nd -- pointer to node to start from
 *           k -- kth level to print
 *           stream -- file stream to print output
 *   OUTPUTS: none
 *   RETURN VALUE: handle error
 *   SIDE EFFECTS: none
 */
Handle print_level_st(Node *nd, int k, FILE *stream)
{ if(nd == NULL)
  return E_SUCCESS;
  if(k<0)
  	return E_FAILURE;
	if(k == 0){
	fprintf(stream,"%i ",nd->val);
	return E_SUCCESS;
}
	else{
	print_level_st(nd->left,k-1,stream);
	print_level_st(nd->right,k-1,stream);
}
 return E_SUCCESS;
}

/*
 * print_zigzag_st
 *   DESCRIPTION: prints the levels of the tree in a zigzag fashion. The first
 *                level is printed going rightwards.
 *   INPUTS: nd -- pointer to node to start from
 *           stream -- file stream to print output
 *   OUTPUTS: none
 *   RETURN VALUE: handle error
 *   SIDE EFFECTS: none
 */
Handle print_zigzag_st(Node *nd, FILE *stream)
{ 	if(nd == NULL)
		return E_FAILURE;
	size_t * size = (size_t *)malloc(sizeof(size_t));
	get_size_st(nd,size);
	size_t size1 = *size;
	Stack * stack1 = NULL;
	Stack * stack2 = NULL;
	init_stack(&stack1,size1);
	init_stack(&stack2,size1);
	push(stack1,nd,malloc_Node);
	Node * temp = (Node *)malloc(sizeof(Node));
	while((stack1)->len != 0 || (stack2)->len!=0){
		while(stack1->len != 0){
		 pop(stack1,temp,copy_Node,free_Node);
		 fprintf(stream,"%i ",temp->val);
		 if(temp->left != NULL)
			 push(stack2,temp->left,malloc_Node);
		 if(temp->right != NULL)
			push(stack2,temp->right,malloc_Node);
 }
	while(stack2->len!=0){
		pop(stack2,temp,copy_Node,free_Node);
		fprintf(stream,"%i ",temp->val);
		if(temp->right != NULL)
		  push(stack1,temp->right,malloc_Node);
		if(temp->left != NULL)
			push(stack1,temp->left,malloc_Node);
		
 }
}
	free(size);
	free(temp);
	
	return E_SUCCESS;
}

/* 
 * free_st
 *   DESCRIPTION: frees the tree underneath passed in node
 *   INPUTS: nd -- pointer to node to free tree
 *   OUTPUTS: none
 *   RETURN VALUE: handle error
 *   SIDE EFFECTS: none
 */
Handle free_st(Node *nd)
{
  // Check if valid
  if (nd == NULL)
  {
    return E_SUCCESS;
  }

  // Free left child
  if (nd->left != NULL)
  {
    free_st(nd->left);
  }

  // Free right child
  if (nd->right != NULL)
  {
    free_st(nd->right);
  }

  // Free nd
  free_Node(nd);

  return E_SUCCESS;
}