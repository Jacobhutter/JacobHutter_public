/**
 * @file list.cpp
 * Doubly Linked List (MP 3).
 *
 * @author Chase Geigle
 * @date (created) Fall 2011
 * @date (modified) Spring 2012, Fall 2012
 *
 * @author Jack Toole
 * @date (modified) Fall 2011
 */

/**
 * Destroys the current List. This function should ensure that
 * memory does not leak on destruction of a list.
 */
#include <iostream>
template <class T>
List<T>::~List()
{
		clear();
    /// @todo Graded in MP3.1
}

/**
 * Destroys all dynamically allocated memory associated with the current
 * List class.
 */
template <class T>
void List<T>::clear()
{
		if(head!=NULL){
			  ListNode * temp;
			for(int i = 0; i < length; i++){
				temp = head;
				if(head->next != NULL)
				  head = head->next;
				temp->next = NULL;
				temp->prev = NULL;
			  if(temp!=NULL)
				  delete temp;
				temp = NULL;
  }
}
			 tail = NULL;
   /// @todo Graded in MP3.1
}

/**
 * Inserts a new node at the front of the List.
 * This function **SHOULD** create a new ListNode.
 *
 * @param ndata The data to be inserted.
 */
/*
	instantiates a list, inserts user data to the front of that list
*/
template <class T>
void List<T>::insertFront(T const& ndata)
{
		ListNode * temp = new ListNode(ndata);

		if(tail == NULL && head != NULL){ // 1 element list
		temp->next = head;
		temp->prev = NULL;
		head->prev = temp;
		head = temp;
		tail = head->next;
		++length;
		return;

 }
		if(head == NULL){ // empty list
				head = temp;
				temp = NULL;
				head->next = NULL;
				head->prev = NULL;
				++length;
				return;
 }
		// default scenario //
		temp->next = head;
		temp->prev = NULL;
		head->prev = temp;
		head = temp;
		++length;
		return;
}

/**
 * Inserts a new node at the back of the List.
 * This function **SHOULD** create a new ListNode.
 *
 * @param ndata The data to be inserted.
 */
/*
	instantiates a list, inserts user data to the back of that list
*/
template <class T>
void List<T>::insertBack(const T& ndata)
{
		ListNode * temp = new ListNode(ndata);

		if(tail == NULL && head != NULL){ // 1 element list
		tail = temp;
		tail->next = NULL;
		tail->prev = head;
		head->next = tail;
		++length;
		return;

 }
		if(head == NULL){ // empty list
				head = temp;
				temp = NULL;
				head->next = NULL;
				head->prev = NULL;
				++length;
				return;
 }
		// default scenario //
		tail->next = temp;
		temp->next = NULL;
		temp->prev = tail;
		tail = temp;
		++length;
		return;
}
/**
 * Reverses the current List. default
 */
template <class T>
void List<T>::reverse()
{
    reverse(head, tail);
}

/**
 * Helper function to reverse a sequence of linked memory inside a List,
 * starting at startPoint and ending at endPoint. You are responsible for
 * updating startPoint and endPoint to point to the new starting and ending
 * points of the rearranged sequence of linked memory in question.
 *
 * @param startPoint A pointer reference to the first node in the sequence
 *  to be reversed.
 * @param endPoint A pointer reference to the last node in the sequence to
 *  be reversed.
 */
/*
	reverses *this list starting at startPoint and ending on endPoint
*/
template <class T>
void List<T>::reverse(ListNode*& startPoint, ListNode*& endPoint)
{
		if(startPoint == NULL || endPoint == NULL) // 0 elements or 1 element lists are non reversible
			return;
		int leng=1;
		ListNode * start;
		start = startPoint;
		while(start != endPoint){
      leng++;
			start = start->next;
 }
		ListNode * end;
		ListNode * temp;
		ListNode * start_next;
		ListNode * start_prev;
		ListNode * end_prev;
		ListNode * end_next;
		start = startPoint;
		end = endPoint;
		while(leng > 0 && leng != 1){
		start_prev = start->prev;
		start_next = start->next;
		end_prev = end->prev;
		end_next = end->next;
		if(leng == 2){
			temp = start->prev;
			start->prev = end;
			start->next = end->next;
			end->next = start;
			end->prev = temp;
			if(start_prev != NULL)
				start_prev->next = end;
			if(end_next != NULL)
				end_next->prev = start;
			if(start == head)
				head = end;
			if(tail == end)
				tail = start;

			break;
 }
		temp = start->next;
		start->next = end->next;
		end->next = temp;
		temp = start->prev;
		start->prev = end->prev;
		end->prev = temp;
		if(start_prev != NULL)
				start_prev->next = end;
		start_next->prev = end;
		if(end_next != NULL)
				end_next->prev = start;
		end_prev->next = start;
		if(start == head)
				head = end;
		if(end == tail)
				tail = start;

		start = start_next;
		end = end_prev;
		leng = leng - 2;
 }


    /// @todo Graded in MP3.1
}

