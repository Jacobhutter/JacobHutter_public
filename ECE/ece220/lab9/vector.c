#include "vector.h"
#include <stdlib.h>


vector_t * createVector(int initialSize)
{	 
    vector_t * vector = (vector_t *)malloc(sizeof(vector_t));
    vector->array = (int *)malloc(initialSize*sizeof(int));
	vector->size = 0;
	vector->maxSize = initialSize;
	return vector;
}

void destroyVector(vector_t * vector)
{
	free(vector->array);
	free(vector);
}

void resize(vector_t * vector)
{
	vector->array = (int *)realloc(vector->array, vector->maxSize * sizeof(int)*2);
	vector->maxSize *= 2 ;
}

void push_back(vector_t * vector, int element)
{
	if(vector->size >= vector->maxSize){
		resize(vector);
	}
		vector->array[vector->size] = element;
		vector->size++;
}

int pop_back(vector_t * vector)
{
	if(vector->size == 0)
		return 0;
	else{
	vector->size--;
	return vector->array[vector->size];
 }
}

int access(vector_t * vector, int index)
{
if(index < 0 || index >= vector->size)
	return 0;
return vector->array[index]; 
}

