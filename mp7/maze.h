#ifndef MAZE_H
#define MAZE_H
#include <iostream>
#include <vector>
#include "png.h"
#include "dsets.h"
using namespace std;

class SquareMaze {
  public:
    SquareMaze();
    void makeMaze(int width, int height);
    bool canTravel(int x, int y, int dir) const;
    void setWall(int x, int y, int dir, bool exists);
    std::vector<int> solveMaze();
    PNG * drawMaze() const;
    PNG * drawMazeWithSolution();
    struct cell{

        std::pair <int,int> coordinates;
        bool bottom; // bottom wall
        bool right; // right wall
        cell(){
          bottom = true;
          right = true;
          coordinates = pair<int,int>();
        }
    };

  private:
    vector<cell> cells;
    DisjointSets maze;
    int mazewidth;
    int mazeheight;
};





#endif
