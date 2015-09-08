require_relative "iframe/http_methods"
require_relative 'iframe/resultdiy'
require_relative "iframe/htmlclass"
require_relative 'iframe/mysqldiy'
require_relative 'iframe/resultdiy'
include Httpmethod
require 'json'
require 'jq/extend'

=begin
class Myclass
    def mymethod
        @a=1
    end
end


obj=Myclass.new
obj.mymethod
p obj.instance_variables
p obj.methods
p obj.methods.grep(/^my/)
=end

jsondata=[{"id"=>700000755, "title"=>"8煤炭供应链系列-鑫达公司应收账款（XD1507二期）", "format_title"=>"8煤炭供...（XD1507二期）", "annualized_rate"=>0.115, "annualized_rate0"=>0.115, "annualized_rate1"=>0, "amount"=>200000, "is_dynamic_days"=>true, "days_of_loan"=>1, "init_days_of_loan"=>1, "max_days_of_loan"=>3, "date_of_value"=>"2015-08-25", "date_of_maturity"=>"2015-08-26", "init_date_of_maturity"=>"2015-08-26", "max_date_of_maturity"=>"2015-08-28", "loan_type"=>"RECOMMEND_PROJECT", "loan_period"=>"SHORT", "min_invest_amount"=>1000, "guarantee_category"=>"第三方连带责任担保", "payment_type"=>"到期还本付息", "invest_countdown_ms"=>0, "finish_percent"=>100, "uninvest_amount"=>0, "status"=>"REPAY", "unfinished_invest_count"=>0, "loanproposal_id"=>5000838, "loan_tag"=>nil, "special_user_id"=>nil}, {"id"=>700000754, "title"=>"8煤炭供应链系列-鑫达公司应收账款（XD1507二期）", "format_title"=>"8煤炭供...（XD1507二期）", "annualized_rate"=>0.115, "annualized_rate0"=>0.115, "annualized_rate1"=>0, "amount"=>200000, "is_dynamic_days"=>true, "days_of_loan"=>3, "init_days_of_loan"=>3, "max_days_of_loan"=>5, "date_of_value"=>"2015-08-21", "date_of_maturity"=>"2015-08-24", "init_date_of_maturity"=>"2015-08-24", "max_date_of_maturity"=>"2015-08-26", "loan_type"=>"RECOMMEND_PROJECT", "loan_period"=>"SHORT", "min_invest_amount"=>1000, "guarantee_category"=>"第三方连带责任担保", "payment_type"=>"到期还本付息", "invest_countdown_ms"=>0, "finish_percent"=>100, "uninvest_amount"=>0, "status"=>"FINISH", "unfinished_invest_count"=>0, "loanproposal_id"=>5000837, "loan_tag"=>nil, "special_user_id"=>nil}, {"id"=>700000744, "title"=>"8煤炭供应链系列-鑫达公司应收账款（XD1507二期）", "format_title"=>"8煤炭供...（XD1507二期）", "annualized_rate"=>0.11, "annualized_rate0"=>0.105, "annualized_rate1"=>0.005, "amount"=>1002001, "is_dynamic_days"=>false, "days_of_loan"=>30, "init_days_of_loan"=>30, "max_days_of_loan"=>30, "date_of_value"=>"2015-08-05", "date_of_maturity"=>"2015-09-04", "init_date_of_maturity"=>"2015-09-04", "max_date_of_maturity"=>"2015-09-04", "loan_type"=>"RECOMMEND_PROJECT", "loan_period"=>"SHORT", "min_invest_amount"=>1000, "guarantee_category"=>"第三方连带责任担保", "payment_type"=>"到期还本付息", "invest_countdown_ms"=>0, "finish_percent"=>0, "uninvest_amount"=>1002001, "status"=>"REPAY", "unfinished_invest_count"=>0, "loanproposal_id"=>5000827, "loan_tag"=>nil, "special_user_id"=>nil}, {"id"=>700000743, "title"=>"8煤炭供应链系列-鑫达公司应收账款（XD1507二期）", "format_title"=>"8煤炭供...（XD1507二期）", "annualized_rate"=>0.11, "annualized_rate0"=>0.105, "annualized_rate1"=>0.005, "amount"=>1002001, "is_dynamic_days"=>false, "days_of_loan"=>22, "init_days_of_loan"=>22, "max_days_of_loan"=>22, "date_of_value"=>"2015-08-05", "date_of_maturity"=>"2015-08-27", "init_date_of_maturity"=>"2015-08-27", "max_date_of_maturity"=>"2015-08-27", "loan_type"=>"RECOMMEND_PROJECT", "loan_period"=>"SHORT", "min_invest_amount"=>1000, "guarantee_category"=>"第三方连带责任担保", "payment_type"=>"到期还本付息", "invest_countdown_ms"=>0, "finish_percent"=>1, "uninvest_amount"=>1001001, "status"=>"REPAY", "unfinished_invest_count"=>0, "loanproposal_id"=>5000826, "loan_tag"=>nil, "special_user_id"=>nil}, {"id"=>700000728, "title"=>"1煤炭供应链系列-鑫达公司应收账款（XD1507二期）", "format_title"=>"1煤炭供...（XD1507二期）", "annualized_rate"=>0.11, "annualized_rate0"=>0.1, "annualized_rate1"=>0.01, "amount"=>50000, "is_dynamic_days"=>false, "days_of_loan"=>22, "init_days_of_loan"=>22, "max_days_of_loan"=>22, "date_of_value"=>"2015-08-05", "date_of_maturity"=>"2015-08-27", "init_date_of_maturity"=>"2015-08-27", "max_date_of_maturity"=>"2015-08-27", "loan_type"=>"RECOMMEND_PROJECT", "loan_period"=>"SHORT", "min_invest_amount"=>1000, "guarantee_category"=>"保证担保", "payment_type"=>"到期还本付息", "invest_countdown_ms"=>0, "finish_percent"=>0, "uninvest_amount"=>50000, "status"=>"FINISH", "unfinished_invest_count"=>0, "loanproposal_id"=>5000811, "loan_tag"=>nil, "special_user_id"=>nil}]
sqldata=Resultdiy.new((MyDB.new("rui_site").sqlquery("select * from loans where disabled = 0 and special_loan is null and special_user_id is null and loan_type = 'RECOMMEND_PROJECT' and loan_period = 'SHORT' order by case status when 'INVEST' then 1 when 'REPAY' then 2 when 'FINISH' then 3 end asc ,case status when 'INVEST' then invest_open_time end asc , case when status <> 'INVEST' then invest_open_time end desc limit 10 offset 0"))).result_to_list

p asskey jsondata,sqldata,['id','amount']



def asskey jsondata,sqldata,diykey
    if jsondata.class == Hash
        jsondata=[].push(jsondata)
    elsif jsondata.class == Array
    else
        raise "既不是hash,也不是array"
    end
    if asslength jsondata,sqldata and jsondata.empty?
        return TRUE,"json与sql的数据均为空"
    elsif  asslength jsondata,sqldata
        str=''
        abc=0
        while abc<jsondata.length
            diykey.each do |key|
                assvalue1=jsondata[abc][key]
                assvalue2=(sqldata[abc][key.to_sym].class == BigDecimal ? sqldata[abc][key.to_sym].to_f : sqldata[abc][key.to_sym])
                if assvalue1 == assvalue2
                    str+="第#{abc}组KEY对比通过:#{key}--#{assvalue1},#{assvalue2}\n"
                else
                    return FALSE,str+="第#{abc}组KEY对比失败:#{key}--#{assvalue1},#{assvalue2}\n"
                end
            end
            abc+=1
        end
        return TRUE,str
    else
        return FALSE,"长度不一致"
    end
end
