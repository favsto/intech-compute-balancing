#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "You must specify at least your Load Balancer external IP address."
    echo "Syntax: ./run_test <LB_IP_ADDRESS> [ <REQUESTS> <PARALLELISM> ]"
    exit 1
fi

TEST_URL=$1
TEST_N=500
TEST_C=15

if [ $# -eq 3 ]
  then
    TEST_N=$2
    TEST_C=$3
fi

COLOR_YELLOW='\033[0;33m'
COLOR_NONE='\033[0m' # No Color

echo -e "${COLOR_YELLOW}Running test: $TEST_N requests with parallelism $TEST_C towards http://$TEST_URL/${COLOR_NONE}"
ab -n $TEST_N -c $TEST_C -s 60 -v 1 http://$TEST_URL/