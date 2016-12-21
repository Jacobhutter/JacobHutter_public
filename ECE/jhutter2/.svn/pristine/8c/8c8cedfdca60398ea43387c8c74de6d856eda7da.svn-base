#!/bin/bash

score=0
out=("6 5 4 3 2 1 0" "3 2 1 0 4 5 6" "0 1 2 6 5 4 3")
tests=("test1" "test2" "test3")

end=$((${#tests[@]}-1))
for i in $(seq 0 1 $end); do
  res=$(./bin/double_list tests/${tests[i]})

  if [[ "$res" == "${out[i]}"* ]]; then
    echo "Test" $((i + 1))": passed"
    ((score += 1))
  else
    echo "Test" $((i + 1))": failed"
  fi
done

echo "Score: "$score"/"${#tests[@]}
