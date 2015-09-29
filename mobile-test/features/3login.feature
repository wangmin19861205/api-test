Feature: 登录页面
  Scenario Outline: 从我的账户页登录
    Given 用户打开首页
    Given 进入我的账户页
    Given 输入用户名<username>密码<password>登录,成功后返回首页
    Examples:
      |username   |password |
      |13500000069|123456   |