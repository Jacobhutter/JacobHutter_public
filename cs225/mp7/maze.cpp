#include "maze.h"
#include <ctime>
#include <cstdlib>
#include <algorithm>
#include <queue>
#include <map>
using namespace std;

SquareMaze::SquareMaze(){
  mazewidth = 0;
  mazeheight = 0;
  cells = std::vector<cell>();
  maze = DisjointSets();
}

void SquareMaze::makeMaze(int width, int height){

  int area = width * height;
  mazewidth = width;
  mazeheight = height;

  // initialize the maze to have area cells

  maze.addelements(area); // add initial area to maze

  srand(time(NULL)); // set random seed

  std::vector <std::pair<std::pair<int,int>,int>> wall_list;

 // initialize wall_list and cells
  for(int i = 0; i < height; i++){
    for(int j = 0; j < width; j++){
      cell square;
      square.coordinates = std::pair <int,int>(j,i); //(x,y)
      square.bottom = true;
      square.right = true;
      cells.push_back(square); // add fully walled and coordinated cell onto list of cells
      std::pair<int,int> coor(i,j);
      std::pair<std::pair<int,int>,int> cel1(coor,1);
      std::pair<std::pair<int,int>,int> cel2(coor,0);
      wall_list.push_back(cel1);
      wall_list.push_back(cel2);
    }
  }



while(wall_list.size() != 0){

    size_t i = rand() % wall_list.size(); //get random index
    int r_width = wall_list[i].first.first; // get random width
    int r_height = wall_list[i].first.second; // get random height
    int r_wall = wall_list[i].second; // get random wall within the random cell


    std::pair<std::pair<int,int>,int> temp = wall_list[i];
    wall_list[i] = wall_list[wall_list.size() - 1];
    wall_list[wall_list.size() - 1] = temp;
    wall_list.pop_back(); // remove the random coordinate

  if(r_wall == 1 ){ // remove right and check for right edge
    if( (r_width + 1) % width != 0 ){
    if(maze.find((r_height*width) + r_width) != maze.find((r_height*width) + r_width + 1)){ // cycle detection!

        maze.setunion((r_height*width) + r_width,(r_height*width) + r_width + 1); // union the two sets

        cells[(r_height*width) + r_width].right = false; // reference current cell, remove the desired random wall
     }

   }
  }
  else { // remove bottom
      if ( (r_height + 1) % height != 0 ){ // check for bottom edge

        if(maze.find((r_height * width) + r_width) != maze.find(( (r_height + 1) * width) + r_width )){

          maze.setunion(((r_height * width) + r_width),(( (r_height + 1) * width) + r_width )); // join top and bottom cells

          cells[(r_height*width) + r_width].bottom = false; // remove bottom wall of desired random type
        }
      }
  }



 }

}
bool SquareMaze::canTravel(int x, int y, int dir) const{
  cell cur;
  size_t i = y*mazewidth + x;
  cur = cells[i];
//  cout << " cell index:" << i << endl;
//  cout << " cell coordinates: " << cells[i].coordinates.first << cells[i].coordinates.second << endl;
//  cout << " x & y : " << x << y << endl;
//  cout << "direction: " << dir << endl;
  if(dir == 0 && cur.coordinates.first + 1 != mazewidth && cur.right == 0){ // right
  //  cout << "right!" << endl;
    return true;
  }
  if(dir == 1 && cur.coordinates.second + 1 != mazeheight && cur.bottom == 0){ // down
  //  cout << "down!" << endl;
    return true;
  }
  if(dir == 2 && cur.coordinates.first != 0 && cells[i-1].right == 0){// left
  //  cout << "left!" << endl;
    return true;
  }
  if(dir == 3 && cur.coordinates.second != 0 && cells[i-mazewidth].bottom == 0){ // up
  //  cout << "up!" << endl;
    return true;
  }
  //cout << "can't move in " << dir << " direction" << endl;
  return false;
}
void SquareMaze::setWall(int x, int y, int dir, bool exists){
    dir ? cells[y * mazewidth + x].bottom = exists : cells[y * mazewidth + x].right = exists; // one line booya
}



