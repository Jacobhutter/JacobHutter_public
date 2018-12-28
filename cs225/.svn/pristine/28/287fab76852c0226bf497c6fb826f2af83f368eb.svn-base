#ifndef IMAGE_H
#define IMAGE_H
#include "png.h"
#include "rgbapixel.h"

class Image : public PNG
{
public:
using PNG::PNG;
void flipleft();
void adjustbrightness(int r, int g, int b);
void invertcolors();
int x_coordinate;
int y_coordinate;
private:
};
#endif
