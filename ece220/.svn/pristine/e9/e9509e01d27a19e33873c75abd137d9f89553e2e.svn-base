#!/bin/bash

score=0
out=(0004 0031 0001)
tests=(grade/test1 grade/test2 grade/test3)

for i in {0..2}; do
  res=$(lc3sim -s ${tests[i]} | grep -wc ${out[i]})

  if [[ $res -eq 1 ]]; then
    echo "Test" $((i+1))": passed"
    ((score+=1))
  else
    echo "Test" $((i+1))": failed"
  fi
done

echo "Score: "$score"/"${#tests[@]}

if [[ $score -eq ${#tests[@]} ]]; then
  echo "Passed lab!"
fi
