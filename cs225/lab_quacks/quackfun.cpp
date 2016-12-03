/**
 * @file quackfun.cpp
 * This is where you will implement the required functions for the
 *  stacks and queues portion of the lab.
 */

namespace QuackFun {

/**
 * Sums items in a stack.
 * @param s A stack holding values to sum.
 * @return The sum of all the elements in the stack, leaving the original
 *  stack in the same state (unchanged).
 *
 * @note You may modify the stack as long as you restore it to its original
 *  values.
 * @note You may use only two local variables of type T in your function.
 *  Note that this function is templatized on the stack's type, so stacks of
 *  objects overloading the + operator can be summed.
 * @note We are using the Standard Template Library (STL) stack in this
 *  problem. Its pop function works a bit differently from the stack we
 *  built. Try searching for "stl stack" to learn how to use it.
 * @hint Think recursively!
 */


template <typename T>
T sum(stack<T>& s)
{  if(s.size() == 0)
     return 0;
    T total = 0;
    total += s.top();
    T push_data = s.top();
    s.pop();
    total += sum(s);
    s.push(push_data);
    return total;       // stub return value (0 for primitive types). Change this!
                // Note: T() is the default value for objects, and 0 for
                // primitive types
}

/**
 * Reverses even sized blocks of items in the queue. Blocks start at size
 * one and increase for each subsequent block.
 * @param q A queue of items to be scrambled
 *
 * @note Any "leftover" numbers should be handled as if their block was
 *  complete.
 * @note We are using the Standard Template Library (STL) queue in this
 *  problem. Its pop function works a bit differently from the stack we
 *  built. Try searching for "stl stack" to learn how to use it.
 * @hint You'll want to make a local stack variable.
 */

template <typename T>
void scramble(queue<T>& q)
{   int n= 1;
    int k =1 ;
    stack<T> s;
    queue<T> q2;
    while(q.size() != 0){
      n=1;
      while((k%2 == 0) && n<=k && q.size()!=0){
        s.push(q.front());
        q.pop();
        n++;
      }
      if(k%2 == 0){// even(flipped)
        while(s.size()!=0){
        q2.push(s.top());
        s.pop();
        n--;
       }
      }
      else{
        n = k;
      while(n!= 0){
        q2.push(q.front());
        q.pop();
        n--;
      }
    }
      k++;
    }
    while(q2.size()!=0){
      q.push(q2.front());
      q2.pop();
    }

    // optional:

    // Your code here
}

/**
 * @return true if the parameter stack and queue contain only elements of
 *  exactly the same values in exactly the same order; false, otherwise.
 *
 * @note You may assume the stack and queue contain the same number of items!
 * @note There are restrictions for writing this function.
 * - Your function may not use any loops
 * - In your function you may only declare ONE local boolean variable to use in
 *   your return statement, and you may only declare TWO local variables of
 *   parametrized type T to use however you wish.
 * - No other local variables can be used.
 * - After execution of verifySame, the stack and queue must be unchanged. Be
 *   sure to comment your code VERY well.
 */
template <typename T>
bool verifySame(stack<T>& s, queue<T>& q)
{

    bool ret; // optional
    T stack_temp; // rename me
    T queue_temp; // rename :)
    if(s.size() == 0) // reached bottom of the stack
      return true; // must  be true so bottom only depends on if vals are the same
    else{
      stack_temp = s.top(); // get the stack val for this recursive step
      s.pop(); // pop that item off of the stack
      ret = verifySame(s,q); // continues until now we are at loweset level of stack
      queue_temp = q.front(); // get first item in the queue matched with stack bottom
      ret = ((queue_temp == stack_temp)&&ret); // if the previous step was false, all others are false
      q.pop();
      q.push(queue_temp);
      s.push(stack_temp);
      return ret;
    }

    return ret;
}

}
