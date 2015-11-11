require 'sequel'
DB = Sequel.connect('mysql://demo:demo@192.168.1.14:3306/rui_site')

data = DB.fetch("select idcard_number from users where idcard_number is not null and idcard_number != '';").all


regex = "/^[1-9]\d{7}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}$|^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|X)$/"



data.each do |row|

  if(! row[:idcard_number] =~ regex)
    puts "fail idcard " + row[:idcard_number]
  else
    puts "success " + row[:idcard_number]
  end
end
