/**
 * @file testdsets.cpp
 * Performs basic tests of DisjointSets.
 * @date April 2007
 * @author Jonathan Ray
 */

#include <iostream>
#include "dsets.h"

using std::cout;
using std::endl;

int main()
{
    DisjointSets s;

    s.addelements(7);
    s.setunion(4, 1);
    s.setunion(2, 3);
    s.setunion(6, 5);
    s.setunion(1, 3);
    cout << s.find(0) << endl;
    cout << s.find(1) << endl;
    cout << s.find(2) << endl;
    cout << s.find(3) << endl;
    cout << s.find(4) << endl;
    cout << s.find(5) << endl;
    cout << s.find(6) << endl;
    cout << "Disjoint Sets test complete" << endl;

    return 0;
}
