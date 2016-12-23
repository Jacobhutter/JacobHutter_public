#!/bin/bash

score=0
out=("" "cta atc tca" "gdo dog ogd gdo")
tests=(tests/test1 tests/test2 tests/test3)

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
