#!/bin/bash

score=0
out=(1 2 504)
tests=(1 2 11)

end=$((${#tests[@]}-1))
for i in $(seq 0 1 $end); do
  res=$(./bin/count_steps ${tests[i]})

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
