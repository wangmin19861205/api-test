@register
Feature: 注册页面
  Scenario Outline: 正常注册
    Given 删除数据库中已存在的用户名<username>
    Given 用户打开首页
    Given 进入我的账户页
    Given 从登录页进入注册页
    Given 验证注册页面title
    Given 输入用户名<username>密码<password>验证码<code>注册
    Examples:
    |username   |password|code|
    |13500000098| 123456 |1234|