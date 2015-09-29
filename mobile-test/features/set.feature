Feature:验证设置页面
  Scenario Outline:验证进入设置页面
    * 用户打开首页
    * 进入我的账户页
    * 验证登录页面title
    * 输入用户名<username>密码<password>登录,成功后返回首页
    * 进入设置页
    Examples:
      |username   |password|
      |13500000069|123456  |