/**
 * @file maptiles.cpp
 * Code for the maptiles function.
 */

#include <iostream>
#include <map>
#include "maptiles.h"

using namespace std;

MosaicCanvas* mapTiles(SourceImage const& theSource,
                       vector<TileImage> const& theTiles)
{   map<Point<3>,TileImage> mappedtiles;
    vector<Point<3>> newPoints; // declare rgb point dimension
    for(size_t i = 0 ; i < theTiles.size(); i++){
        newPoints.push_back(Point<3> (theTiles[i].getAverageColor().red,theTiles[i].getAverageColor().green,theTiles[i].getAverageColor().blue));
        mappedtiles[Point<3> (theTiles[i].getAverageColor().red,theTiles[i].getAverageColor().green,theTiles[i].getAverageColor().blue)] = theTiles[i];
    }

    KDTree<3> Tree(newPoints);
    MosaicCanvas::MosaicCanvas * retval = new MosaicCanvas(theSource.getRows(), theSource.getColumns());
    for(int i = 0; i < theSource.getRows(); i++){
      for(int j = 0; j < theSource.getColumns(); j++){
         RGBAPixel temp = theSource.getRegionColor(i,j);
         uint8_t red = temp.red;
         uint8_t green = temp.green;
         uint8_t blue = temp.blue;
         Point<3> result = Tree.findNearestNeighbor(Point<3>(red,green,blue));
         TileImage tile = mappedtiles[result];
         retval->setTile(i,j,tile);
      }
    }

    /**
     * @todo Implement this function!
     */
    return retval;
}
