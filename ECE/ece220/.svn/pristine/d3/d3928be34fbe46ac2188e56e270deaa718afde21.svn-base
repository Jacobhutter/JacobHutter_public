#!/bin/bash

score=0
#out=(0004 000F 0001)
usrt=('0006' '000C 0001' '000A 0006 FFF6 0006 000E FFFE 0001')
srt=('0006' '0001 000C' 'FFF6 FFFE 0001 0006 0006 000A 000E')
tests=(tests/test1 tests/test2 tests/test3)

for i in {0..2}; do
  org=$(lc3sim -s ${tests[i]} | grep -wc "^${usrt[i]}")
  new=$(lc3sim -s ${tests[i]} | grep -wc "^${srt[i]}")

  if [[ org -ge 1 && new -ge 1 ]]; then
    echo "Test" $((i+1))": passed"
    ((score+=1))
  else
    echo "Test" $((i+1))": failed"
  fi
done

echo "Score: "$score"/"${#tests[@]}
