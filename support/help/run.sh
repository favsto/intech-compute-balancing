#!/bin/bash

COLOR_NONE='\033[0m'
COLOR_BYELLOW='\033[1;33m'
COLOR_RED='\033[0;31m'

if [ $# -eq 0 ]
  then
    echo -e "${COLOR_RED}Error. You must specify at least your Load Balancer external IP address.${COLOR_NONE}"
    echo "Syntax: ./run_test <LB_IP_ADDRESS> [ <REQUESTS> <PARALLELISM> ]"
    exit 1
fi

TEST_URL=$1
TEST_N=500
TEST_C=20

if [ $# -eq 3 ]
  then
    TEST_N=$2
    TEST_C=$3
fi

echo -e "${COLOR_BYELLOW}Running test: $TEST_N requests with parallelism $TEST_C towards http://$TEST_URL/${COLOR_NONE}"
ab -n $TEST_N -c $TEST_C -s 120 -v 1 http://$TEST_URL/