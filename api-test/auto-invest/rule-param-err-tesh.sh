#! /bin/sh

curl -X POST  -c .cookie.file -d "accname=test2@126.com&password=1" http://localhost:4007/login


echo ""

curl -X POST -L -b .cookie.file -d "invest_amount_lowerbound=64.55&invest_amount_upperbound=55.77&annualized_rate_lowerbound=8.01234&annualized_rate_upperbound=12.1345&reserve_account_amount=321.56&loan_days=1&repay_type=1&guarantee_type=2&use_reward_type=1"   http://localhost:4007/account/auto-invest-rule/create-or-update


echo ""






curl -X POST -L -b .cookie.file -d "invest_amount_lowerbound=44.55&invest_amount_upperbound=55.77&annualized_rate_lowerbound=18.01234&annualized_rate_upperbound=12.1345&reserve_account_amount=321.56&loan_days=1&repay_type=1&guarantee_type=2&use_reward_type=1"   http://localhost:4007/account/auto-invest-rule/create-or-update


echo ""





curl -X POST -L -b .cookie.file -d "invest_amount_lowerbound=44.55&invest_amount_upperbound=55.77&annualized_rate_lowerbound=18.01234&annualized_rate_upperbound=-12.1345&reserve_account_amount=321.56&loan_days=1&repay_type=1&guarantee_type=2&use_reward_type=1"   http://localhost:4007/account/auto-invest-rule/create-or-update


echo "params empty"





curl -X POST -L -b .cookie.file -d "invest_amount_lowerbound=44.55&invest_amount_upperbound=55.77&annualized_rate_lowerbound=8.01234&annualized_rate_upperbound=12.1345&reserve_account_amount=321.56&loan_days=1&repay_type=1&guarantee_type=2&use_reward_type=aa"   http://localhost:4007/account/auto-invest-rule/create-or-update


echo ""
