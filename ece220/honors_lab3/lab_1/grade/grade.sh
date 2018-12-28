#!/bin/bash

score=0
usrt=('0007' '0001 FFFF' '000A 0006 FFF6 0006 0010 FFFE 0001')
srt=('0007' 'FFFF 0001' 'FFF6 FFFE 0001 0006 0006 000A 0010')
tests=(grade/test1 grade/test2 grade/test3)

for i in {0..2}; do
  org=$(lc3sim -s ${tests[i]} | grep -wc "^${usrt[i]}")
  new=$(lc3sim -s ${tests[i]} | grep -wc "^${srt[i]}")

  if [[ $org -ge 1 && $new -ge 1 ]]; then
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
