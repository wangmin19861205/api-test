require '../libs/iframe/mysqldiy'
require '../libs/iframe/resultdiy'


@conn=MyDB.new("rui_site")
phone="13600000021"
while Resultdiy.new(@conn.sqlquery("select * from users where secure_phone ='#{phone}'")).result_to_list

end


