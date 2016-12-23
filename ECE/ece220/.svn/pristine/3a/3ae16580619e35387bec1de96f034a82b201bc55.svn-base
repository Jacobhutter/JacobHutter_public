#ifndef STACK_H
#define STACK_H

#include "error.h"

// Stack data structure
typedef struct
{
  size_t len, max_len;
  size_t head;
  void **data;
} Stack;

/* PUBLIC FUNCTIONS */
Handle init_stack(Stack **stack, size_t length);

Handle push(Stack *stack, const void *src, 
    void *(*malloc_data)(const void *src));

Handle pop(Stack *stack, void *dst, 
    void (*copy_data)(void *dst, const void *src),
    void (*free_data)(void *src));

Handle peek(Stack *stack, void *dst,
    void (*copy_data)(void *dst, const void *src));

Handle print_stack(Stack *stack, FILE *stream,
    void (*print_data)(const void *src, FILE *stream));

Handle free_stack(Stack *stack, void (*free_data)(void *src));

/* PRIVATE FUNCTIONS */

#endif /* STACK_H */
