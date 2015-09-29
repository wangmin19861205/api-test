Feature:验证用户资产概览页面
  Scenario Outline:验证用户资产概览
    Given 前提:用户登录账户<username>密码<password>
    Given 验证我的资产:
    |375,334.20|9,882.70|8,601.79|9,990.00|30.00|

    Examples:
      |username   |password|
      |13500000069|123456  |

