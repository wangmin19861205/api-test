@message
Feature:
  Background:
    Given 用户进入首页
    Given 点击我的账户按钮
  Scenario Outline:
    Given 输入用户名<username>密码<password>登录
    Then 验证消息数量:<number>

    Examples:
    |username   |password|number|
    |13500000045|123456  | 99+  |
    |13500000050|123456  |1     |



