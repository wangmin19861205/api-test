require 'sequel'

DB = Sequel.connect('mysql://demo:demo@localhost:3306/rui_site')

puts "begin to check receive interest"

#check the invest user_id




receive_id = ARGV[0]



if (! receive_id)
  puts "the receive_id is missing"
  exit 0
end




def split_interest(p , rate, rate1, rate2, rate3)
  amount = p * rate
  amount = amount.round(2);
  if (rate3 > 0 and rate2 > 0)
    amount1 = p * rate1;
    amount1 = amount1.round(2);
    amount2 = p * rate2;
    amount2 = amount2.round(2);
    amount3 = amount - amount1 - amount2;
  elsif (rate2>0)
    amount1 = p * rate1;
    amount1 = amount1.round(2);
    amount2 = amount - amount1;
    amount3 = 0;
  elsif (rate3 > 0)
    amount1 = p * rate1;
    amount1 = amount1.round(2);
    amount3 = amount - amount1;
    amount2 = 0;
  else
    amount1 = amount;
    amount2 = 0;
    amount3 =0;
  end
  [amount1, amount2, amount3]
end


receive= DB.fetch("select * from invest_receives where id = #{receive_id}").first

loan_id = receive[:loan_id]
invest_id = receive[:invest_id]
loan  = DB.fetch("select *  from loans where id = #{loan_id}").first
invest = DB.fetch("select * from invests where id = #{invest_id}").first


invest_amount = invest[:amount]

days = receive[:days]


##check rate



if (BigDecimal.new( loan[:company_annualized_rate] / 360).round(8) != receive[:company_daily_rate])
  puts "the company daily rate is wrong"
  exit 1
end


if (BigDecimal.new( loan[:plantform_subsidy_annualized_rate] / 360).round(8) != receive[:plantform_subsidy_daily_rate])
  puts "the plantfrom subsidy daily rate"
  exit 1
end




if (BigDecimal.new( loan[:annualized_rate1] / 360).round(8) != receive[:plantform_activity_daily_rate])
  puts "the plantform_activity_daily_rate"
end





if (receive[:amount_interest] != receive[:amount_interest1] + receive[:amount_interest0])
  puts "the interest0 or interest1 is wrong"
  exit 1
end


if (receive[:amount_interest0] != receive[:company_interest] + receive[:plantform_subsidy_interest] +  receive[:plantform_activity_interest])
  puts "the split interst is wrong   " + receive[:amount_interest0].to_f.to_s + "  " + receive[:company_interest].to_f.to_s + "  " +  receive[:plantform_subsidy_interest].to_f.to_s +  "  " + receive[:plantform_activity_interest].to_f.to_s
  exit 1
end




cal_interest0 = loan[:amount] * receive[:days] * BigDecimal.new(loan[:annualized_rate] / 360).round(8)
cal_interest0 = cal_interest0.round(2)

# check interest 0
if (cal_interest0 != receive[:amount_interest0])
  puts "the interest0 is wrong   cal_interet " + cal_interest0.to_f.to_s + " recevie amount_interet0 " +  receive[:amount_interest0].to_f.to_s
  exit 1
end


cal_company_interest, cal_plantform_subside_interest, cal_plantform_activity_interest = split_interest(invest_amount,
                                                                                                   receive[:daily_rate0] * days,
                                                                                                   receive[:company_daily_rate] * days,
                                                                                                   receive[:plantform_subsidy_daily_rate] * days,
                                                                                                   receive[:plantform_activity_daily_rate] * days)

if (cal_company_interest != receive[:company_interest])
  puts " the company interest is wrong " +  cal_company_interest.to_f.to_s + "  " + receive[:company_interest].to_f.to_s
  exit 1
end



if (cal_plantform_subside_interest != receive[:plantform_subsidy_interest])
  puts " the subside interest is wrong " +  cal_plantform_subside_interest.to_f.to_s + "  " + receive[:plantform_subsidy_interest].to_f.to_s
  exit 1
end



if (cal_plantform_activity_interest != receive[:plantform_activity_interest])
  puts " the activity interest is wrong " +  cal_plantform_activity_interest.to_f.to_s + "  " + receive[:plantform_activity_interest].to_f.to_s
  exit 1
end





exit 0
