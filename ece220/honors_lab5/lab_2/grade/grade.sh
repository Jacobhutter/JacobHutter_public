#!/bin/bash

score=0
out=("" "tac cat" "gdo dog ogd gdo dog")
tests=(grade/test1 grade/test2 grade/test3)

end=$((${#tests[@]}-1))
for i in $(seq 0 1 $end); do
  res=$(./bin/permutation ${tests[i]})

  if [[ "$res" == "${out[i]}"* ]]; then
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
