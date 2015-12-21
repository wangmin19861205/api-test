require 'sequel'

DB = Sequel.connect('mysql://demo:demo@localhost:3306/rui_site_online')

puts "begin to check receive interest"

#check the invest user_id




user_id = ARGV[0]



if (! user_id)
  puts "the receive_id is missing"
  exit 0
end


amount  =0


journals = DB[:account_journals].where(:user_id=> user_id).each_server{
  |ds|  #ds.update(:source=> ds[:id].to_s)
  ds.all.each do |row|
    amount += row[:amount]
    ds.where(:id=>row[:id]).update(:source=>amount.to_f.to_s)
  end
}
