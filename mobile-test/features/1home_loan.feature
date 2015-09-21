# language: en
@loan
Feature: 验证首页项目的数据

  Scenario: 未登录，验证非新手项目第一页数据
    Given 用户进入首页
    Then 首页项目卡片等于:
      |10.5       |11.5      |11.5       |12.5       |
      |0.5%       |          |           |1.5%       |
      |44天       |68天       |30-90天    |33天       |
      |1000元起投  |1000元起投 |1000元起投  |1000元起投  |

  Scenario: 未登录，验证非新手项目数据
    Given 用户进入首页
    Then 首页新手项目卡片等于:
      |12.5     |
      |+0.5%    |
      |4.5个月   |
      |100元    |


  Scenario Outline: 登录后，验证非新手项目第一页数据---非首次投资用户
    Given 用户进入首页
    Given 进入我的账户页
    Given 输入用户名<username>密码<password>登录,成功后返回首页
    Then 首页项目卡片等于:
      |10.5       |11.5      |11.5       |12.5       |12.5    |10.5     |
      |0.5%       |          |           |1.5%       |1.5%    |0.5%     |
      |44天       |68天       |30-90天    |33天       |        |         |
      |1000元起投  |1000元起投 |1000元起投  |1000元起投 |        |         |
    Examples:
      |username   |password |
      |13500000045|123456   |

  Scenario Outline: 登录后，验证非新手项目第一页数据---首次投资用户
    Given 用户进入首页
    Given 进入我的账户页
    Given 输入用户名<username>密码<password>登录,成功后返回首页
    Then 首页项目卡片等于:
      |10.5       |11.5      |11.5       |12.5       |
      |0.5%       |          |           |1.5%       |
      |44天       |68天       |30-90天    |33天       |
      |1000元起投  |1000元起投 |1000元起投  |1000元起投 |
    Examples:
      |username   |password |
      |13500000060|123456   |


  Scenario Outline: 登录后，验证新手项目数据
    Given 用户进入首页
    Given 进入我的账户页
    Given 输入用户名<username>密码<password>登录,成功后返回首页
    Then 首页新手项目卡片等于:
      |12.5     |
      |+0.5%    |
      |4.5个月  |
      |100元    |
    Examples:
      |username   |password|
      |13500000060|123456  |



