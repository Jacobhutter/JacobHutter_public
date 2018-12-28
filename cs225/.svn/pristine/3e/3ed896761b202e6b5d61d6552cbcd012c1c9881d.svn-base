#include <iostream>
#include <set>
#include <string>
#include <queue>
#include <map>

/* STL Sets have several methods you may (or may not) need:
 *
 * begin() -- return iterator from beginning
 * count(x) -- return number of instances of x in the set (will be 0 or 1)
 * insert(x) -- insert an element x into the set
 * erase(x) -- remove an element x from the set
 * empty() -- test if the set is empty
 * size() -- return number of elements in set
 */

using namespace std;

set<string> findNeighbors(string curr,  set<string>& wordList)
{
    set<string> neighbors;
    int N = curr.size();
    for(int i = 0; i < N; i++)
    {
        for(char c = 'a'; c <= 'z'; c++)
        {
            if(c == curr[i])
                continue;
            string oneChange = curr.substr(0,i) + (c) + curr.substr(i+1);
            if(wordList.count(oneChange))
            {
                neighbors.insert(oneChange);
                wordList.erase(oneChange);
            }
        }
    }
    return neighbors;
}

bool search(set<string> & src, string key){
    for( auto i = src.begin(); i != src.end(); i++){
	if(*i == key)
	 return true;
   }
	return false;
	
}

int sequenceLength(string beginWord, string endWord, set<string>& wordList) {
    map<string,int> distance;
   	for(auto it = wordList.begin(); it != wordList.end(); it++){
	 distance[*it] = -1; // init map to all negative one 
     }
    queue<string> q;
    q.push(beginWord);
    distance[beginWord] = 1;
    while(!q.empty()){
	string cur = q.front();
        q.pop();
	set<string> nearest = findNeighbors(cur,wordList);
	for(auto it = nearest.begin(); it != nearest.end(); it++){
        if(distance[*it] == -1){ // have not seen it 
	 q.push(*it); // push nearest neighbors
	 distance[*it] = distance[cur] + 1;
      }
     }
    }

    return distance[endWord];
}
