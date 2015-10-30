require 'watir-webdriver'
require 'selenium/webdriver'
require 'time'
=begin
driver=Selenium::WebDriver.for :chrome
driver.get "http://localhost:3001/"
driver.find_element(:id=>"input-username").send_key("admin")
driver.find_element(:id=>"input-password").send_key("000000")
driver.find_element(:xpath=>"//*[@class='btn btn-default']").click
driver.get "http://localhost:3001//#/loanproposal"
sleep 2
driver.find_element(:xpath=>"//*[@class='btn btn-primary ng-scope ng-isolate-scope']").click
sleep 2
driver.find_element(:id=>"uploader-logo").send_keys("/Users/wangmin/123.jpg")
driver.find_element()
=end

def creatloan (loan_type,is_dynamic_days,amount=50000,annualized_rate0=10,annualized_rate1=0,payment_type,guarantee_category,guarantee_type)
  #driver=Watir::Browser.new :chrome,:profile => 'default'
  #driver=Watir::Browser.new :firefox,:profile => "profile"
  driver=Watir::Browser.new :firefox
  #driver.driver.manage.timeouts.implicit_wait=30
  driver.window.maximize
  driver.goto "http://site19.test.zrcaifu.com"
  driver.text_field(:id=>"input-username").set("admin")
  driver.text_field(:id=>"input-password").set("000000")
  driver.button(:text=>"登录").when_present.click
  driver.a(:text=>"调研项目").when_present.click
  driver.a(:text=>"创建调研项目").when_present.click
  loan_no=Time.new.localtime().strftime("%m%d%H%M%S")
  driver.select_list(:name=>"loan_type").when_present.select(loan_type.to_s)  #等待存在
  #driver.select_list(:name=>"loan_type").wait_until_present   #等待出现,无blok
  #driver.select_list(:name=>"loan_type").wait_while_present  #等待消失,无blok
  driver.select_list(:id=>"category").when_present.select("无".to_s)
  driver.checkbox(:xpath=>"//*[@id=\"rui\"]/body/div[1]/form/div[1]/div[3]/div/input").when_present.set(eval(is_dynamic_days))   #取消clear
  driver.text_field(:name=>"loan_no").when_present.set(loan_no.to_s)
  driver.text_field(:name=>"title").when_present.set((loan_no+"项目(C2-1507十期)").to_s)
  driver.file_field(:id=>"uploader-logo").when_present.value=("/Users/wangmin/123.jpg")
  driver.div(:class=>"modal-content").when_present.click
  #ele=driver.lable(:class=>"modal-content")
  #ele.exists?  #是否存在
  #ele.set?    #是否选中
  driver.button(:xpath=>"//*[@class='btn btn-success btn-xs']").when_present.click
  driver.a(:xpath=>"//*[@id=\"rui\"]/body/div[1]/form/div[1]/div[8]/a").when_present.click
  driver.a(:xpath=>'//*[@id="company-list-dialog"]/div/div').when_present
  #driver.execute_script("arguments[0].click();",driver.a(:xpath=>"//*[@id=\"company-list-dialog\"]/div[2]/div/div[2]/table/tbody[1]/tr[1]/td[5]/a"))
  driver.a(:xpath=> '//*[@id="company-list-dialog"]/div/div/div[2]/table/tbody[1]/tr[1]/td[5]/a').when_present.fire_event :click

  if loan_type == "VIP专享项目"
    driver.text_field(:name=>"amount").when_present.set((1000000+amount.to_f).to_s)
  else
    driver.text_field(:name=>"amount").when_present.set(amount)
  end
  days_of_loan=[30,60,90].sample
  driver.text_field(:name=>"days_of_loan").when_present.set(days_of_loan)
  if is_dynamic_days == "true"
    driver.text_fields(:name=>"days_of_loan").last.set("150")
  end
  driver.text_field(:name=>"annualized_rate").when_present.set(annualized_rate0)
  driver.text_fields(:name=>"annualized_rate").last.set(annualized_rate1)
  if annualized_rate1 == "0"
    driver.text_field(:xpath=>"//*[@id=\"rui\"]/body/div[1]/form/div[1]/div[14]/div/input").when_present.clear
  else
    driver.text_field(:xpath=>"//*[@id=\"rui\"]/body/div[1]/form/div[1]/div[14]/div/input").when_present.set("项目额外加息补助。。。。。".to_s)
  end
  driver.text_field(:name=>"loan_use_of_funds").when_present.set("资金用途。。。。。。")
  driver.select_list(:xpath=>"//*[@id=\"rui\"]/body/div[1]/form/div[1]/div[16]/div/select").when_present.select(payment_type.to_s)
  driver.text_field(:name=>"loan_repaying_source").when_present.set("还款来源.................还款来源".to_s)
  driver.select_list(:name=>"guarantee_category").when_present.select(guarantee_category.to_s)
  driver.select_list(:xpath=>"//*[@id=\"rui\"]/body/div[1]/form/div[1]/div[19]/div/select").when_present.select(guarantee_type.to_s)
  driver.text_field(:id=>"memo_id").when_present.set("备注。。。。。。。。".to_s)
  driver.text_field(:name=>"fee_guarantee").when_present.set("5000".to_s)
  driver.text_field(:name=>"fee_platform").when_present.set("111".to_s)
  driver.text_field(:id=>"laon_desc").when_present.set("项目描述.........................项目描述".to_s)
  #driver.select_list(:xpath=>'//*[@id="rui"]/body/div[1]/form/div[1]/div[25]/div/select').when_present.select("正常项目".to_s)
  driver.radio(:xpath=>'//*[@id="rui"]/body/div[1]/form/div[7]/div/div/input[4]').set
  driver.button(:id=>"loanproposal-submit").when_present.click
  #发布
  driver.span(:xpath=>"//*[@id=\"rui\"]/body/div[1]/table/tbody[1]/tr[1]/td[11]/a[4]/span").when_present.click
  driver.button(:xpath=>'//*[@id="myModal"]/div/div/div[3]/button[2]').when_present.click
  driver.quit
end


a=["新手项目","推荐项目","VIP专享项目"]
b=["到期还本付息","按日计息，按月付息，到期还本"]
c=["保证担保","回购担保","第三方连带责任担保","第三方担保","抵押担保"]
d=["保本保息","保本"]
e=["true","false"]


typelists=[]
for i in a
  for j in b
    for k in c
      for l in d
        for m in e
          typelists.push([i,m,j,k,l])
        end
      end
    end
  end
end


for i in typelists
  creatloan *i
end