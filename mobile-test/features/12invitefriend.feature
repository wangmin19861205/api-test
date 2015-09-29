Feature:验证邀请好友页面
  Scenario Outline:验证用户登录后进入邀请好友页面
    * 前提:用户登录账户<username>密码<password>
    * 进入邀请好友页面
    Examples:
      |username   |password|
      |13500000069|123456  |