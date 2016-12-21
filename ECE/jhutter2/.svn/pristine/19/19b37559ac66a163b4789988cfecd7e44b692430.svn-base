#include <stdio.h> 
#include <stdlib.h>
#include "queue.h"

/* PUBLIC FUNCTIONS */

/*
 * init_queue
 *   DESCRIPTION: initializes the queue to be of size sz.
 *   INPUTS: length -- size of queue
 *   OUTPUTS: queue -- memory location of the queue pointer 
 *   RETURN VALUE: handle error
 *   SIDE EFFECTS: none
 */
Handle init_queue(Queue **queue, size_t length)
{
  *queue = (Queue*)malloc(sizeof(Queue));
  if (*queue == NULL)
  {
    return E_FAILURE;
  }

  (*queue)->data = (void**)malloc(length * sizeof(void*));
  if ((*queue)->data == NULL)
  {
    free(*queue);
    return E_FAILURE;
  }
  
  (*queue)->max_len = length;
  (*queue)->len = (*queue)->head = (*queue)->tail = 0;
  
  return E_SUCCESS;
}

/*
 * enqueue
 *   DESCRIPTION: enqueues data to the end of the queue
 *   INPUTS: queue -- queue to be operated on
 *           src -- data to be enqueued
 *           malloc_data -- data constructor
 *   OUTPUTS: none
 *   RETURN VALUE: handle error
 *   SIDE EFFECTS: none
 */
Handle enqueue(Queue *queue, const void *src, 
    void *(*malloc_data)(const void *src))
{
  if (queue->len == queue->max_len)
  {
    return E_FAILURE;
  }
  
  queue->data[queue->tail] = malloc_data(src);
  queue->tail = (queue->tail + 1) % queue->max_len;
  queue->len++;

  return E_SUCCESS;
}

/*
 * dequeue
 *   DESCRIPTION: dequeues data from the front of the queue
 *   INPUTS: queue -- queue to be operated on
 *           copy_data -- copy constructor
 *           free_data -- destructor
 *   OUTPUTS: dst -- pointer to where data will be stored
 *   RETURN VALUE: handle error
 *   SIDE EFFECTS: none
 */
Handle dequeue(Queue *queue, void *dst, 
    void (*copy_data)(void *dst, const void *src),
    void (*free_data)(void *src))
{
  if (queue == NULL || queue->len == 0)
  {
    return E_FAILURE;
  }

  copy_data(dst, queue->data[queue->head]);
  free_data(queue->data[queue->head]);
  queue->head = (queue->head + 1) % queue->max_len;
  queue->len--;

  return E_SUCCESS;
}

/*
 * front
 *   DESCRIPTION: returns data at the front of the queue
 *   INPUTS: queue -- queue to be operated on
 *           copy_data -- copy constructor
 *   OUTPUTS: dst -- pointer to where data will be stored
 *   RETURN VALUE: handle error
 *   SIDE EFFECTS: none
 */
Handle front(Queue *queue, void *dst, 
    void (*copy_data)(void *dst, const void *src))
{
  if (queue == NULL || queue->len == 0)
  {
    return E_FAILURE;
  }

  copy_data(dst, queue->data[queue->head]);

  return E_SUCCESS;
}

/*
 * back
 *   DESCRIPTION: returns data at the back of the queue
 *   INPUTS: queue -- queue to be operated on
 *           copy_data -- copy constructor
 *   OUTPUTS: dt -- pointer to where data will be stored
 *   RETURN VALUE: handle error
 *   SIDE EFFECTS: none
 */
Handle back(Queue *queue, void * dst, 
    void (*copy_data)(void *dst, const void *src))
{
  if (queue == NULL || queue->len == 0)
  {
    return E_FAILURE;
  }

  int back = (queue->tail == 0) ? queue->max_len - 1 : queue->tail - 1;
  copy_data(dst, queue->data[back]);

  return E_SUCCESS;
}

/*
 * print_queue
 *   DESCRIPTION: prints the data in the queue
 *   INPUTS: queue -- queue to be operated on
 *           stream -- file stream where queue will be printed
 *           print_data -- print helper function
 *   OUTPUTS: none
 *   RETURN VALUE: handle error
 *   SIDE EFFECTS: none
 */
Handle print_queue(Queue *queue, FILE *stream,
    void (*print_data)(const void *src, FILE *stream))
{
  if (queue == NULL)
  {
    return E_FAILURE;
  }

  for (size_t i = queue->head, j = 0; j < queue->len; j++)
  {
    print_data(queue->data[i], stream);
    i = (i + 1) % queue->max_len;
  }
  fprintf(stream, "\n");

  return E_SUCCESS;
}

/*
 * free_queue
 *   DESCRIPTION: frees memory occupied by the queue
 *   INPUTS: queue -- queue to be operated on
 *           free_data -- destructor
 *   OUTPUTS: none
 *   RETURN VALUE: handle error
 *   SIDE EFFECTS: none
 */
Handle free_queue(Queue *queue, void (*free_data)(void *src))
{
  if (queue == NULL)
  {
    return E_SUCCESS;
  }

  for (size_t i = queue->head, j = 0; j < queue->len; j++)
  {
    free_data(queue->data[i]);
    i = (i + 1) % queue->max_len;
  }
  free(queue->data);
  free(queue);

  return E_SUCCESS;
}

/* PRIVATE FUNCTIONS */

