#!/bin/bash

score=0
out=(0000000000000000 1111111111111111 1110110010101000)
grade=(grade/test1 grade/test2 grade/test3)

for i in {0..2}; do
  res=$(lc3sim -s ${grade[i]} | grep -c ${out[i]})

  if [[ res -eq 1 ]]; then
    echo "Test" $((i+1))": passed"
    ((score+=1))
  else
    echo "Test" $((i+1))": failed"
  fi
done

echo "Score: "$score"/"${#grade[@]}

if [[ $score -eq ${#grade[@]} ]]; then
  echo "Passed lab!"
fi

