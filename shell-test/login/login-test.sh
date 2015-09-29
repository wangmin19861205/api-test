#! /bin/sh




#curl -X POST  -c .cookie.file -d "accname=test2@126.com&password=1" http://localhost:4007/login


curl -X POST  -c .cookie.file -d "accname=13522228410&password=wangmin105" https://www.zrcaifu.com/login

curl  -L -b .cookie.file      https://www.zrcaifu.com/account/membership/checkin



#curl  -L -b .cookie.file http://localhost:4007/account/index