vector<int> SquareMaze::solveMaze(){
  // find maximum length
  const int area = mazewidth*mazeheight;
  int * visited = new int[area];

  for(int i = 0; i < area; i++){ // initialize all cells to distance -1
      visited[i] = -1;
  }

  queue <cell> cell_queue;
  cell_queue.push(cells[0]); // push origin
  visited[0] = 0;
  map<int,int> directions;
   while(!cell_queue.empty()){
    cell cur = cell_queue.front();
    cell_queue.pop(); // remove next elem

    if(canTravel(cur.coordinates.first,cur.coordinates.second,1) && visited[((cur.coordinates.second+1) * mazewidth) + cur.coordinates.first] == -1){ // attempt down
      cell_queue.push(cells[((cur.coordinates.second+1) * mazewidth) + cur.coordinates.first]);
      visited[((cur.coordinates.second+1) * mazewidth) + cur.coordinates.first] = visited[((cur.coordinates.second) * mazewidth) + cur.coordinates.first] + 1;
      directions[((cur.coordinates.second+1) * mazewidth) + cur.coordinates.first] = ((cur.coordinates.second) * mazewidth) + cur.coordinates.first;
    }
    if(canTravel(cur.coordinates.first,cur.coordinates.second,0) && visited[((cur.coordinates.second) * mazewidth) + cur.coordinates.first + 1] == -1){ // attempt right
      cell_queue.push(cells[((cur.coordinates.second) * mazewidth) + cur.coordinates.first + 1]);
      visited[((cur.coordinates.second) * mazewidth) + cur.coordinates.first + 1] = visited[((cur.coordinates.second) * mazewidth) + cur.coordinates.first] + 1;
      directions[((cur.coordinates.second) * mazewidth) + cur.coordinates.first + 1] = ((cur.coordinates.second) * mazewidth) + cur.coordinates.first;
    }
    if(canTravel(cur.coordinates.first,cur.coordinates.second,2) && visited[((cur.coordinates.second) * mazewidth) + cur.coordinates.first - 1] == -1){ // attempt left
      cell_queue.push(cells[((cur.coordinates.second) * mazewidth) + cur.coordinates.first - 1]);
      visited[((cur.coordinates.second) * mazewidth) + cur.coordinates.first - 1] = visited[((cur.coordinates.second) * mazewidth) + cur.coordinates.first] + 1;
      directions[((cur.coordinates.second) * mazewidth) + cur.coordinates.first - 1] = ((cur.coordinates.second) * mazewidth) + cur.coordinates.first;

    }
    if(canTravel(cur.coordinates.first,cur.coordinates.second,3) && visited[((cur.coordinates.second - 1) * mazewidth) + cur.coordinates.first] == -1){ // attempt up
      cell_queue.push(cells[((cur.coordinates.second - 1) * mazewidth) + cur.coordinates.first]);
      visited[((cur.coordinates.second-1) * mazewidth) + cur.coordinates.first] = visited[((cur.coordinates.second) * mazewidth) + cur.coordinates.first] + 1;
      directions[((cur.coordinates.second-1) * mazewidth) + cur.coordinates.first] = ((cur.coordinates.second) * mazewidth) + cur.coordinates.first;
    }
  }
  int globalmax = 0;
  int coord = 0;
  for(int i = 0; i < mazewidth; i++){
    int localmax = visited[(mazeheight-1)*mazewidth + i];
    if (localmax > globalmax){
      globalmax = localmax;
      coord = (mazeheight-1)*mazewidth + i;
    }
  }
  exit_index = coord;
  //cout << endl << coord << endl;
  /*for(int i = 0; i < area; i++){
    //cout << visited[i] << " ";
    if((i+1) % mazewidth == 0)
      //cout << endl;
  }*/

  //cout << endl;
  //cout << globalmax;
    //cout << endl;
    int i =coord;
    vector<int> path;
    while(i != 0){
      //cout << directions[i] << " ";
    if(i + 1 == directions[i])
      path.push_back(2); // right/ left? lol
    else if(i - 1 == directions[i])
      path.push_back(0);
    else if(i + mazewidth == directions[i])
      path.push_back(3);
    else
      path.push_back(1);
    i = directions[i];
    }
    std::reverse(path.begin(),path.end());
  //cout << endl;
  /*for(size_t j = 0; j< path.size(); j++){
    cout << path[j] << " ";
  }
  cout << endl;*/
  delete [] visited;
  return path;
}




