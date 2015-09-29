require_relative '../ruby-test/iframe/http_methods'
require 'jq/extend'
require 'json'

include Httpmethod

jsonstr='{
    "token": "rui-session:62447a39-3b0d-4830-9e9f-2a0d795e241d",
    "user": {
        "id": 2898945,
        "secure_phone": "13500000045",
        "mask_secure_phone": null,
        "mask_secure_email": null,
        "nickname": "13500000045",
        "register_time": "2015-08-04T18:02:57+08:00",
        "register_by": "phone",
        "is_active": true,
        "is_borrower": false,
        "role": "INVESTOR",
        "has_yeepay": false,
        "has_umbpay": true,
        "refer_user_id": 0,
        "server_type": "computer",
        "audit_time": "2015-08-04T18:03:39+08:00",
        "mask_idcard_name": "王*",
        "mask_idcard_number": null,
        "is_newuser": false
    },
    "error": null
}'
jsonstr=JSON.parse(jsonstr)


p jsonlist jsonstr,''