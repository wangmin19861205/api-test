#! /bin/sh




curl -X POST  -c .cookie.file -d "accname=test2@126.com&password=1" http://localhost:4007/login

curl  -L -b .cookie.file http://localhost:4007/account/index


