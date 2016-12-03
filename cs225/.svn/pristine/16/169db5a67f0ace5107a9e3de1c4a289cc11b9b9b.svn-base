// this program, written by Jacob Hutter, will take a photo in named in.png in the current working directory and flip it and name it to out.png



#include "png.h"
#include <iostream>
using namespace std;
int main(){
PNG picture;
PNG temp;
picture = PNG("in.png"); // opens new png and calls it picture
size_t height = picture.height(); // gets height and width
size_t width = picture.width();
temp = PNG(width,height);
size_t height2 = 0; 
if ((height % 2) != 0 ) // accounts for odd numbered height photos
	height2 = (height /2);

else 
	height2 = height/2;
size_t width2 = 0;
if ((width %2) != 0)
	width2 = (width/2);
else
	width2 = width /2;
size_t x = 0,y = 0;
for(y = 0; y < width; y++){
 for(x = 0; x < height2  ; x++){
	 *temp(y,x) = *picture(y,x);
	 *picture(y,x) =  *picture(y,(height - 1) -  x); // flip image
	 *picture(y,(height-1)-x) = *temp(y,x);
  }
 }
for(y = 0; y < width2; y++){
   for(x = 0; x < height  ; x++){
           *temp(y,x) = *picture(y,x);
           *picture(y,x) =  *picture((width - 1) - y, x); // flip image
           *picture((width -1) - y,x) = *temp(y,x);
    }
   }

int check = picture.writeToFile("out.png");
if (!check){ 
	cout  << " could not write to file " << endl;
	return 0;
	}
	return 1;
}

