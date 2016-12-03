#include "scene.h"
#include <iostream>
using namespace std;

Scene::Scene(int max){
       arr = new Image * [max]; // arr points to image pointer array
       int x = 0;
       maximum = max;
       for (x=0;x<maximum ; ++x)
	arr[x] = NULL;
      /* for (x = 0; x<maximum ; ++x){
	 arr[x] = new Image;  // dynamically allocate space for each entry in arr
 }
 */
}

Scene::~Scene(){
	clear();
}
void Scene::clear(){
	if (arr != NULL){
	 int x;
	for( x = 0; x<maximum; ++x){
  	 if(arr[x] != NULL){
	  delete arr[x];
	  arr[x] = NULL;
          }
  	 }
	 delete [] arr;
	 arr = NULL;
 }
}
Scene::Scene(const Scene & source){
	copy(source);
}
void Scene::copy(const Scene & source){
	maximum = source.maximum;
	int x = 0;
	arr = new Image * [maximum];
	for(x=0;x<maximum;++x) {
	 if (source.arr[x] != NULL){
	 arr[x] = new Image;
	 *arr[x] = *(source.arr[x]);
	 arr[x]->x_coordinate = source.arr[x]->x_coordinate;
	 arr[x]->y_coordinate = source.arr[x]->y_coordinate;
  }
 }
}
const Scene & Scene::operator=( const Scene & source){
	if(this != &source){
	 clear();
	 copy(source);
	}
	return *this;
	
}

void Scene::changemaxlayers( int newmax ){
	if( newmax < maximum || newmax < 0){
	  cout << "invalid newmax" << endl;
	  return;
}
	if(newmax == maximum)
	  return;
	Image ** new_arr = new Image * [newmax];
	int x;
	for(x=0;x<newmax;++x){
	 new_arr[x] = NULL;
 }
	if(arr != NULL){
	for(x = 0 ;x < maximum; ++x){
	 new_arr[x] = arr[x];
  }
 }
	maximum = newmax;
	if(arr != NULL)
	 delete [] arr;
        arr = new_arr;
	// stack var new_arr will disapear, arr holds all the addresses	
}

void Scene::addpicture( const char * FileName, int index, int x, int y){
	if(index >= maximum){
	 cout << "index out of bounds" << endl;
	 return;
	}
	Image * picture = new Image(FileName);
	if(arr[index] != NULL)
	 delete arr[index];
	arr[index] = picture; // delete previous data and store new 
	picture->x_coordinate = x;
	picture->y_coordinate = y;
	
}

void Scene::changelayer( int index, int newindex){
	if(index >= maximum || newindex >= maximum || index < 0 || newindex <0){
	 cout << "invalid index" << endl;
	 return;
 }	
	if( newindex == index)
	   return;
	if (arr[newindex] != NULL)
	 delete arr[newindex];
	arr[newindex] = arr[index];
	arr[index] = NULL;
		
}

void Scene::translate(int index, int xcoord, int ycoord){
	if(index >= maximum || arr[index] == NULL){
	 cout << "invalid index" << endl;
	 return;
 }
	(*arr[index]).x_coordinate = xcoord;
	(*arr[index]).y_coordinate = ycoord;

}

void Scene::deletepicture( int index ){
	if(index >= maximum || arr[index] == NULL){
	 cout << "invalid index" << endl;
	 return;
 }
	delete arr[index];
	arr[index] = NULL;
}

Image * Scene::getpicture( int index ) const {
	if(index >= maximum || arr[index] == NULL){
	 cout << "invalid index" << endl;
	 return NULL;
 }
	return arr[index];
	
}

Image Scene::drawscene() const{
	int x;
	size_t y,z;
	int  width = 0,height = 0;
	int max_width=0, max_height=0;
	for(x=0;x<maximum;x++){
	width = 0;
	height = 0;
	if(arr[x] != NULL){
		width = arr[x]->width() + (arr[x])->x_coordinate;
		height = arr[x]->height() + (arr[x])->y_coordinate;
	if (width > max_width)
		max_width = width;
	if (height > max_height)
		max_height = height;
  }
 }
	Image Whole = Image(max_width,max_height);
 	RGBAPixel * temp;
	RGBAPixel * whole;
	for(x=0;x<maximum;++x){
	if(arr[x] != NULL){
	for(y=0;y<(arr[x])->width();++y){
	 for(z=0;z<(arr[x])->height();++z){

	   temp = (*arr[x])(y,z);
	   whole = Whole(y + arr[x]->x_coordinate, z + arr[x]->y_coordinate);
	   if(temp != NULL && whole != NULL)
		*whole = *temp;
     }
    }
   }
  } 
	return Whole;
}


