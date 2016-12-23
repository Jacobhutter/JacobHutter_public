#!/bin/bash

score=0
out=(a 0 c 0)
tests=("0 grade/dup_test1" "0 grade/dup_test2" 
       "1 grade/uni_test1" "1 grade/uni_test2")

for i in {0..3}; do
  res=$(./bin/dup_unique ${tests[i]})

  if [[ res -eq ${out[i]} ]]; then
    echo "Test" $((i + 1))": passed"
    ((score += 1))
  else
    echo "Test" $((i + 1))": failed"
  fi
done

echo "Score: "$score"/"${#tests[@]}

if [[ $score -eq ${#tests[@]} ]]; then
    echo "Passed lab!"
fi
