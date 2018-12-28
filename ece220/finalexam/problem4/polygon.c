#include "polygon.h"

/* This function should read the number of vertices record from the file with the supplied file_name,
     allocate memory for the vertex array, and populate the array with data read from the file.
   Note that only x and y fields need to be populated by this function.
   The function should return a pointer to the populated array of vertex records and the number of read records in count.
   If the function fails to read data from the file, it should return NULL and count should be set to 0.
   INPUT:
        file_name: name of the input file located in the local directory
        count: pointer to an int for holding the number of vertices
   OUTPUTS:
        count: holds the number of vertices
   RETURN:        
        pointer to allocated and populated vertex array
        (NULL if read failure)
*/
vertex* read_polygon(char *file_name, int *count)
{		int i= 0;
		int j = 0;
		FILE * fp;
		fp = fopen(file_name,"r");
		if(fp == NULL){
		 //printf("no file detected, program terminating\n");
		 return NULL;
}
		fscanf(fp,"%i ",count);  // get count and newline
		int array[2*(*count)];
		while(fscanf(fp, "%i ",&j)!=EOF){
			//printf("flag\n");
			array[i] = j;
			++i;
}
		vertex * polygon = (vertex *)malloc((*count)*sizeof(vertex));

		i = 0;
		j = 0;
		while(j<*count){
		polygon[j].x = array[i];
		++i;
		polygon[j].y = array[i];
		++i;
		++j;
}
		
		fclose(fp);  // close file 
    return polygon;
}

/* This function should calculate length of each side of the polygon as well as the polygon’s perimeter.
   The length of polygon’s side is computed as sqrt((x2-x1)^2 + (y2-y1)^2),
   This value should be stored in the length field for polygon with coordinates (x1, y1).
   Perimeter is computed by finding the sum of all side lengths of the polygon.
   This value should be computed and returned by the function.
   INPUT:
        vrtx: pointer to an array of vertices
        count: the length of the vertex array
   OUTPUTS:
        length field of each vertex calculated
   RETURN:        
        calculated perimeter
*/
float calc_perimeter(vertex* vrtx, int count)
{	int i = 0;
	int x1 = 0, x2 = 0;
	int y1 = 0, y2 = 0;
	float perimeter = 0;
		while(i<(count-1)){
		x1 = vrtx[i].x;
		x2  = vrtx[i+1].x;
		y1 = vrtx[i].y;
		y2 = vrtx[i+1].y;
		vrtx[i].length = sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1))	;
		++i;
 }
		x1 = vrtx[i].x;
		x2  = vrtx[0].x;
		y1 = vrtx[i].y;
		y2 = vrtx[0].y;
		vrtx[i].length = sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1))	;
		i = 0;
	while(i<(count)){
		perimeter += vrtx[i].length;
		++i;
}
		
    return perimeter;
}

/* This function should write to file file_name the number of vertices record followed by records
     for each vertex consisting of the space-separated x, y, and length fields, followed by the perimeter.
   The function should also free memory allocated for vertex array.
   It should return 1 if the data is successfully stored in the output file, or 0 otherwise.
   INPUT:
        file_name: name of the output file
        vrtx: pointer to an array of vertices
        count: the length of the vertex array
        perimeter: the perimeter of the polygon
   OUTPUTS:
        data is written to file_name
   RETURN:        
        1 if file successfully written and vertix freed
        0 otherwise
*/
int record_polygon(char *file_name, vertex *vrtx, int count, float perimeter)
{
		FILE * fp;
		fp = fopen(file_name,"w"); // open for writing
		if(fp == NULL)
			return 0;
		int i = 0;
		fprintf(fp,"%i\n",count);
		while(i<count){
		fprintf(fp,"%i %i %f\n",vrtx[i].x,vrtx[i].y,vrtx[i].length);
		++i;
}
		fprintf(fp,"%f\n",perimeter);
		fclose(fp);
		free(vrtx);
    return 1;
}
