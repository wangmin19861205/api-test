@message

Feature:验证首页消息数量
  Scenario Outline:
    Given 更新数据库的全部消息为未读未删除
    Given 用户进入首页
    Given 进入我的账户页
    Given 输入用户名<username>密码<password>登录,成功后返回首页
    Then 验证消息数量:<number>
    Examples:
    |username   |password|number|
    |13500000045|123456  |99+   |
    |13500000060|123456  |16    |







