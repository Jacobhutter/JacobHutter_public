#ifndef QUEUE_H
#define QUEUE_H

#include "error.h"

// Queue data structure
typedef struct
{
  size_t len, max_len;
  size_t head, tail;
  void **data;
} Queue;

/* PUBLIC FUNCTIONS */
Handle init_queue(Queue **queue, size_t length);

Handle enqueue(Queue *queue, const void *src, 
    void *(*malloc_data)(const void *src));

Handle dequeue(Queue *queue, void *dst, 
    void (*copy_data)(void *dst, const void *src),
    void (*free_data)(void *src));

Handle front(Queue *queue, void *dst, 
    void (*copy_data)(void *dst, const void *src));

Handle back(Queue *queue, void * dst, 
    void (*copy_data)(void *dst, const void *src));

Handle print_queue(Queue *queue, FILE *stream,
    void (*print_data)(const void *src, FILE *stream));

Handle free_queue(Queue *queue, void (*free_data)(void *src));

/* PRIVATE FUNCTIONS */

#endif /* QUEUE_H */
