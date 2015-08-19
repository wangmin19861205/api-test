#! /bin/sh




curl -X POST  -c .cookie.file -d "accname=test2@126.com&password=1" http://localhost:4007/login

curl -X POST -L -b .cookie.file -d "invest_amount_lowerbound=34.55&invest_amount_upperbound=55.77&annualized_rate_lowerbound=8.01&annualized_rate_upperbound=12.1&loan_days=1&repay_type=1&guarantee_type=2&use_reward_type=1"   http://localhost:4007/account/auto-invest-rule/create-or-update
