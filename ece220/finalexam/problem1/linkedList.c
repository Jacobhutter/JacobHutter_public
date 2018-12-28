#include "linkedList.h"


int DetectLoop(node *head)
{
int i = 1;

while(head != NULL && i <= 100){
	head = head->next; 
	++i;
 }
		int trigger = 0;
		if(i == 100)
			trigger = 1;
    return trigger;
}

node *CopyList(node *head)
{
	 printf("flag1\n");
	 node * NODE;
	 node * start = NODE;
	 node * starthead = head;
   while(head != NULL){
   node * NEXT;
	 NODE->next = NEXT;
		printf("loop\n");
	 NODE->value = head->value;  // makes copies of next and values
	 NODE = NEXT;
	 head = head->next; 
  }
	printf("flag1\n");
	// set up arbitrary pointers
	head = starthead;
	NODE = start;
	int val1 = 0;
	int val2 = 0;
	while(head != NULL){
	if(head->arbit == NULL){
		NODE->arbit = NULL;
		NODE = NODE->next;
		head = head->next;
}
	else{
	val1 = head->arbit->value; 
	node * loop = NODE;
	val2 = loop->value;
	while(val2 != val1){
	loop = loop->next;
	val2 = loop->value;
  }	
	NODE->arbit = loop;
	NODE = NODE->next;
	head = head->next;
 }
}	 
	printf("flag1\n");
   return start;
}
