#include "node.h"

void *malloc_Node(const void *src)
{
  void *ptr = (Node*)malloc(sizeof(Node));
  *((Node*)ptr) = *((Node*)src);

  return ptr;
}

void copy_Node(void *dst, const void *src)
{
  *((Node*)dst) = *((Node*)src);
}

void print_Node(const void *src, FILE *stream)
{
  fprintf(stream, "%d ", ((Node*)src)->val);
}

void free_Node(void *src)
{
  free(src);
}


