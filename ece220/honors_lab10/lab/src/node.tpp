#include <iostream>

#include "list.h"

/*
 * Node::Node
 *   DESCRIPTION: constructor
 */
template<typename N>
Node<N>::Node() : data(0), next(NULL)
{ }

/*
 * Node::~Node
 *   DESCRIPTION: destructor
 */
template<typename N>
Node<N>::~Node()
{ }

/*
 * Node::get_data
 *   DESCRIPTION: returns data of a node
 *   INPUTS: none
 *   OUTPUTS: none
 *   RETURN VALUE: data
 *   SIDE EFFECTS: none
 */
template<typename N>
N Node<N>::get_data() const
{
  return data;
}

/*
 * Node::set_data
 *   DESCRIPTION: set the data of a node
 *   INPUTS: dt -- data to set
 *   OUTPUTS: none
 *   RETURN VALUE: none
 *   SIDE EFFECTS: none
 */
template<typename N>
void Node<N>::set_data(N dt)
{
  data = dt;
}

/*
 * Node::get_next
 *   DESCRIPTION: return pointer to next node in the list
 *   INPUTS: none
 *   OUTPUTS: none
 *   RETURN VALUE: pointer to next node
 *   SIDE EFFECTS: none
 */
template<typename N>
Node<N> *Node<N>::get_next() const
{
  return next;
}

/*
 * Node::get_next_addr
 *   DESCRIPTION: return address of pointer to the next node in the list
 *   INPUTS: none
 *   OUTPUTS: none
 *   RETURN VALUE: address of pointer to the next node
 *   SIDE EFFECTS: none
 */
template<typename N>
Node<N> **Node<N>::get_next_addr()
{
  return &next;
}

/*
 * Node::set_next
 *   DESCRIPTION: set the next pointer of a node
 *   INPUTS: nxt -- next pointer to be set
 *   OUTPUTS: none
 *   RETURN VALUE: none
 *   SIDE EFFECTS: none
 */
template<typename N>
void Node<N>::set_next(Node<N> *nxt)
{
  next = nxt;
}

/*
 * Node::operator <<
 *   DESCRTIPION: overloads the << operator for a node and prints the data
 */
template<typename N>
std::ostream &operator << (std::ostream &stream, const Node<N> &node)
{
  return stream << node.data;
}
