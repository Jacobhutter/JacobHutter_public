/**
 * @file filler.cpp
 * Implementation of functions in the filler namespace. Heavily based on
 * old MP4 by CS225 Staff, Fall 2010.
 *
 * @author Chase Geigle
 * @date Fall 2012
 */
#include "filler.h"

animation filler::dfs::fillSolid(PNG& img, int x, int y, RGBAPixel fillColor,
                                 int tolerance, int frameFreq)
{
    /**
     * @todo Your code here! You should replace the following line with a
     * correct call to fill with the correct colorPicker parameter.
     */
    solidColorPicker s(fillColor);
    animation a = filler::fill<Stack>(img,x,y,s,tolerance,frameFreq);
    return a;
}

animation filler::dfs::fillGrid(PNG& img, int x, int y, RGBAPixel gridColor,
                                int gridSpacing, int tolerance, int frameFreq)
{
    /**
     * @todo Your code here! You should replace the following line with a
     * correct call to fill with the correct colorPicker parameter.
     */

     gridColorPicker g(gridColor, gridSpacing);
     animation a = filler::fill<Stack>(img,x,y,g,tolerance,frameFreq);
    return a;
}

animation filler::dfs::fillGradient(PNG& img, int x, int y,
                                    RGBAPixel fadeColor1, RGBAPixel fadeColor2,
                                    int radius, int tolerance, int frameFreq)
{
    /**
     * @todo Your code here! You should replace the following line with a
     * correct call to fill with the correct colorPicker parameter.
     */
     gradientColorPicker g(fadeColor1,fadeColor2,radius,x,y);
     animation a = filler::fill<Stack>(img,x,y,g,tolerance,frameFreq);
    return a;
}

animation filler::dfs::fill(PNG& img, int x, int y, colorPicker& fillColor,
                            int tolerance, int frameFreq)
{
    /**
     * @todo Your code here! You should replace the following line with a
     * correct call to filler::fill with the correct template parameter
     * indicating the ordering structure to be used in the fill.
     */
    // animation a = filler::fill<Stack>(img,x,y,fillColor,tolerance,frameFreq);
    return filler::fill<Stack>(img,x,y,fillColor,tolerance,frameFreq);
}

animation filler::bfs::fillSolid(PNG& img, int x, int y, RGBAPixel fillColor,
                                 int tolerance, int frameFreq)
{
    /**
     * @todo Your code here! You should replace the following line with a
     * correct call to fill with the correct colorPicker parameter.
     */
     solidColorPicker s(fillColor);
    return filler::fill<Queue>(img,x,y,s,tolerance,frameFreq);
}

animation filler::bfs::fillGrid(PNG& img, int x, int y, RGBAPixel gridColor,
                                int gridSpacing, int tolerance, int frameFreq)
{
    /**
     * @todo Your code here! You should replace the following line with a
     * correct call to fill with the correct colorPicker parameter.
     */
     gridColorPicker g(gridColor, gridSpacing);

    return filler::fill<Queue>(img,x,y,g,tolerance,frameFreq);
}

animation filler::bfs::fillGradient(PNG& img, int x, int y,
                                    RGBAPixel fadeColor1, RGBAPixel fadeColor2,
                                    int radius, int tolerance, int frameFreq)
{
    /**
     * @todo Your code here! You should replace the following line with a
     * correct call to fill with the correct colorPicker parameter.
     */
     gradientColorPicker g(fadeColor1,fadeColor2,radius,x,y);
    return filler::fill<Queue>(img,x,y,g,tolerance,frameFreq);
}

animation filler::bfs::fill(PNG& img, int x, int y, colorPicker& fillColor,
                            int tolerance, int frameFreq)
{
    /**
     * @todo Your code here! You should replace the following line with a
     * correct call to filler::fill with the correct template parameter
     * indicating the ordering structure to be used in the fill.
     */
    return filler::fill<Queue>(img,x,y,fillColor,tolerance,frameFreq);
}

