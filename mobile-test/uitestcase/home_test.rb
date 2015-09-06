require_relative '../pageobject/home_page'
require_relative '../pageobject/pageobject'
require_relative '../iframe/mobilediy'
require 'test/unit'

class HomeTest<Test::Unit::TestCase
  def setup
    @driver=Mobile.new.open
  end

  def teardown
    @driver.x
  end

  def test_right
    @mobile=Home.new(@driver)
    @mobile.in_home
    #assert_equal("中瑞财富1",@mobile.in_home,"不一致")
    puts @mobile.loancard
  end
end


Test::Unit::AutoRunner.run


