require_relative 'iframe/http_methods'
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

t0=JSON.parse(t0, :symbolize_names=>true)
d0=JSON.parse(data, :symbolize_names=>true)
puts r0=d0[:data][:loan_detail_json][0][:data][0][:rating]
puts [:data, :loan_detail_json, 0, :data, 0,:rating]