#include <stdio.h>
#include <stdlib.h>
#include "stack.h"

/* PUBLIC FUNCTIONS */

/*
 * init_stack
 *   DESCRIPTION: initializes the stack to be of size sz.
 *   INPUTS: length -- size of stack
 *   OUTPUTS: stack -- memory location of the stack pointer 
 *   RETURN VALUE: handle error
 *   SIDE EFFECTS: none
 */
Handle init_stack(Stack **stack, size_t length)
{
  *stack = (Stack*)malloc(sizeof(Stack));
  if (*stack == NULL)
  {
    return E_FAILURE;
  }

  (*stack)->data = (void**)malloc(length * sizeof(void*));
  if ((*stack)->data == NULL)
  {
    free(*stack);
    return E_FAILURE;
  }

  (*stack)->max_len = length;
  (*stack)->len = (*stack)->head = 0;

  return E_SUCCESS;
}

/*
 * push
 *   DESCRIPTION: pushes data to the top of the stack
 *   INPUTS: stack -- stack to be operated on
 *           src -- data to be pushed
 *           malloc_data -- data constructor
 *   OUTPUTS: none
 *   RETURN VALUE: handle error
 *   SIDE EFFECTS: none
 */
Handle push(Stack *stack, const void *src, 
    void *(*malloc_data)(const void *src))
{
  if (stack == NULL || stack->len == stack->max_len)
  {
    return E_FAILURE;
  }

  stack->data[stack->head] = malloc_data(src);
  stack->len++;
  stack->head++;

  return E_SUCCESS;
}

/*
 * pop
 *   DESCRIPTION: pops data from the top of the stack
 *   INPUTS: stack -- stack to be operated on
 *           copy_data -- copy constructor
 *   OUTPUTS: dst -- pointer to where data will be stored
 *   RETURN VALUE: handle error
 *   SIDE EFFECTS: none
 */
Handle pop(Stack *stack, void *dst, 
    void (*copy_data)(void *dst, const void *src),
    void (*free_data)(void *src))
{
  if (stack == NULL || stack->len == 0)
  {
    return E_FAILURE;
  }

  copy_data(dst, stack->data[--(stack->head)]);
  free_data(stack->data[stack->head]);
  stack->len--;

  return E_SUCCESS;
}

/*
 * peek
 *   DESCRIPTION: returns data at the top of the stack
 *   INPUTS: stack -- stack to be operated on
 *           copy_data -- copy constructor
 *   OUTPUTS: dst -- pointer to where data will be stored
 *   RETURN VALUE: handle error
 *   SIDE EFFECTS: none
 */
Handle peek(Stack *stack, void *dst,
    void (*copy_data)(void *dst, const void *src))
{
  if (stack == NULL || stack->len == 0)
  {
    return E_FAILURE;
  }

  copy_data(dst, stack->data[stack->head - 1]);
  
  return E_SUCCESS;
}

/*
 * print_stack
 *   DESCRIPTION: prints the data in the stack
 *   INPUTS: stack -- stack to be operated on
 *           stream -- file stream where stack will be printed
 *           print_data -- print helper function
 *   OUTPUTS: none
 *   RETURN VALUE: handle error
 *   SIDE EFFECTS: if stack is empty, prints "Stack empty."
 */
Handle print_stack(Stack *stack, FILE *stream,
    void (*print_data)(const void *src, FILE *stream))
{
  if (stack == NULL)
  {
    return E_FAILURE;
  }

  for (size_t i = stack->head, j = 0; j < stack->len; j++)
  {
    print_data(stack->data[--i], stream);
  }
  fprintf(stream, "\n");

  return E_SUCCESS;
}

/*
 * free_stack
 *   DESCRIPTION: frees memory occupied by the stack
 *   INPUTS: stack -- stack to be operated on
 *           free_data -- destructor
 *   OUTPUTS: none
 *   RETURN VALUE: handle error
 *   SIDE EFFECTS: none
 */
Handle free_stack(Stack *stack, void (*free_data)(void *src))
{
  if (stack == NULL)
  {
    return E_SUCCESS;
  }

  for (size_t i = stack->head, j = 0; j < stack->len; j++)
  {
    free_data(stack->data[--i]);
  }
  free(stack->data);
  free(stack);

  return E_SUCCESS;
}

/* PRIVATE FUNCTIONS */

