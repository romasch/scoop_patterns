#!/bin/bash

COUNTS=(10, 50, 100, 200)
REPETITIONS=1

# Compile

rm -r ./EIFGENs/
ec -finalize -config performance_test.ecf
cd EIFGENs/performance_test/F_code/
finish_freezing
cd ../../..

# Run tests

for count in ${COUNTS[@]}; do
  for i in `seq $REPETITIONS`; do 
    echo $count | ./EIFGENs/performance_test/F_code/performance_test 
  done
done