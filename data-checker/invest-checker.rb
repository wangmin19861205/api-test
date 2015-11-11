require 'sequel'

DB = Sequel.connect('mysql://demo:demo@localhost:3306/rui_site')






puts "begin to check invest data"

#check the invest user_id

data = DB["select  * from (
                      select invests.id, invests.user_id, invests.`borrower_user_id` , u1.id as u1_id , u2.id as u2_id
                      from invests
                      left join users as u1 on invests.user_id = u1.id
                      left join users as u2 on invests.borrower_user_id = u2.id)
           as temp where u1_id is null or u2_id is null;"].all

if (data.length > 0)
  puts "Error the following invest do not have a correct user. Need to fix this data"
  data.each do |row|
     puts "invest.id = " +  row[:id].to_s
  end
  exit 0
end



# check the loan data
data = DB["select * from loans where annualized_rate != annualized_rate0 + annualized_rate1;"].all


if (data.length > 0)
  puts "Error the following loan annualized_rate . Need to fix this data."

  data.each do |row|
     puts "loan.id = " +  row[:id].to_s
  end
  exit 0
end






# check the loan daily_rate
data = DB["select loans.id , annualized_rate, annualized_rate / 360, `daily_rate` ,
                  abs(annualized_rate / 360 -`daily_rate`) as diff
           from loans where abs(round(annualized_rate / 360, 8) -`daily_rate`) >0;"].all
if (data.length > 0)
  puts "Error the following account daily_rate is error. Need to fix this data."
  data.each do |row|
     puts "loan.id = " +  row[:id].to_s
  end
  exit 0
end


## check the loan date
data = DB["select *  from (
                         select loans.id, init_days_of_loan , max_days_of_loan, date_of_value, date_of_maturity,
                                init_date_of_maturity, max_date_of_maturity, invest_open_time ,
                                date_add(invest_open_time, interval init_days_of_loan  day) as cal_date_of_maturity
                         from loans
                         where is_dynamic_days =0
                            and (abs(init_days_of_loan - max_days_of_loan)> 0
                                 or (`init_date_of_maturity` != `max_date_of_maturity`)
                                 or (`date_of_maturity` != `init_date_of_maturity`))
                          ) as temp where date_of_maturity != date(cal_date_of_maturity);"].all

if (data.length > 0)
  puts "Error the following loan date_of_value, date_of_maturity  . Need to fix this data."
  data.each do |row|
     puts "loan.id = " +  row[:id].to_s
  end
  exit 0
end



## check the loan date
data = DB["select * from (
                         select loans.id, init_days_of_loan , max_days_of_loan, date_of_value, date_of_maturity,
                                init_date_of_maturity, max_date_of_maturity, invest_open_time ,
                                date_add(date_of_value, interval init_days_of_loan day) as cal_init_date_of_maturity,
                                date_add(date_of_value, interval max_days_of_loan  day) as cal_max_date_of_maturity
                         from loans
                         where is_dynamic_days =1 ) as temp
          where
              init_date_of_maturity != cal_init_date_of_maturity
              or cal_max_date_of_maturity != cal_max_date_of_maturity
              or init_days_of_loan - max_days_of_loan > 0  or `init_date_of_maturity` > max_date_of_maturity;;"].all
if (data.length > 0)
  puts "Error the following loan date_of_value, date_of_maturity  . Need to fix this data."
  data.each do |row|
     puts "loan.id = " +  row[:id].to_s
  end
  exit 0
end


#check loan amount
data = DB["select * from loans where amount!= invest_paid + uninvest_amount;"].all
if (data.length > 0)
  puts "Error the following loan amount  . Need to fix this data."
  data.each do |row|
     puts "loan.id = " +  row[:id].to_s
  end
  exit 0
end



#check invest paid amount

data = DB["select * from invests where with_money =1 and amount!= amount_paid + amount_reward;"].all
if (data.length > 0)
  puts "Error the following invest amount  . Need to fix this data."
  data.each do |row|
     puts "invest.id = " +  row[:id].to_s
  end
  exit 0
end




data = DB["select * from invests, loans where invests.loan_id = loans.id and  with_money =1  and invests.`annualized_rate0` != loans.`annualized_rate` "].all
if (data.length > 0)
  puts "Error the following invest annual_rate  . Need to fix this data."
  data.each do |row|
     puts "invest.id = " +  row[:id].to_s
  end
  exit 0
end






data = DB["select * from invests , `account_interest_coupons`
           where invests.id = `account_interest_coupons`.consume_by_invest_id
               and (invests.`annualized_rate1` != account_interest_coupons.`annualized_rate`
                    or invests.`daily_rate1` != account_interest_coupons.`daily_rate`) ;"].all
if (data.length > 0)
  puts "Error the following invest annual_rate  . Need to fix this data."
  data.each do |row|
     puts "invest.id = " +  row[:id].to_s
  end
  exit 0
end


data = DB["select invests.id, invests.loan_id, invests.`daily_rate0`, loans.`daily_rate`
          from invests, loans where invests.loan_id = loans.id  and  invests.`daily_rate0` !=loans.`daily_rate`"].all
if (data.length > 0)
  puts "Error the following invest daily_rate  . Need to fix this data."
  data.each do |row|
     puts "invest.id = " +  row[:id].to_s
  end
  exit 0
end
