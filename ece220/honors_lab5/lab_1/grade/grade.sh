#!/bin/bash

score=0
out=(0 1 1 1)
tests=(grade/test1 grade/test2 grade/test3 grade/test4)

for i in {0..3}; do
  res=$(./bin/reg_verify ${tests[i]})

  if [[ $res -eq ${out[i]} ]]; then
    echo "Test $((i+1)): passed"
    ((score += 1))
  else
    echo "Test $((i+1)): failed"
  fi
done

echo "Score: $score/${#tests[@]}"

if [[ $score -eq ${#tests[@]} ]]; then
    echo "Passed lab!"
fi