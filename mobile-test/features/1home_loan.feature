@home_loan
Feature: 首页-投资项目数据
  Scenario: 未登录，验证非新手项目第一页数据
    Given 用户打开首页
    Then 首页项目卡片等于:
      |11       |11      |11       |11      |
      |       |     0.5%     |           |       |
      |3-6天       |66天       |99天    |30天       |
      |1000元起投  |1000元起投 |1000元起投  |50万起投  |

  Scenario: 未登录，验证非新手项目数据
    Given 用户打开首页
    Then 首页新手项目卡片等于:
      |11     |
      |%    |
      |30天   |
      |100元    |

  Scenario Outline: 登录后，验证非新手项目第一页数据---非首次投资用户
    Given 用户打开首页
    Given 进入我的账户页
    Given 输入用户名<username>密码<password>登录,成功后返回首页
    Given 用户进入首页
    Then 首页项目卡片等于:
      |11         |11         |11        |11       |
      |           |0.5%       |          |         |
      |3-6天      |66天       |99天       |30天     |
      |1000元起投  |1000元起投 |1000元起投  |50万起投  |
    Examples:
      |username   |password |
      |13500000069|123456   |

  Scenario Outline: 登录后，验证非新手项目第一页数据---首次投资用户
    Given 用户打开首页
    Given 进入我的账户页
    Given 输入用户名<username>密码<password>登录,成功后返回首页
    Given 用户进入首页
    Then 首页项目卡片等于:
      |11       |11      |11       |11      |
      |       |     0.5%     |           |       |
      |3-6天       |66天       |99天    |30天       |
      |1000元起投  |1000元起投 |1000元起投  |50万起投  |
    Examples:
      |username   |password |
      |13500000071|123456   |

  Scenario Outline: 登录后，验证新手项目数据
    Given 用户打开首页
    Given 进入我的账户页
    Given 输入用户名<username>密码<password>登录,成功后返回首页
    Given 用户进入首页
    Then 首页新手项目卡片等于:
      |11     |
      |%    |
      |30天   |
      |100元    |
    Examples:
      |username   |password|
      |13500000071|123456  |