PNG * SquareMaze::drawMaze() const{

  PNG * maze_drawing = new PNG(mazewidth * 10 +1,mazeheight*10 + 1);
  // blacken top
  for(int x = 10; x < mazewidth*10 + 1; x++){
    (*maze_drawing)(x,0)->red = 0;
    (*maze_drawing)(x,0)->green = 0;
    (*maze_drawing)(x,0)->blue = 0;
  }
  //blacken left side
  for(int y = 0; y < mazeheight*10 + 1; y++){
    (*maze_drawing)(0,y)->red = 0;
    (*maze_drawing)(0,y)->green = 0;
    (*maze_drawing)(0,y)->blue = 0;

  }
  for(int x = 0; x < mazewidth; x++){
    for(int y =0; y < mazeheight; y++){
      cell colorme = cells[y * mazewidth + x];
      if(colorme.right){
        for(int k =0; k<= 10; k++){
          (*maze_drawing)((x+1)*10,y*10 + k)->red = 0;
          (*maze_drawing)((x+1)*10,y*10 + k)->green = 0;
          (*maze_drawing)((x+1)*10,y*10 + k)->blue = 0;
      }
     }
     if(colorme.bottom){
       for(int k =0; k<= 10; k++){
         (*maze_drawing)(x*10 + k, (y+1)*10)->red = 0;
         (*maze_drawing)(x*10 + k, (y+1)*10)->green = 0;
         (*maze_drawing)(x*10 + k, (y+1)*10)->blue = 0;
      }
     }
    }
  }
  return maze_drawing;
}
PNG * SquareMaze::drawMazeWithSolution(){
  PNG * maze_drawing = drawMaze(); // get drawn non solution
  vector<int> directions = solveMaze();
  int x = 5,y = 5;
  std::reverse(directions.begin(),directions.end());
  while(!directions.empty()){
  int dir = directions.back();
  int i;
  if(dir == 0){ // right
    for(i = 0 ; i < 11; i++){
    (*maze_drawing)(x + i,y)->red = 255;
    (*maze_drawing)(x + i,y)->green = 0;
    (*maze_drawing)(x + i,y)->blue = 0;
    }
    x = x + 10;
   }
   if(dir == 1){ // down
     for(i = 0; i < 11; i++){
     (*maze_drawing)(x,y + i)->red = 255;
     (*maze_drawing)(x,y + i)->green = 0;
     (*maze_drawing)(x,y + i)->blue = 0;
     }
     y = y + 10;
    }
    if(dir == 2){ // left
      for(i = 0; i < 11; i ++){
      (*maze_drawing)(x - i,y)->red = 255;
      (*maze_drawing)(x - i,y)->green = 0;
      (*maze_drawing)(x - i,y)->blue = 0;
      }
      x = x - 10;
     }
     if(dir == 3){ // up
       for(i = 0 ; i < 11; i++){
       (*maze_drawing)(x,y - i)->red = 255;
       (*maze_drawing)(x,y - i)->green = 0;
       (*maze_drawing)(x,y - i)->blue = 0;
       }
       y = y - 10;
      }
      directions.pop_back(); // remove off of the front(back)
  }
  int dest_x,dest_y;
  dest_x = cells[exit_index].coordinates.first;
  dest_y = cells[exit_index].coordinates.second;
  for(int k = 1; k < 10; k++){ // whiten exit index
    (*maze_drawing)(dest_x * 10 + k,(dest_y + 1) * 10)->red = 255;
    (*maze_drawing)(dest_x * 10 + k,(dest_y + 1) * 10)->green = 255;
    (*maze_drawing)(dest_x * 10 + k,(dest_y + 1) * 10)->blue = 255;

  }

  return maze_drawing;
}
