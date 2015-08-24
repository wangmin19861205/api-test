require_relative "iframe/http_methods"
require_relative 'iframe/resultdiy'
require_relative "iframe/htmlclass"
require_relative 'iframe/mysqldiy'
include Httpmethod
require 'json'
require 'jq/extend'

data='{
    "data": {
        "loan_detail_json": [
            {
                "title": "项目风险评估",
                "data": [
                    {
                        "type": "rating",
                        "rating": [
                            {
                                "key": "企业等级",
                                "type": "star",
                                "star": "4",
                                "desc": "对融资人综合素质的评价"
                            },
                            {
                                "key": "管理团队素质",
                                "type": "score",
                                "score": "80",
                                "desc": "管理层对行业的理解力以及企业未来发展的预期"
                            },
                            {
                                "key": "偿债能力分析",
                                "type": "score",
                                "score": "80",
                                "desc": "资产负债情况及流动性分析"
                            },
                            {
                                "key": "盈利能力分析",
                                "type": "score",
                                "score": "80",
                                "desc": "评估企业资产收益情况"
                            },
                            {
                                "key": "融资能力",
                                "type": "score",
                                "score": "80",
                                "desc": "评估企业社会关系、银行等金融机构的合作状态"
                            },
                            {
                                "key": "担保方案分析",
                                "type": "score",
                                "score": "80",
                                "desc": "抵质押资产质量、流动性；保证人实力"
                            },
                            {
                                "key": "企业历史状况",
                                "type": "score",
                                "score": "80",
                                "desc": "企业历史经营表现"
                            }
                        ]
                    }
                ]
            }
{
                "title": "aaaaaa",
                "data": [
                    {
                        "type": "rating",
                        "rating": [
                            {
                                "key": "企业等级",
                                "type": "star",
                                "star": "4",
                                "desc": "对融资人综合素质的评价"
                            },
                            {
                                "key": "管理团队素质",
                                "type": "score",
                                "score": "80",
                                "desc": "管理层对行业的理解力以及企业未来发展的预期"
                            },
                            {
                                "key": "偿债能力分析",
                                "type": "score",
                                "score": "80",
                                "desc": "资产负债情况及流动性分析"
                            },
                            {
                                "key": "盈利能力分析",
                                "type": "score",
                                "score": "80",
                                "desc": "评估企业资产收益情况"
                            },
                            {
                                "key": "融资能力",
                                "type": "score",
                                "score": "80",
                                "desc": "评估企业社会关系、银行等金融机构的合作状态"
                            },
                            {
                                "key": "担保方案分析",
                                "type": "score",
                                "score": "80",
                                "desc": "抵质押资产质量、流动性；保证人实力"
                            },
                            {
                                "key": "企业历史状况",
                                "type": "score",
                                "score": "80",
                                "desc": "企业历史经营表现"
                            }
                        ]
                    }
                ]
            }
        ],
        "loan_pics_json": []
    }
}'

t0='[{
                                "key": "企业等级",
                                "type": "star",
                                "star": "4",
                                "desc": "对融资人综合素质的评价"
                            }]'


sql="select id, user_id , message_type , content, is_read ,title , create_time, icon_isok from user_messages where disable = 0 and user_id = '2898945' and create_time > date_sub(current_date(),INTERVAL 90 day) and (display_type = 'ALL' or display_type = 'MOBILE') order by case  message_type when 'SYSTEM' then 1  when 'INVEST' then 2 when 'REPAY' then 3 when 'CREDIT-ASSIGNMENT'  then 4 when 'FUNCTION-NOTIFICATION' then 5  when 'RECHARGE' then 6  when 'WITHDRAW' then 7 when 'ACTIVITY-NOTIFICATION' then 8 when 'MEMBER-SCORECARD-NOTIFICATION' then 9   end,create_time desc limit 10"
conn=MyDB.new "rui_site"
userid=(Resultdiy.new(conn.sqlquery("select id from users where secure_phone ='13500000098'")).result_to_list[0])[:id]

p userid