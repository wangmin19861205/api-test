@message
Feature:首页-消息数量
  Scenario Outline: 验证登录后的用户消息数，[正常 and 99+]
    Given 更新数据库的全部消息为未读未删除
    Given 用户打开首页
    Given 进入我的账户页
    Given 输入用户名<username>密码<password>登录,成功后返回首页
    Then 验证消息数量:<number>
    Examples:
    |username   |password|number|
    |13500000069|123456  |99+   |
    |13500000070|123456  |16    |