/**
 * Reverses blocks of size n in the current List. You should use your
 * reverse( ListNode * &, ListNode * & ) helper function in this method!
 *
 * @param n The size of the blocks in the List to be reversed.
 */
/*
	takes n, then reverses chunks of those size in the list , 12345, n =2===> 21435


*/
template <class T>
void List<T>::reverseNth(int n)
{ if(n < 0 || n == 1)
		return;
	if(n > length)
		n = length;
	ListNode * temp1;
	ListNode * temp2;
	ListNode * temp3;
  temp1 = head;
  int sum1 = 0;
 while(sum1 != length){
  temp2 = head;
 if((sum1 + n) > length)
		sum1 = length;
 else
	sum1 += n;
	for(int i = 1; i < sum1; i++){
		if(temp2->next != NULL)
			temp2 = temp2->next;
 }
			temp3 = temp2->next;
			reverse(temp1,temp2);
			temp1 = temp3;

 }
    /// @todo Graded in MP3.1
}

/**
 * Modifies the List using the waterfall algorithm.
 * Every other node (starting from the second one) is removed from the
 * List, but appended at the back, becoming the new tail. This continues
 * until the next thing to be removed is either the tail (**not necessarily
 * the original tail!**) or NULL.  You may **NOT** allocate new ListNodes.
 * Note that since the tail should be continuously updated, some nodes will
 * be moved more than once.
 */

/*
	takes in list, takes every other element and appends it until we attempt to append the tail or null

*/
template <class T>
void List<T>::waterfall()
{   if(tail == NULL || head == NULL)
			return;
		ListNode * temp = head->next; // 2nd element in list
		ListNode * nex = temp->next; // 3rd element in list, could be null
		ListNode * prev = temp->prev; // 1st element in list

		while(temp != NULL && nex != NULL){
			prev->next = nex;
			nex->prev = prev;
			temp->prev = tail;
			temp->next = NULL;
			tail->next = temp;
			tail = temp;
			temp = nex->next;
			nex = temp->next;
			prev = temp->prev;
 }
    /// @todo Graded in MP3.1
}

/**
 * Splits the given list into two parts by dividing it at the splitPoint.
 *
 * @param splitPoint Point at which the list should be split into two.
 * @return The second list created from the split.
 */
template <class T>
List<T> List<T>::split(int splitPoint)
{
    if (splitPoint > length)
        return List<T>();

    if (splitPoint < 0)
        splitPoint = 0;

    ListNode* secondHead = split(head, splitPoint);

    int oldLength = length;
    if (secondHead == head) {
        // current list is going to be empty
        head = NULL;
        tail = NULL;
        length = 0;
    } else {
        // set up current list
        tail = head;
        while (tail->next != NULL)
            tail = tail->next;
        length = splitPoint;
    }

    // set up the returned list
    List<T> ret;
    ret.head = secondHead;
    ret.tail = secondHead;
    if (ret.tail != NULL) {
        while (ret.tail->next != NULL)
            ret.tail = ret.tail->next;
    }
    ret.length = oldLength - splitPoint;
    return ret;
}

/**
 * Helper function to split a sequence of linked memory at the node
 * splitPoint steps **after** start. In other words, it should disconnect
 * the sequence of linked memory after the given number of nodes, and
 * return a pointer to the starting node of the new sequence of linked
 * memory.
 *
 * This function **SHOULD NOT** create **ANY** new List objects!
 *
 * @param start The node to start from.
 * @param splitPoint The number of steps to walk before splitting.
 * @return The starting node of the sequence that was split off.
 */
