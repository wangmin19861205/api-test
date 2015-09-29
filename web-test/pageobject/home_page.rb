require_relative '../pageobject/pageobject'
require_relative '../pageelement/1home_page'



class Homepage < PageObject

  def open_site
    @driver.goto ENV["site_url"]
  end

  def to_login
    @driver.a(Home_login_button).when_present.click
  end

  def to_register
    @driver.a(Home_register_button).when_present.click
  end

  def switch_home_tab
    @driver.as(Home_tabs_button)[0].when_present.click
  end

  def switch_allrporject_tab
    @driver.as(Home_tabs_button)[1].when_present.click
  end

  def switch_myaccount_tab
    @driver.as(Home_tabs_button)[2].when_present.click
  end

  def switch_safe_tab
    @driver.as(Home_tabs_button)[3].when_present.click
  end

  def to_investdetail no=0
    if no != 0
      no=no.to_i - 1
      @driver.buttons(Home_project_ccardbutton)[no].when_present.fire_event :click
    elsif no == 0
      @driver.buttons(Home_project_ccardbutton).map do |ele|
        if ele.text == '立即投资'
          ele.when_present.fire_event :click
          break
        end
      end
    end
  end

  def loancard
    rateitem=@driver.divs(Home_project_rate).map do |ele|
      ele.text
    end
    daysitem=@driver.divs(Home_project_days).map do |ele|
      ele.text
    end
    amountitem=@driver.divs(Home_project_amount).map do |ele|
      ele.text
    end
    unamountitem=@driver.divs(Home_project_unamount).map do |ele|
      ele.text
    end
    buttontext=@driver.divs(Home_project_ccardbutton).map do |ele|
      ele.text
    end
    return rateitem,daysitem,amountitem,unamountitem,buttontext
  end

  def newloancard

  end

  def viploancard

  end

  def welcome_text
    @driver.a(Home_welcome_text).when_present.text
  end



end
