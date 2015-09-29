Feature:验证我的奖励页面
  Scenario Outline:验证用户登录后进入我的奖励页面
    * 前提:用户登录账户<username>密码<password>
    * 进入我的奖励页面
    Examples:
      |username   |password|
      |13500000069|123456  |