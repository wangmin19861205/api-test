Feature:验证提现页面
  Scenario Outline:验证用户登录后进入提现页面
    * 前提:用户登录账户<username>密码<password>
    * 进入提现页面
    Examples:
      |username   |password|
      |13500000069|123456  |