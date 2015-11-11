require 'sequel'

DB = Sequel.connect('mysql://demo:demo@localhost:3306/rui_site')

puts "begin to check account data"

#check the account error first

data = DB.fetch("select accounts.* , users.id
                 from accounts
                 left join users on accounts.user_id = users.id
                 where users.id is null;").all


if (data.length > 0)
  puts "Error the following account do not have a user in the database. Need to fix this data"
  data.each do |row|
     puts "account.user_id = " +  row[:user_id].to_s
  end
  exit 0
end


data = DB["select users.* , accounts.user_id
          from users
          left join accounts on users.id = accounts.user_id
          where user_id is null;"].all


if (data.length > 0)
  puts "Error the following user do not have a account in the database. Need to fix this data."

  data.each do |row|
     puts "user.id = " +  row[:id].to_s
  end
  exit 0
end



# check the user journal data , available_money  this is not think about frozen so it is not right
data = DB["select *, available_money - ifnull(cal_available_money,0) as diff
           from (
               select accounts.* , temp.cal_available_money
               from accounts
               left join (
                    select user_id, sum(amount) as cal_available_money
                    from account_journals group by user_id) as temp
               on accounts.user_id = temp.user_id) as b
           where abs(available_money - ifnull(cal_available_money,0))> 0;"].all

if (data.length > 0)
  puts "Error the following account available_money. Need to fix this data."
  data.each do |row|
     puts "user.id = " +  row[:id].to_s
  end
  exit 0
end


## check the account_awards
data = DB["select * from (
                          select accounts.user_id , accounts.`available_reward`, accounts.`used_reward`,
                                 cal_available_rewards, cal_used_rewards,
                                 accounts.`available_reward` - ifnull(cal_available_rewards,0) as diff1 ,
                                 accounts.`used_reward`- ifnull(cal_used_rewards,0) as diff2
                           from accounts
                           left join (select user_id, sum(amount) as cal_available_rewards
                                      from account_rewards where status ='ACTIVE' group by `user_id`) as t1
                           on accounts.user_id = t1.user_id
                           left join (select user_id, sum(amount) as cal_used_rewards
                                      from account_rewards where status ='USED' group by `user_id`) as t2
                           on accounts.user_id = t1.user_id) as temp
                           where abs(temp.diff1)>0 or abs(temp.diff2)>0;"].all

if (data.length > 0)
  puts "Error the following account reward . Need to fix this data."
  data.each do |row|
     puts "user.id = " +  row[:user_id].to_s
  end
  exit 0
end
