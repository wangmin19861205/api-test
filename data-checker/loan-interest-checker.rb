require 'sequel'

DB = Sequel.connect('mysql://demo:demo@localhost:3306/rui_site')

puts "begin to check loan interest"
#check the invest user_id
loan_id = ARGV[0]
if (! loan_id)
  puts "the loan_id is missing"
  exit 0
end


loan  = DB.fetch("select * from loans where id = #{loan_id}").first


# check loan rate

rate0 = loan[:annualized_rate0]
company_annualized_rate = loan[:company_annualized_rate]
plantform_subsidy_annualized_rate = loan[:plantform_subsidy_annualized_rate]

if (rate0 != company_annualized_rate + plantform_subsidy_annualized_rate)
  puts " the loan rate is wrong"
end



#interest = loan[:amount] *
