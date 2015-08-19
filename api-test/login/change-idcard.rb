require 'sequel'
DB = Sequel.connect('mysql://demo:demo@localhost:3306/rui_site')

data = DB[:users].update(:idcard_number=>:id , :password=>"$2a$10$.YmjJG2amhUcAmwbIkS2sOe7mzYMcJFrsfhsKV4XLaBlHUDLb1MLC", :nickname=>:secure_phone)
