/**
 * @file kdtree.cpp
 * Implementation of KDTree class.
 */

template <int Dim>
bool KDTree<Dim>::smallerDimVal(const Point<Dim>& first,
                                const Point<Dim>& second, int curDim) const
{
    /**
     * @todo Implement this function!
     */
     if(first[curDim] == second[curDim] )
      return first < second;
     else
      return first[curDim] < second[curDim];
}

template <int Dim>
bool KDTree<Dim>::shouldReplace(const Point<Dim>& target,
                                const Point<Dim>& currentBest,
                                const Point<Dim>& potential) const
{
    /**
     * @todo Implement this function!
     */
     int potential_dist = 0;
     int currentBest_dist = 0;
     for ( int i = 0; i < Dim; i++){
        currentBest_dist += pow(target[i] - currentBest[i] , 2);
        potential_dist += pow(target[i] - potential[i] , 2);
     }
    currentBest_dist = sqrt(currentBest_dist);
    potential_dist = sqrt(potential_dist);
    if(potential_dist == currentBest_dist) // tie breaker rule
      return potential < currentBest;
    if (potential_dist < currentBest_dist) // else do shallow comparison
      return true;
    else
      return false;
}

template <int Dim>
KDTree<Dim>::KDTree(const vector<Point<Dim>>& newPoints)
{

    if(newPoints.empty())
      return;
    points =  newPoints;
    rec_KDTree(0,points.size() - 1 ,0);


}

template <int Dim>
void KDTree<Dim>::rec_KDTree(int left, int right, int dimension)
{
  if(left == right) // base case
    return;
  int median = (left + right)/2; // integer truncation assumes flr function
    select(left,right,median,dimension);
    // alternate dimesions to be tested on
  if(left < median)
    rec_KDTree(left, median - 1, (dimension + 1)%Dim);
  if(right > median)
    rec_KDTree(median + 1,right, (dimension+1)%Dim);

}



template <int Dim>
int KDTree<Dim>::partition(int left, int right, int pivotIndex, int dimension) // partition subfunction for quickselect
{
    Point<Dim> pivotValue = points[pivotIndex];
    Point<Dim> temp = points[right];
    // swap
    points[right] = pivotValue;
    points[pivotIndex] = temp;
    int storeIndex = left;
    for(int i = left; i < right; i++){
      if(smallerDimVal(points[i], pivotValue, dimension) || points[i] == pivotValue ){ // swap
        temp = points[i];
        points[i] = points[storeIndex];
        points[storeIndex] = temp;
        storeIndex++;
      }
    }
    temp = points[right];
    points[right] = points[storeIndex];
    points[storeIndex] = temp;
    return storeIndex;

}

template <int Dim>
void KDTree<Dim>::select(int left, int right, int n, int dimension)
{
  if(left == right)
    return;

      int pivotNewIndex = partition(left, right, n, dimension);
      if (pivotNewIndex == n)
          return ;
      else if (n < pivotNewIndex)
          select(left,pivotNewIndex -1, n, dimension);
      else
      {
          select(pivotNewIndex +1, right, n, dimension);
      }


}

template <int Dim>
Point<Dim> KDTree<Dim>::findNearestNeighbor(const Point<Dim>& query) const
{
    Point<Dim> * local_best = new Point<Dim>;
    *local_best = points[(points.size()-1)/2];
    findNearestNeighbor(query, local_best, 0 , points.size()-1 , 0);
    Point<Dim> retval = *local_best;
    delete local_best;
    return retval;
}

template <int Dim>
void KDTree<Dim>::findNearestNeighbor(const Point<Dim>& query, Point<Dim>* & local_best, size_t lower, size_t upper, int curDim) const{

  if(lower < 0 || upper > points.size())
    return;

  if((upper - lower) == 0){ // base case
    if(shouldReplace(query,*local_best,points[lower])){
      *local_best = points[lower];
    }
    if(shouldReplace(query,*local_best,points[upper])){
      *local_best = points[upper];
    }
    return;
  }

  size_t median = (lower + upper)/2;
  if(points[median] == query){
    *local_best = points[median];
    return;
  }


  if(smallerDimVal(query,points[median],curDim) && lower < median){ // if target < query traverse left
    findNearestNeighbor(query, local_best, lower,median-1,(curDim + 1)%Dim);
    if(shouldReplace(query,*local_best,points[median]))
      *local_best = points[median];
    int distance = (points[median])[curDim] - query[curDim];
    distance = distance * distance; // get distance between current point and query curDim to see if worth going for it
    int distance2 = 0;
    for(int i = 0; i < Dim; i++){
      int difference = query[i] - (*local_best)[i];
      difference = difference * difference;
      distance2 += difference;
    }
    if(distance <= distance2){
     if(lower < median)
      findNearestNeighbor(query, local_best, median+1, upper, (curDim + 1)%Dim);
   }
  }




  else{
    if(upper > median){
    findNearestNeighbor(query, local_best, median+1,upper,(curDim + 1)%Dim); // traverse right
    if(shouldReplace(query,*local_best,points[median]))
      *local_best = points[median];

    // calc distance between
    int distance = (points[median])[curDim] - query[curDim];
    distance = distance * distance; // get distance between current point and query curDim to see if worth going for it
    int distance2 = 0;
    for(int i = 0; i < Dim; i++){
      int difference = query[i] - (*local_best)[i];
      difference = difference * difference;
      distance2 += difference;
    }
    if(distance <= distance2){ // if distance is small then explore node if not then exit
      if(upper > median)
        findNearestNeighbor(query, local_best, lower,median-1,(curDim + 1)%Dim);
    }
   }
  }

}