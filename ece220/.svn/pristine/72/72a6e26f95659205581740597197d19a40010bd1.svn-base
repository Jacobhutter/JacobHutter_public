#!/bin/bash

score=0
out=(0 a 0 c)
tests=("0 tests/dup_test1" "0 tests/dup_test2" 
       "1 tests/uni_test1" "1 tests/uni_test2")

for i in {0..3}; do
  res=$(./bin/dup_unique ${tests[i]})

  if [[ res -eq ${out[i]} ]]; then
    echo "Test" $((i + 1))": passed"
    ((score += 1))
  else
    echo "Test" $((i + 1))": failed"
  fi
done

echo "Score: "$score"/"${#out[@]}
