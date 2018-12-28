#include <stdlib.h>
#include <stdio.h>

#include "dlist.h"

/*
 * init_dlist
 *   DESCRIPTION: initializes the doubly linked list
 *   INPUTS: none
 *   OUTPUTS: dlist -- memory for pointer to doubly linked list
 *   RETURN VALUE: handle error
 *   SIDE EFFECTS: none
 */
Handle init_dlist(DList **dlist)
{
  // Malloc doubly linked list
  *dlist = (DList *)malloc(sizeof(DList));
  if (*dlist == NULL)
  {
    return E_FAILURE;
  }

  // Malloc sentinel
  Node *sentinel = (Node*)malloc(sizeof(Node));
  if (sentinel == NULL)
  {
    return E_FAILURE;
  }

  // Set up sentinel node
  sentinel->val = -1;
  sentinel->prev = sentinel;
  sentinel->next = sentinel;
  (*dlist)->sentinel = sentinel;

  // Set length
  (*dlist)->length = 0;

  return E_SUCCESS;
}

/*
 * insert_dlist
 *   DESCRIPTION: inserts data into the correct position into the doubly
 *                linked list
 *   INPUTS: dlist -- doubly linked list to be operated on
 *           data -- data to be inserted
 *           index -- location where to insert the data
 *   OUTPUTS: none
 *   RETURN VALUE: handle error
 *   SIDE EFFECTS: none
 */
Handle insert_dlist(DList *dlist, int data, int index)
{ 
	int i=0;
	if(index < 0)
		return E_FAILURE;
	
 Node * node = dlist->sentinel; // get head address assuming sentinel exists
 
	for(i=0;i<=index;i++){
		if(node->next == dlist->sentinel){
			Node * new_node = (Node *)malloc(sizeof(Node)); // make a new node
			node->next = new_node;
			dlist->sentinel->prev = new_node;
			new_node->next = dlist->sentinel;
			new_node->prev = node;
		                            }
		    node = node->next;
		}
	 node->val = data;
	 dlist->length += 1;
  return E_SUCCESS;
}

/*
 * reverse_dlist
 *   DESCRIPTION: reverses the nodes in the list bounded by the start and
 *                end indices
 *   INPUTS: dlist -- doubly linked list to be operated on
 *           start_index -- lower index of reversal
 *           end_index -- upper index of reversal
 *   OUTPUTS: none
 *   RETURN VALUE: handle error
 *   SIDE EFFECTS: changes order of nodes in list
 */
Handle reverse_dlist(DList *dlist, int start_index, int end_index)
{ 
	int temp = 0;
	Node * node_start = dlist->sentinel->next;
	Node * node_end = dlist->sentinel->next;
	int i;
	for(i=0;i<start_index;i++){
	 if(node_start->next == dlist->sentinel)
	 	break;
	 node_start = node_start->next;
}
	for(i=0;i<end_index;i++){
	if(node_end->next == dlist->sentinel)
	 	break;
	 node_end = node_end->next;
}
	while((node_end != node_start)){
	temp = node_start->val;
	node_start->val = node_end->val; // swap until we cannot swap anymore
	node_end->val = temp;
	node_start = node_start->next;
	if(node_start == node_end)
		break;
	node_end = node_end->prev;
}
  return E_SUCCESS;
}

/*
 * print_dlist
 *   DESCRIPTION: prints out all the nodes in the list
 *   INPUTS: dlist -- doubly linked list to be printed
 *   OUTPUTS: none
 *   RETURN VALUE: handle error
 *   SIDE EFFECTS: none
 */
Handle print_dlist(DList *dlist)
{
  // Check params
  if (dlist == NULL)
  {
    return E_FAILURE;
  }

  // Loop variables
  Node *ptr = dlist->sentinel->next;

  // Iterate and print values
  while (ptr != dlist->sentinel)
  {
    printf("%d ", ptr->val);
    ptr = ptr->next;
  }
  printf("\n");

  return E_SUCCESS;
}

/*
 * free_dlist
 *   DESCRIPTION: frees all memory assocatiated with the doubly linked list
 *   INPUTS: dlist -- doubly linked list to be freed
 *   OUTPUTS: none
 *   RETURN VALUE: none
 *   SIDE EFFECTS: frees list
 */
Handle free_dlist(DList *dlist)
{
  // Check params
  if (dlist == NULL)
  {
    return E_SUCCESS;
  }

  // Free nodes
  Node  *prev;
  Node *cur = dlist->sentinel->next;
  while (cur != dlist->sentinel)
  {
    prev = cur;
    cur = cur->next;

    // Free node
    free(prev);
  }

  // Free sentinel and list
  free(dlist->sentinel);
  free(dlist);  

  return E_SUCCESS;
}
