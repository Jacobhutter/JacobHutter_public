#!/bin/bash

score=0
out=("1" "5 4 3 2 1")
size=("1 0" "5 4")
tests=("test1" "test2")

end=$((${#tests[@]}-1))
for i in $(seq 0 1 $end); do
  res=$(./bin/stack tests/${tests[i]})
  
  diff=0

  # Output check
  $([[ "$(echo "$res" | sed -n 1p)" =~ ${out[i]} ]] ) || ((diff++))
  
  # Size check
  $([[ "$(echo "$res" | sed -n 2p)" =~ ${size[i]} ]] ) || ((diff++))

  if [[ $diff -eq 0 ]]; then
    echo "Test" $((i + 1))": passed"
    ((score += 1))
  else
    echo "Test" $((i + 1))": failed"
  fi
done

echo "Score: "$score"/"${#tests[@]}
