#ifndef LIST_H
#define LIST_H 

#include <cstddef>
#include <iostream>

// Forward declare Node
template<typename N> 
class Node;

// Forward declare Node::operator <<
template<typename N> 
std::ostream &operator <<(std::ostream &stream, const Node<N> &node);

// Node class
template<typename N>
class Node
{
  public:
    Node();
    ~Node();

    // Node public  functions
    N get_data() const;
    void set_data(N dt);
    Node<N> *get_next() const;
    Node<N> **get_next_addr();
    void set_next(Node<N> *nxt);
    friend std::ostream &operator << <>(std::ostream &stream,
        const Node<N> &node);

  private:
    // Node variables
    N data;
    Node<N> *next;
};

// Forward declare List
template<typename T> 
class List;

// Forward declare List::operator <<
template<typename T> 
std::ostream &operator <<(std::ostream &stream, const List<T> &list);

// List class
template<typename T> 
class List
{
  public:
    List();
    ~List();

    // List public functions
    std::size_t get_size() const;
    void insert(std::size_t index, T data);
    void remove(std::size_t index);
    T at(size_t index) const;
    friend std::ostream &operator << <>(std::ostream &stream,
        const List<T> &list);

  private:
    // List variables
    Node<T> *head, *tail;
    size_t size;
};

// Template implementations
#include "node.tpp"
#include "list.tpp"

#endif /* LIST_H */
