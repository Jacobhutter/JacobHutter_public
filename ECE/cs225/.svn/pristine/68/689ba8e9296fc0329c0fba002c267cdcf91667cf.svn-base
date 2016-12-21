#include "image.h"
#include <iostream>
using namespace std; 
void Image::flipleft(){
 size_t height = this->height();
 size_t width = this->width();
 RGBAPixel * temp;
 temp = new RGBAPixel;
 size_t width2 = width/2;
 size_t x = 0,y = 0;
 for(y = 0; y <width2; y++){
   for(x = 0; x < height; x++){
     if((*this)(y,x) == NULL)
	return;
     * temp  = *(*this)(y,x);
     *(*this)(y,x) =*(*this)((width - 1) - y,x); 
    *(*this)((width-1)-y,x) = * temp ;
    } 
   }
  delete temp;
  return; 
 }
void Image::adjustbrightness(int r, int g, int b){
	size_t height = this->height();
	size_t width = this->width();
	size_t x = 0, y = 0;
	for(y = 0; y <width; y++){
         for(x = 0; x < height; x++){
	  if ((*this)(y,x) == NULL)
	   return;
	  if ((*this)(y,x)->red + r > 255)
	   (*this)(y,x)->red = 255;
          else{
	   if ((*this)(y,x)->red + r < 0)
		(*this)(y,x)->red  = 0;
	   else
		(*this)(y,x)->red += r;
          }
	  if ((*this)(y,x)->green + g > 255)
            (*this)(y,x)->green = 255;
          else{
           if ((*this)(y,x)->green + g < 0)
                 (*this)(y,x)->green  = 0;
           else
                  (*this)(y,x)->green += g;
           }
	  if ((*this)(y,x)->blue + b > 255)
            (*this)(y,x)->blue = 255;
           else{
            if ((*this)(y,x)->blue + b < 0)
                 (*this)(y,x)->blue  = 0;
            else
                 (*this)(y,x)->blue += b;
           }

		
   }
 } 

	 return;
 }
void Image::invertcolors(){
         size_t height = this->height();
         size_t width = this->width();
         size_t x = 0, y = 0;
         for(y = 0; y <width; y++){
          for(x = 0; x < height; x++){
	   if ( (*this)(y,x) == NULL ){
	     return;
	  }
	  (*this)(y,x)->red = 255 - (*this)(y,x)->red;
	  (* this)(y,x)->green = 255 -(*this)(y,x)->green;
	 (*this)(y,x)->blue = 255 - (*this)(y,x)->blue;
	  }
         }
	return;
}
