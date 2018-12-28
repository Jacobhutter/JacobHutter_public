#include <stdlib.h>
#include "gradientColorPicker.h"

/**
 * Constructs a new gradientColorPicker.
 *
 * @param fadeColor1 The first color to start the gradient at.
 * @param fadeColor2 The second color to end the gradient with.
 * @param radius How quickly to transition to fadeColor2.
 * @param centerX X coordinate for the center of the gradient.
 * @param centerY Y coordinate for the center of the gradient.
 */
gradientColorPicker::gradientColorPicker(RGBAPixel fadeColor1,
                                         RGBAPixel fadeColor2, int radius,
                                         int centerX, int centerY)
{
    startColor = fadeColor1;
    endColor = fadeColor2;
    rad = radius;
    x_cent = centerX;
    y_cent = centerY;
    /*f(rad <0)
      rad = 0;
    else
      rad = radius;
    if(x_cent < 0)
      x_cent = 0;
    else
      x_cent = centerX;
    if(y_cent <0)
      y_cent = 0;
    else
      y_cent = centerY;*/
    /**
     * @todo Construct your gradientColorPicker here! You may find it
     *	helpful to create additional member variables to store things.
     */
}

/**
 * Picks the color for pixel (x, y).
 *
 * The first color fades into the second color as you move from the initial
 * fill point, the center, to the radius. Beyond the radius, all pixels
 * should be just color2.
 *
 * You should calculate the distance between two points using the standard
 * Manhattan distance formula,
 *
 * \f$d = |center\_x - given\_x| + |center\_y - given\_y|\f$
 *
 * Then, scale each of the three channels (R, G, and B) from fadeColor1 to
 * fadeColor2 linearly from d = 0 to d = radius.
 *
 * For example, the red color at distance d where d is less than the radius
 * must be
 *
 * \f$ redFill = fadeColor1.red - \left\lfloor
   \frac{d*fadeColor1.red}{radius}\right\rfloor +
   \left\lfloor\frac{d*fadeColor2.red}{radius}\right\rfloor\f$
 *
 * Note that all values are integers. If you do not follow this formula,
 * your colors may be very close but round differently than ours.
 *
 * @param x The x coordinate to pick a color for.
 * @param y The y coordinate to pick a color for.
 * @return The color selected for (x, y).
 */



RGBAPixel gradientColorPicker::operator()(int x, int y)
{

    int d = abs(x_cent - x) + abs(y_cent - y);
    if(d > rad)
      return endColor;
    RGBAPixel color;
    int red,green,blue;
    red = startColor.red - (d*startColor.red)/rad + (d*endColor.red)/rad;
    green = startColor.green - (d*startColor.green)/rad + (d*endColor.green)/rad;
    blue = startColor.blue - (d*startColor.blue)/rad + (d*endColor.blue)/rad;

    color.red = red;
    color.green = green;
    color.blue = blue;


    return color;
}