template <class T>
typename List<T>::ListNode* List<T>::split(ListNode* start, int splitPoint)
{   ListNode * temp;
		if (start == NULL)
			return NULL;
		int counter = 0;
		temp = start;
		while(counter < splitPoint){
			if(temp->next != NULL)
				temp = temp->next;
			else
				break;
			counter++;
		}
		ListNode * tempp;
		tempp = temp->prev;
		tempp->next = NULL;
		temp->prev = NULL;
    /// @todo Graded in MP3.2
    return temp; // change me!
}

/**
 * Merges the given sorted list into the current sorted list.
 *
 * @param otherList List to be merged into the current list.
 */
template <class T>
void List<T>::mergeWith(List<T>& otherList)
{
    // set up the current list
    head = merge(head, otherList.head);
    tail = head;

    // make sure there is a node in the new list
    if (tail != NULL) {
        while (tail->next != NULL)
            tail = tail->next;
    }
    length = length + otherList.length;

    // empty out the parameter list
    otherList.head = NULL;
    otherList.tail = NULL;
    otherList.length = 0;
}

/**
 * Helper function to merge two **sorted** and **independent** sequences of
 * linked memory. The result should be a single sequence that is itself
 * sorted.
 *
 * This function **SHOULD NOT** create **ANY** new List objects.
 *
 * @param first The starting node of the first sequence.
 * @param second The starting node of the second sequence.
 * @return The starting node of the resulting, sorted sequence.
 */
template <class T>
typename List<T>::ListNode* List<T>::merge(ListNode* first, ListNode* second)
{  	ListNode * retadd;
    ListNode * templist; //
    ListNode * nexttemp; //
    ListNode * tempfirst; //
    ListNode * tempsecond; //
		tempfirst = first;
		tempsecond = second;

		if(tempfirst == NULL && tempsecond == NULL)
			return NULL;
		if(tempfirst == NULL)
			return tempsecond;
		if(tempsecond == NULL)
			return tempfirst;


    if ( tempfirst->data < tempsecond->data ){
				retadd = tempfirst;
        templist = tempfirst;
        tempfirst = tempfirst->next;
        head = first;
    }
    else{
				retadd = tempsecond;
        templist = tempsecond;
        tempsecond = tempsecond->next;
        head = second;
    }

    while (tempfirst != NULL || tempsecond != NULL){
				if(tempsecond == NULL){
					templist->next = tempfirst;
					nexttemp = templist->next;
					nexttemp->prev = templist;
					templist = templist->next;
					tempfirst = tempfirst->next;
				}
				else {
					if(tempfirst == NULL ){
						templist->next = tempsecond;
						nexttemp = templist->next;
						nexttemp->prev = templist;
						templist = templist->next;
						tempsecond = tempsecond->next;
					}

        else {
						if(tempfirst->data < tempsecond->data ){
            templist->next = tempfirst;
            nexttemp = templist->next;
            nexttemp->prev = templist;
            templist = templist->next;
            tempfirst = tempfirst->next;
        }
				else {
            templist->next = tempsecond;
            nexttemp = templist->next;
            nexttemp->prev = templist;
            templist = templist->next;
            tempsecond = tempsecond->next;
        }
			}
		}
  }
return retadd;
}

/**
 * Sorts the current list by applying the Mergesort algorithm.
 */
template <class T>
void List<T>::sort()
{
    if (empty())
        return;
    head = mergesort(head, length);
    tail = head;
    while (tail->next != NULL)
        tail = tail->next;
}

/**
 * Sorts a chain of linked memory given a start node and a size.
 * This is the recursive helper for the Mergesort algorithm (i.e., this is
 * the divide-and-conquer step).
 *
 * @param start Starting point of the chain.
 * @param chainLength Size of the chain to be sorted.
 * @return A pointer to the beginning of the now sorted chain.
 */
template <class T>
typename List<T>::ListNode* List<T>::mergesort(ListNode* start, int chainLength)
{	ListNode * ret;
	if(chainLength == 1){
		return start;
	}
	ListNode * step1;
	step1 = split(start,chainLength/2);
	ListNode * step2;
	step2 = start;


		step1 = mergesort(step1,chainLength-(chainLength/2)); // accounts for odd

		start = mergesort(step2,(chainLength/2));
		ret = merge(step1,start);
		return ret;

    // @todo Graded in MP3.2
}
