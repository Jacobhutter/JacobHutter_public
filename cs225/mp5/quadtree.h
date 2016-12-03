/**
 * @file quadtree.h
 * Quadtree class definition.
 * @date Spring 2008
 */

#ifndef QUADTREE_H
#define QUADTREE_H

#include "png.h"
#include <cmath>

/**
 * A tree structure that is used to compress PNG images.
 */
class Quadtree
{
  public:

    Quadtree(); // done
    Quadtree(PNG const &source, int resolution); // done
    Quadtree(Quadtree const &other); // done
    ~Quadtree();  // done
    Quadtree const & operator= (Quadtree const &other); // done
    void buildTree(PNG const &source, int resolution);
    RGBAPixel getPixel(int x,int y) const;
    PNG decompress() const;
    // mp5.1 ^^^^^^
    void clockwiseRotate();
    void prune(int tolerance);
    int pruneSize(int tolerance) const;
    int idealPrune(int numLeaves) const;


  private: // helper functions
    /**
     * A simple class representing a single node of a Quadtree.
     * You may want to add to this class; in particular, it could
     * probably use a constructor or two...
     */
    class QuadtreeNode
    {
      public:
        // add assignment operator
        QuadtreeNode* nwChild; /**< pointer to northwest child */
        QuadtreeNode* neChild; /**< pointer to northeast child */
        QuadtreeNode* swChild; /**< pointer to southwest child */
        QuadtreeNode* seChild; /**< pointer to southeast child */
        int res;
        int x;
        int y;
        RGBAPixel element; /**< the pixel stored as this node's "data" */
        QuadtreeNode(){
          res = 0;
          x = 0;
          y = 0;
          nwChild = neChild = swChild = seChild = NULL;
        }
        QuadtreeNode(int r, int xi, int yi){
        //  if(r < 1 || x<0 || y<0)
          //  return;
          res = r;
          x = xi;
          y = yi;
          nwChild = neChild = swChild = seChild = NULL;
        }


    };
    QuadtreeNode* root; /**< pointer to root of quadtree */
    Quadtree::QuadtreeNode * copy(QuadtreeNode * const &other); // done
    void clear(); // done
    void rec_fill( QuadtreeNode* const & other, QuadtreeNode* &cpy);  //done
    void rec_clr(QuadtreeNode* &root);  // done
    RGBAPixel getPixel_rec(int x, int y, QuadtreeNode * root ) const;
    bool withinBounds(QuadtreeNode * root, int x, int  y) const;
    void buildTree_rec(PNG const &source, int resolution, QuadtreeNode * leaf);
    void clockwiseRotate(QuadtreeNode * subtree);
    void prune(QuadtreeNode * & subtree, int tolerance);
    bool allchildren(QuadtreeNode * subtree, QuadtreeNode *reference, int tolerance) const;
    bool pixel_tolerance(QuadtreeNode * subtree, QuadtreeNode * reference, int tolerance) const;
    void decompress_rec(size_t xi, size_t yi, int resolution, PNG & image, QuadtreeNode * subtree) const;
    bool isLeafNode(QuadtreeNode * subtree) const;
    void pruneSize(QuadtreeNode * subtree , int tolerance, int & total) const;
    void rec_count(QuadtreeNode * subtree, int & count) const;
    int  binary_search(int numLeaves, int dist, int step) const;



/**** Functions for testing/grading                      ****/
/**** Do not remove this line or copy its contents here! ****/
#include "quadtree_given.h"
};

#endif
