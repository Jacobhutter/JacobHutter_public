#include "imageData.h"
#include "functions.h"



/*
 * calculate_cosine_filter - calculates the cosine filter values
 * INTPUTS:  int radius- integer indicating the size of array. 
 *           The filter has 2*radius+1 rows and 2*radius+1 columns
 * OUTPUTS:  cosine_fitler - pointer to the 1-D array of size 
 *           (2*radius+1)*(2*radius+1). Appropriate space has already been
 *           allocated. This function must compute
 *           the appropriate values of this array as described in the wiki
 * RETURN VALUE: none
 */
void calculate_cosine_filter(double *cos_filter,int radius)
{
    //YOUR CODE HERE
}

/* convolve_image - performs a convolution between a filter and image
 * INPUTS: in_red - pointer to the input red channel (1-D array)
 *         in_green - pointer to the input green channel (1-D array)
 *         in_blue - pointer to the input blue channel (1-D array) 
 *         in_alpha - pointer to the input alpha channel (1-D array)
 *         filter - pointer to the convolution filter (1-D array)
 *         radius - radius of the convolution filter
 *         width - width of the input image
 *         height - height of the input image
 * OUTPUTS: out_red - pointer to the output red channel (1-D array)
 *          out_green - pointer to the output green channel (1-D array)
 *          out_blue - pointer to the output blue channel (1-D array)
 *          out_alpha - pointer to the output alpha channel (1-D array)
 * RETURN VALUES: none
 * NOTE: Input image values are already loaded into the input arrays
 *       Don't alter the values of the input image.
 *       Filter is already initialized and contains desired values.
 *       Appropriate space has been allocated for output arrays. 
 */
void convolve_image(uint8_t *in_red,uint8_t *in_green,uint8_t *in_blue,
                   uint8_t *in_alpha, uint8_t *out_red,uint8_t *out_green,
                   uint8_t *out_blue,uint8_t *out_alpha,const double *filter,
                   int radius,int width,int height)
{
    //YOUR CODE HERE
}

/* convert_to_gray - convert the input image to grayscale
 * INPUTS: in_red - pointer to the input red channel (1-D array)
 *         in_green - pointer to the input green channel (1-D array)
 *         in_blue - pointer to the input blue channel (1-D array)
 *         in_alpha - pointer to the input alpha channel (1-D array)
 *         gmonomult - pointer to array with constants to be multipiled with 
 *                     RBG channels to convert image to grayscale (3 element array)
 *         width - width of the input image
 *         height - height of the input image
 * OUTPUTS: out_red - pointer to the output red channel (1-D array)
 *          out_green - pointer to the output green channel (1-D array)
 *          out_blue - pointer to the output blue channel (1-D array)
 *          out_alpha - pointer to the output alpha channel (1-D array)
 * RETURN VALUES: none
 * NOTE: Input image values are already loaded into the input arrays
 *       gmonomult contains the desired grayscale weights.
 *       Appropriate space has been allocated for output arrays. 
 *       Don't alter the values of the input image.
 */
void convert_to_gray(uint8_t *in_red,uint8_t *in_green,uint8_t *in_blue,
                   uint8_t *in_alpha,uint8_t *out_red,uint8_t *out_green,
                   uint8_t *out_blue,uint8_t *out_alpha,
                   const double *gmonomult,int width,int height)
{
    //YOUR CODE HERE
}

/* flip_vertical- flips image vertically such that the bottom row of pixels
 *                in the input image is the top row of pixels in the output 
 *                image, the second most bottom row in the input image is the 
 *                second row from the top of the input image, and so on. This should
 *                flip the image upside-down.
 * INPUTS: in_red - pointer to the input red channel (1-D array)
 *         in_green - pointer to the input green channel (1-D array)
 *         in_blue - pointer to the input blue channel (1-D array)
 *         in_alpha - pointer to the input alpha channel (1-D array)
 *         width - width of the input image
 *         height - height of the input image
 * OUTPUTS: out_red - pointer to the output red channel (1-D array)
 *          out_green - pointer to the output green channel (1-D array)
 *          out_blue - pointer to the output blue channel (1-D array)
 *          out_alpha - pointer to the output alpha channel (1-D array)
 * RETURN VALUES: none
 * NOTE: Input image values are already loaded into the input arrays
 *       Appropriate space has been allocated for output arrays. 
 *       Don't alter the values of the input image.
 */
void flip_vertical(uint8_t *in_red,uint8_t *in_green,uint8_t *in_blue,
                 uint8_t *in_alpha,uint8_t *out_red,uint8_t *out_green,
                 uint8_t *out_blue,uint8_t *out_alpha,int width,int height)
{
    //YOUR CODE HERE
}

/* color_threshold - for each pixel of input image, compares value to red, green, and blue threshold.
                     If the values exceed all three thresholds, set the output image to the input image values. 
                     Otherwise, set them to zero. Alpha should remain unchanged.
 * INPUTS: in_red - pointer to the input red channel (1-D array)
 *         in_green - pointer to the input green channel (1-D array)
 *         in_blue - pointer to the input blue channel (1-D array)
 *         in_alpha - pointer to the input alpha channel (1-D array)
 *         width - width of the input image
 *         height - height of the input image
 * OUTPUTS: out_red - pointer to the output red channel (1-D array)
 *          out_green - pointer to the output green channel (1-D array)
 *          out_blue - pointer to the output blue channel (1-D array)
 *          out_alpha - pointer to the output alpha channel (1-D array)
 * RETURN VALUES: none
 * NOTE: Input image values are already loaded into the input arrays
 *       Appropriate space has been allocated for output arrays. 
 *       Don't alter the values of the input image.
 */
void color_threshold(uint8_t *in_red,uint8_t *in_green,uint8_t *in_blue,
                 uint8_t *in_alpha,uint8_t *out_red,uint8_t *out_green,
                 uint8_t *out_blue,uint8_t *out_alpha,int width,int height,
                 int red_threshold,int blue_threshold,int green_threshold)
{
     //YOUR CODE HERE
}
