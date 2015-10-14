require '../libs/iframe/mysqldiy'


conn=MyDB.new("rui_site")
list=["700000891","700000890","700000889"]
a=0
str=''
while a<list.length
  list.each do |i|
    if a+1 == list.length
      str=str+i
    else
      str=str+i+','
    end
    a=a+1
  end
  end
str="("+str+")"
p str


conn.update("update loans set status='repay' where id in #{str}")