require_relative '../../pageobject/register_page'


Given /用户注册/ do
  webapp=Registerpage.new(@driver)
  webapp.register
end



