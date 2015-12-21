require 'sequel'

DB = Sequel.connect('mysql://demo:demo@localhost:3306/rui_site')

puts "begin to check loan interest"
#check the invest user_id
repay_id = ARGV[0]
if (! repay_id)
  puts "the repay_id is missing"
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




repay  = DB.fetch("select * from loan_repays where id = #{repay_id}").first
repay_id = repay[:id]
loan_id = repay[:loan_id]

loan = DB.fetch("select * from loans where id = #{loan_id}").first



result = DB.fetch("select sum(company_interest) as sum_company_interest , sum(plantform_subsidy_interest) as sum_plantform_subsidy_interest, sum(plantform_activity_interest) as sum_plantform_activity_interest from invest_receives where loan_repay_id = #{repay_id}")
