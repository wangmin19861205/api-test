#! /bin/sh

set -e

LOANID=$1

if [ ! "${LOANID}" ];then
    echo "you need to input the right loan_id as first param"
    exit 0;
fi


echo "select 4 \n set AUTO-INVEST-LOAN:${LOANID} 111 PX 100" | redis-cli