template <template <class T> class OrderingStructure>
animation filler::fill(PNG& img, int x, int y, colorPicker& fillColor,
                       int tolerance, int frameFreq)
{
    /**
     * @todo You need to implement this function!
     *
     * This is the basic description of a flood-fill algorithm: Every fill
     * algorithm requires an ordering structure, which is passed to this
     * function via its template parameter. For a breadth-first-search
     * fill, that structure is a Queue, for a depth-first-search, that
     * structure is a Stack. To begin the algorithm, you simply place the
     * given point in the ordering structure. Then, until the structure is
     * empty, you do the following:
     *
     * 1.     Remove a point from the ordering structure.
     *
     *        If it has not been processed before and if its color is
     *        within the tolerance distance (up to and **including**
     *        tolerance away in square-RGB-space-distance) to the original
     *        point's pixel color [that is, \f$(currentRed - OriginalRed)^2 +
              (currentGreen - OriginalGreen)^2 + (currentBlue -
              OriginalBlue)^2 \leq tolerance\f$], then:
     *        1.    indicate somehow that it has been processed (do not mark it
     *              "processed" anywhere else in your code)
     *        2.    change its color in the image using the appropriate
     *              colorPicker
     *        3.    add all of its neighbors to the ordering structure, and
     *        4.    if it is the appropriate frame, send the current PNG to the
     *              animation (as described below).
     * 2.     When implementing your breadth-first-search and
     *        depth-first-search fills, you will need to explore neighboring
     *        pixels in some order.
     *
     *        While the order in which you examine neighbors does not matter
     *        for a proper fill, you must use the same order as we do for
     *        your animations to come out like ours! The order you should put
     *        neighboring pixels **ONTO** the queue or stack is as follows:
     *        **RIGHT(+x), DOWN(+y), LEFT(-x), UP(-y). IMPORTANT NOTE: *UP*
     *        here means towards the top of the image, so since an image has
     *        smaller y coordinates at the top, this is in the *negative y*
     *        direction. Similarly, *DOWN* means in the *positive y*
     *        direction.** To reiterate, when you are exploring (filling out)
     *        from a given pixel, you must first try to fill the pixel to
     *        it's RIGHT, then the one DOWN from it, then to the LEFT and
     *        finally UP. If you do them in a different order, your fill may
     *        still work correctly, but your animations will be different
     *        from the grading scripts!
     * 3.     For every k pixels filled, **starting at the kth pixel**, you
     *        must add a frame to the animation, where k = frameFreq.
     *
     *        For example, if frameFreq is 4, then after the 4th pixel has
     *        been filled you should add a frame to the animation, then again
     *        after the 8th pixel, etc.  You must only add frames for the
     *        number of pixels that have been filled, not the number that
     *        have been checked. So if frameFreq is set to 1, a pixel should
     *        be filled every frame.
     */
     RGBAPixel start = *img(x,y); // get starting pixel
     //int start.red = start.red;
     //int start.green = start.green;
     //int start_blue = start.blue;


     int width = img.width();
     int height = img.height();


     bool ** flag = new bool*[width];
     for(int i = 0; i < width; i++){
       flag[i] = new bool[height];
     }
     for(int i = 0; i < width; i++){
       for(int j = 0; j < height;j++){
         flag[i][j] = false;
       }
     }
     int frame_num = 0;

     OrderingStructure<RGBAPixel> pix;
     pix.add(start);

     OrderingStructure<int> x_coordinate;
     x_coordinate.add(x);

     OrderingStructure<int> y_coordinate;
     y_coordinate.add(y);

     /* dfs and bfs require adding initial element to ordering structures */
     animation a;
     while(!pix.isEmpty()){ // bfs and dfs implemented here
      RGBAPixel cur = pix.remove(); // get item
      int cx = x_coordinate.remove();
      int cy = y_coordinate.remove();

      // euclidian algorthim
      if((((start.red - cur.red)*(start.red - cur.red)) + ((start.green - cur.green)*(start.green - cur.green)) + ((start.blue - cur.blue)*(start.blue - cur.blue))) <= tolerance && !flag[cx][cy]){
        *img(cx,cy) = fillColor(cx,cy); //change color
        // add back to queue in order for dfs
        // right(+x)
        if(cx + 1 < width){ // add to object
          x_coordinate.add(cx+1);
          y_coordinate.add(cy);
          pix.add(*img(cx+1,cy));
        }
        // down(+y)
        if(cy + 1 < height){
          x_coordinate.add(cx);
          y_coordinate.add(cy+1);
          pix.add(*img(cx,cy+1));
        }
        // left(-x)
        if(cx -1 >=0){
          x_coordinate.add(cx-1);
          y_coordinate.add(cy);
          pix.add(*img(cx-1,cy));
        }
        // up(-y)
        if(cy-1 >= 0){
          x_coordinate.add(cx);
          y_coordinate.add(cy-1);
          pix.add(*img(cx,cy-1));
        }

        flag[cx][cy] = true; // make it true;
        ++frame_num;
        if(frame_num == frameFreq){
          frame_num = 0; // reset frame_num
          a.addFrame(img);
          }
         }
       }
     for(int i = 0; i<width;i++){ // free up data for the dynamic array
       delete [] flag[i];
       flag[i] = NULL;
     }
     delete [] flag;
     return a;
}