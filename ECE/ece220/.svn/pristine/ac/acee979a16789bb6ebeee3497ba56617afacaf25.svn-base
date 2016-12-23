#!/bin/bash

score=0
size=("1" "3" "8")
pre=("13" "3 1 5" "6 5 3 4 7 9 8 10")
in=("13" "1 3 5" "3 4 5 6 7 8 9 10")
post=("13" "1 5 3" "4 3 5 8 10 9 7 6")
bfs=("13" "3 1 5" "6 5 7 3 9 4 8 10")
dfs=("13" "3 1 5" "6 5 3 4 7 9 8 10")
level=("13" "1 5" "3 9")
zigzag=("13" "3 5 1" "6 7 5 3 9 10 8 4")
tests=("test1" "test2" "test3")

end=$((${#tests[@]}-1))
for i in $(seq 0 1 $end); do
  res=$(./bin/tree_fun tests/${tests[i]})

  diff=0
  # Size check
  $([[ "$(echo "$res" | sed -n 2p)" =~ ${size[i]} ]]) || ((diff++))

  # Pre check
  $([[ "$(echo "$res" | sed -n 5p)" =~ ${pre[i]} ]]) || ((diff++))

  # In check
  $([[ "$(echo "$res" | sed -n 8p)" =~ ${in[i]} ]]) || ((diff++))

  # Post check
  $([[ "$(echo "$res" | sed -n 11p)" =~ ${post[i]} ]]) || ((diff++))

  # BFS check
  $([[ "$(echo "$res" | sed -n 14p)" =~ ${bfs[i]} ]]) || ((diff++))

  # DFS check
  $([[ "$(echo "$res" | sed -n 17p)" =~ ${dfs[i]} ]]) || ((diff++))

  # Level check
  $([[ "$(echo "$res" | sed -n 20p)" =~ ${level[i]} ]]) || ((diff++))

  # Zigzag check
  $([[ "$(echo "$res" | sed -n 23p)" =~ ${zigzag[i]} ]]) || ((diff++))

  if [[ $diff -eq 0 ]]; then
    echo "Test" $((i + 1))": passed"
    ((score += 1))
  else
    echo "Test" $((i + 1))": failed"
  fi
done

echo "Score: "$score"/"${#tests[@]}
