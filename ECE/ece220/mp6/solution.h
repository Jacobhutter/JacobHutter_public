#include <stdint.h>
#include <stdio.h>
#include <math.h>

#ifndef FUNCTIONS_H
#define FUNCTIONS_H

//M_PI missing from c99 standard
#define M_PI           3.14159265358979323846
#define max(a,b) (a>b?a:b)
#define min(a,b) (a>b?b:a)

#endif

int get_radius_sol(double sigma);

void calculate_gaus_filter_sol(double *gaus_filter,double sigma);

void calculate_cosine_filter_sol(double *cos_filter,int radius);

void convolve_image_sol(uint8_t *in_red,uint8_t *in_green,uint8_t *in_blue,
                   uint8_t *in_alpha,uint8_t *out_red,uint8_t *out_green,
                   uint8_t* out_blue,uint8_t* out_alpha,const double *filter,
                   int radius,int width,int height);

void convert_to_gray_sol(uint8_t *in_red,uint8_t *in_green,uint8_t *in_blue,
                   uint8_t *in_alpha,uint8_t *out_red,uint8_t *out_green,
                   uint8_t *out_blue,uint8_t *out_alpha,
                   const double *gmonomult,int width,int height);

void flip_vertical_sol(uint8_t *in_red,uint8_t *in_green,uint8_t *in_blue,
                 uint8_t *in_alpha,uint8_t *out_red,uint8_t *out_green,
                 uint8_t *out_blue,uint8_t *out_alpha,int width,int height);

void color_threshold_sol(uint8_t *in_red,uint8_t *in_green,uint8_t *in_blue,
                 uint8_t *in_alpha,uint8_t *out_red,uint8_t *out_green,
                 uint8_t *out_blue,uint8_t *out_alpha,int width,int height,int red_threshold,int blue_threshold,int green_threshold);

void detect_image_sol(uint8_t *in_red,uint8_t *in_green,uint8_t *in_blue,
                   uint8_t *in_alpha,int* out_pixelcol, int* out_pixelrow, uint8_t *target_red, uint8_t *target_blue,
		   uint8_t *target_green, uint8_t *target_alpha,int width,int height,int target_width, int target_height);

void transform_image_sol(uint8_t *in_red,uint8_t *in_green,uint8_t *in_blue,uint8_t *in_alpha,
              uint8_t *out_red,uint8_t *out_green,uint8_t *out_blue,
              uint8_t *out_alpha,const double transform[2][2],int width,int height);
