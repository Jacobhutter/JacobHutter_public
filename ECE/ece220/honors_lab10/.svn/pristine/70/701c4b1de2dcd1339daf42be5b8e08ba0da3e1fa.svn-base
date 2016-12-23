#include "list.h"
#include <iostream>

/*
 * List::List
 *   DESCRIPTION: constructor
 */
template<typename T>
List<T>::List() : head(NULL), tail(NULL), size(0)
{ }

/*
 * List::List
 *   DESCRIPTION: destructor
 */
template<typename T>
List<T>::~List()
{
  // Variables
  size_t idx = 0;

  // Iterate through list
  while (idx++ < size)
  {
    remove(0);
  }
}

/*
 * List::get_size
 *   DESCRIPTION: returns the size of the list
 *   INPUTS: none
 *   OUTPUTS: none
 *   RETURN VALUE: size of list
 *   SIDE EFFECTS: none
 */
template<typename T>
size_t List<T>::get_size() const
{
  return size;
}

/*
 * List::insert
 *   DESCRIPTION: inserts data into the list
 *   INPUTS: index -- location where to insert data
 *           data -- data to be inserted
 *   OUTPUTS: none
 *   RETURN VALUE: none
 *   SIDE EFFECTS: increase the list size by one
 */
template<typename T>
void List<T>::insert(size_t index, T data)
{
  // Variables
  Node<T> **cur = &head;
  size_t idx = 0;

  // Iterate through list
  while (cur != NULL && idx++ < index)
  {
    cur = (*cur)->get_next_addr();
  }

  // Create new node
  Node<T> *nd = new Node<T>();
  nd->set_data(data); 
  nd->set_next(*cur);
  *cur = nd;

  // Update tail
  if (idx == ++size)
  {
    tail = nd;
  }
}

/*
 * List::remove
 *   DESCRIPTION: removes data at location specified by index
 *   INPUTS: index -- location of data to be removed
 *   OUTPUTS: none
 *   RETURN VALUE: none
 *   SIDE EFFECTS: none
 */
template<typename T>
void List<T>::remove(size_t index)
{
  // Check list size
  if (size <= 0)
  {
    return;
  }

  //Variables
  size_t idx = 0;
  Node<T> **cur = &head;

  // Iterate through list
  while(idx++ < index)
  {
    cur = (*cur)->get_next_addr();
  }

  // Remove node and adjust pointer
  Node<T> *temp = *cur;
  *cur = (*cur)->get_next();
  delete(temp);
  size--;
}

/*
 * List::at
 *   DESCRIPTION: returns the data at location specified by index
 *   INPUTS: index -- location of data to return
 *   OUTPUTS: none
 *   RETURN VALUE: data at location index
 *   SIDE EFFECTS: none
 */
template<typename T>
T List<T>::at(size_t index) const
{
  // Check list size
  if (size <= 0)
  {
    return 0;
  }
  
  // Variables
  size_t idx = 0;
  Node<T> *cur = head;

  // Iterate through list
  while (idx++ < index)
  {
    cur = cur->get_next();
  }

  return cur->get_data();
}

/*
 * List::operator <<
 *   DESCRIPTION: overloads the << operator to print out the list
 */
template<typename T>
std::ostream &operator <<(std::ostream &stream, const List<T> &list)
{
  // Variables
  Node<T> *cur = list.head;

  // Iterate through the list
  while (cur != NULL)
  {
    stream << cur->get_data() << ' ';
    cur = cur->get_next();
  }

  return stream;
}
