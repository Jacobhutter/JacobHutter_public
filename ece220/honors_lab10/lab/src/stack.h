#ifndef STACk_H
#define STACK_H

#include "list.h"

class Stack : private List<int>
{
  public:
    Stack();
    ~Stack();

    // Stack public functions
    bool is_empty();
    std::size_t get_size() const;
    int peek() const;
    int pop();
    void push(int data);

    friend std::ostream &operator <<(std::ostream &stream,
        const Stack &stack);
		
};

#endif /* STACK_H */
