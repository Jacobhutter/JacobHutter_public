/**
 * @file main.cpp
 * Contains code to test your Quadtree implementation.
 */

#include <iostream>
#include "png.h"
#include "quadtree.h"

using std::cout;
using std::endl;

int main()
{

    PNG imgIn, imgOut;
    imgIn.readFromFile("in.png");

    // test constructor, decompress
    //cout << "good" << endl;
    Quadtree halfTree(imgIn, 128);
    //cout << "good?" << endl;
    //cout << "oh boy.... here comes the next one...." << endl;
    imgOut = halfTree.decompress();
    //cout << "mercia" << endl;
    imgOut.writeToFile("outHalf.png");
    //cout << "mexico" << endl;
    // now for the real tests
    Quadtree fullTree;
    //cout << "default constructor is good" << endl;
    fullTree.buildTree(imgIn, 256);
    //cout << "segfault round 2" << endl;
    // you may want to experiment with different commands in this section

    // test pruneSize and idealPrune (slow in valgrind, so you may want to
    // comment these out when doing most of your testing for memory leaks)
    cout << "fullTree.pruneSize(0) = "      << fullTree.pruneSize(0) << endl;
    cout << "fullTree.pruneSize(100) = "    << fullTree.pruneSize(100) << endl;
    cout << "fullTree.pruneSize(1000) = "   << fullTree.pruneSize(1000) << endl;
    cout << "fullTree.pruneSize(100000) = " << fullTree.pruneSize(100000) << endl;

    cout << "fullTree.idealPrune(1000) = "  << fullTree.idealPrune(1000) << endl;
    cout << "fullTree.idealPrune(10000) = " << fullTree.idealPrune(10000) << endl;
  //  cout << "break" << " " << __LINE__ << endl;
    // Test some creation/deletion functions
    Quadtree fullTree2;
    fullTree2 = fullTree;
    //cout << "break" << " " << __LINE__ << endl;
    imgOut = fullTree2.decompress();
    imgOut.writeToFile("outCopy.png");
    //cout << "break" << " " << __LINE__ << endl;
    // test clockwiseRotate
    fullTree.clockwiseRotate();
    imgOut = fullTree.decompress();
    imgOut.writeToFile("outRotated.png");
    //cout << "break" << " " << __LINE__ << endl;
    // test prune
    fullTree = fullTree2;
    fullTree.prune(1000);
    imgOut = fullTree.decompress();
    imgOut.writeToFile("outPruned.png");
    //cout << "break" << " " << __LINE__ << endl;
    // test several functions in succession
    Quadtree fullTree3(fullTree2);
    fullTree3.clockwiseRotate();
    fullTree3.prune(10000);
    fullTree3.clockwiseRotate();
    fullTree3.clockwiseRotate();
    fullTree3.clockwiseRotate();
    imgOut = fullTree3.decompress();
    imgOut.writeToFile("outEtc.png");
    //cout << "break" << " " << __LINE__ << endl;
    // ensure that printTree still works
    Quadtree tinyTree(imgIn, 32);
    cout << "Printing tinyTree:\n";
    tinyTree.prune(100);
    tinyTree.printTree();
    //cout << "break" << " " << __LINE__ << endl;
    return 0;
}