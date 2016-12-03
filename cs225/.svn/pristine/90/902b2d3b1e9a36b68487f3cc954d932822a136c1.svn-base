/**
 * @file graph_tools.cpp
 * This is where you will implement several functions that operate on graphs.
 * Be sure to thoroughly read the comments above each function, as they give
 *  hints and instructions on how to solve the problems.
 */

#include "graph_tools.h"

/**
 * Finds the minimum edge weight in the Graph graph.
 * THIS FUNCTION IS GRADED.
 *
 * @param graph - the graph to search
 * @return the minimum weighted edge
 *
 * @todo Label the minimum edge as "MIN". It will appear blue when
 *  graph.savePNG() is called in minweight_test.
 *
 * @note You must do a traversal.
 * @note You may use the STL stack and queue.
 * @note You may assume the graph is connected.
 *
 * @hint Initially label vertices and edges as unvisited.
 */
int GraphTools::findMinWeight(Graph& graph)
{
    /* Your code here! */
    Vertex start = graph.getStartingVertex(); // get starting position
    vector<Vertex> verts = graph.getVertices();
    vector<Edge> ed = graph.getEdges();

    std::map<Vertex,bool> vertices;
    for(size_t i = 0; i < verts.size(); i++){ // initialize all verticies to false visited
      vertices[verts[i]] = false;
    }

    std::map<Edge,bool> edges;
    for(size_t i = 0; i < ed.size(); i++){ // initialize all edges to false visited
      edges[ed[i]] = false;
    }


    queue<Vertex> q;
    int minimum_weight = (INT_MAX);
    Vertex a,b;
    q.push(start);
    vertices[start] = true;
    while(!q.empty()){
      Vertex cur = q.front();
      q.pop(); // remove element
      vertices[cur] = true;

      vector<Vertex> adjacent = graph.getAdjacent(cur); // find all the adjacent edges

      for(size_t i = 0; i < adjacent.size(); i++){ // loop through adjacent vertices

        if(!vertices[adjacent[i]]){ // if we havent visited this yet
          Edge cur_edge = graph.getEdge(cur,adjacent[i]); // get that edge
          q.push(adjacent[i]); // push unvisited neighbor to the queue
          if(!edges[cur_edge]){ // if not seen this edge before
            std::cout << "Cur_edge weight: " << cur_edge.weight << endl;
            int wait = cur_edge.weight; // get edge weight
            if(wait < minimum_weight ){
              minimum_weight = wait;
              a = cur;
              b = adjacent[i];
            }
            edges[cur_edge] = true;
          }
        }

      }

    }

    /*void setEdgeLabel(Vertex u, Vertex v, string label);*/
    std::string min = "MIN";
    graph.setEdgeLabel(a,b,min);
    return minimum_weight;
}

/**
 * Returns the shortest distance (in edges) between the Vertices
 *  start and end.
 * THIS FUNCTION IS GRADED.
 *
 * @param graph - the graph to search
 * @param start - the vertex to start the search from
 * @param end - the vertex to find a path to
 * @return the minimum number of edges between start and end
 *
 * @todo Label each edge "MINPATH" if it is part of the minimum path
 *
 * @note Remember this is the shortest path in terms of edges,
 *  not edge weights.
 * @note Again, you may use the STL stack and queue.
 * @note You may also use the STL's unordered_map, but it is possible
 *  to solve this problem without it.
 *
 * @hint In order to draw (and correctly count) the edges between two
 *  vertices, you'll have to remember each vertex's parent somehow.
 */
int GraphTools::findShortestPath(Graph& graph, Vertex start, Vertex end)
{
    /* Your code here! */
    vector<Vertex> verts = graph.getVertices();

    std::map<Vertex,bool> vertices;
    std::map<Vertex,int> distances;
    for(size_t i = 0; i < verts.size(); i++){ // initialize all verticies to false visited
      vertices[verts[i]] = false;
      distances[verts[i]] = 100;
    }



    queue<Vertex> q;
    q.push(start);
    vertices[start] = true;
    distances[start] = 0;

    while(!q.empty()){
      Vertex cur = q.front();
      q.pop(); // remove element
      vertices[cur] = true;
      vector<Vertex> adjacent = graph.getAdjacent(cur); // find all the adjacent edges

      for(size_t i = 0; i < adjacent.size(); i++){ // loop through adjacent vertices

        if(!vertices[adjacent[i]]){ // if we havent visited this yet
          q.push(adjacent[i]);
        }
        if(distances[adjacent[i]] < distances[cur] + 1 ){
            continue;
         }
        else{
          distances[adjacent[i]] = distances[cur] + 1;

        }

      }
    }
    Vertex cur = end;
    while(cur != start){
      vector<Vertex> adjacent = graph.getAdjacent(cur); // find all the adjacent edges
      for(size_t i = 0; i < adjacent.size();i++){
        if(distances[adjacent[i]] == distances[cur] - 1){
          graph.setEdgeLabel(cur,adjacent[i], "MINPATH");
          cur = adjacent[i];
          i = adjacent.size();
        }
      }
    }
    return distances[end];
}

/**
 * Finds a minimal spanning tree on a graph.
 * THIS FUNCTION IS GRADED.
 *
 * @param graph - the graph to find the MST of
 *
 * @todo Label the edges of a minimal spanning tree as "MST"
 *  in the graph. They will appear blue when graph.savePNG() is called.
 *
 * @note Use your disjoint sets class from MP 7.1 to help you with
 *  Kruskal's algorithm. Copy the files into the libdsets folder.
 * @note You may call std::sort instead of creating a priority queue.
 */
void GraphTools::findMST(Graph& graph)
{
    vector<Edge> edgelist = graph.getEdges(); // get a list of all edges in the graph
    vector<Vertex> vertices = graph.getVertices();
    std::map<Vertex,int> themap;
    for(size_t i = 0; i< vertices.size(); i++){ // map the vertex to its index
      themap[vertices[i]] = i;
    }
    std::map<int,Edge> key;
    vector <int> sortme;
    for(size_t i = 0; i < edgelist.size(); i++){
      key[edgelist[i].weight] = edgelist[i]; // map each weight to itself
      sortme.push_back(edgelist[i].weight);
    }
    std::sort(sortme.begin(),sortme.end()); // sort the weights
    for(size_t i = 0; i < sortme.size(); i++){
      edgelist[i] = key[sortme[i]];
    }
    DisjointSets set;
    set.addelements(vertices.size());
    for(size_t i = 0; i < edgelist.size();i++){
      Edge curedge = edgelist[i];
      Vertex s = curedge.source;
      Vertex d = curedge.dest;
      if(set.find(s) != set.find(d)){
        set.setunion(s,d);
        graph.setEdgeLabel(s,d,"MST");
      }

    }

}
