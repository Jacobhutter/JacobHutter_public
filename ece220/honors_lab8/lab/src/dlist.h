#ifndef DLIST_H
#define DLIST_H

#include "error.h"

typedef struct Node
{
  int val;
  struct Node *prev, *next;
} Node;

typedef struct DList
{
  int length;
  struct Node *sentinel;
} DList;

Handle init_dlist(DList **dlist);
Handle insert_dlist(DList *dlist, int data, int index);
Handle reverse_dlist(DList *dlist, int start_index, int end_index);
Handle print_dlist(DList *dlist);
Handle free_dlist(DList *dlist);

#endif /* DLIST_H */
