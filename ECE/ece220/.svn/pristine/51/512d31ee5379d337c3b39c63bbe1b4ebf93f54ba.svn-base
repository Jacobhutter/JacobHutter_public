#!/bin/bash

score=0
avg=(62 0 -2)
rev_arr=("62" "53,-52" "-65,-4,100,64,-21,-96,42,-17,62,-89")
tests=("tests/test1" "tests/test2" "tests/test3")

for i in {0..2}; do
  res=$(./bin/rev_avg ${tests[i]})

  asm_avg=$(echo "$res" | grep "ASM avg" | grep -wc -- "${avg[i]}")
  asm_arr=$(echo "$res" | grep "ASM array" | grep -c -- "${rev_arr[i]}")

  c_avg=$(echo "$res" | grep "C avg" | grep -wc -- "${avg[i]}")
  c_arr=$(echo "$res" | grep "C array" | grep -wc -- "${rev_arr[i]}")

  total=$(($asm_avg+$asm_arr+$c_avg+$c_arr))

  if [[ total -eq 4 ]]; then
    echo "Test $((i+1)): passed"
    ((score += 1))
  else
    echo "Test $((i+1)): failed"
  fi
done

echo "Score: $score/${#tests[@]}"
