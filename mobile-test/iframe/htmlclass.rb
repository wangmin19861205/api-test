require_relative 'timediy'


class HTMLReport
  include Timediy
  # Initialize the report class
  def initialize()
    @overallResult = 'PASS'
    @reportContent1 = ''
    @reportContent2 = ''
    @start_time = Time.now
    @passed = 0
    @failed = 0
  end

  def createReport(reportName, header, browser_type)
#此处包含生成测试报告的名字、title、浏览器的类型。
    @reportName = reportName

    def get_date #报告产生的日期
      Time.now.strftime("%m.%d.%y")
    end
    def get_time
      Time.now.strftime("%I.%M.%S.%p")
    end

    # Create the report name
    d = self.get_date
    t = self.get_time
    strTime = "#{d}-#{t}.html"
    strNiceTime = "#{d} @ #{t}"

    #此处规定了测试报告生成的名字， 以及路径， 其实路径最好不好写， 以免影响其独立性。
    strTotalReport = "results/" + reportName + '_' + browser_type + '-' + strTime
    # Create the HTML report
    strFile = File.open(strTotalReport, 'w')
    # Format the header of the HTML report
    @reportContent1 = '<html>
      <head>
      <meta content=text/html; charset=ISO-8859-1 http-equiv=content-type>
      <title>Test Report: ' + header + '</title>
      <link rel="stylesheet" type="text/css" href="../classes/css/bluegray.css">
      </head>
      <body>
      <br />
      <center>
      <table width=800 border=1 cellpadding=1 cellspacing=1>
      <tbody>
      <tr>
      <td>
      <table width=100% cellpadding=2 cellspacing=2 bgcolor="#E0FFFF">
      <tbody>
      <tr>
      <th class="header" align=center>Test Report: ' + header + '</th>
      </tr>
      </tbody>
      </table>
      <br />
      <center>
      <table border=1 width=95% cellpadding=1 cellspacing=1>
      <tbody>
      <tr>
      <th width=15% bgcolor="#E0FFFF">File Name:</th>
      <td width=85% colspan=5 align="center">' + reportName + '-' + strTime + '</td>
      </tr>
      <tr>
      <th class="nobg" width=15% bgcolor="#E0FFFF">Test Date:</th>
      <td width=30% align="center">' + strNiceTime + '</td>
      <th class="nobg" width=15% bgcolor="#E0FFFF">Test Result:</th>'

    @reportContent2 = '
      </center>
      <br>
    <table width=95% cellpadding=2 cellspacing=1 border=1>
      <tr><td>case title</td></tr>
      <tr><td>test</td></tr>
      </table>
      <br>
      <center>
      <table width=95% cellpadding=2 cellspacing=1 border=1>
      <tbody>
      <tr bgcolor="#E0FFFF">
      <th width=45%>Test Step</th>
      <th width=10%>Result</th>
      <th width=45%>Description</th>
      </tr>'

    # Close the report
    strFile.close

    return strTotalReport
  end


  def createReport1(header)
    @reportName = "result.html"
    d = getnowdatesimple
    t = getnowtimesimple
    strTime = "#{d}-#{t}.html"
    strNiceTime = "#{d} @ #{t}"

    #此处规定了测试报告生成的名字， 以及目录(相对路劲)。
    strTotalReport = "results/" + @reportName
    #打开报告，没有新建，追加模式
    strFile = File.open(strTotalReport, 'a')
    #格式化测试记录主表单
    @reportContent1 = '
      <body>
      <br />
      <center>
      <table width=800 border=1 cellpadding=1 cellspacing=1>
      <tbody>
      <tr>
      <td>
      <table width=100% cellpadding=2 cellspacing=2 bgcolor="#E0FFFF">
      <tbody>
      <tr>
      <th class="header" align=center>Test Report: ' + header + '</th>
      </tr>
      </tbody>
      </table>
      <br />
      <center>
      <table border=1 width=95% cellpadding=1 cellspacing=1>
      <tbody>
      <tr>
      <th class="nobg" width=15% bgcolor="#E0FFFF">Test Date:</th>
      <td width=30% align="center">' + strNiceTime + '</td>
      <th class="nobg" width=15% bgcolor="#E0FFFF">Test Result:</th>'

    @reportContent2 = '
      <table width=95% cellpadding=2 cellspacing=1 border=1>
      <tbody>
      <tr bgcolor="#E0FFFF">
      <th width=45%>Test Step</th>
      <th width=10%>Result</th>
      <th width=45%>Description</th>
      </tr>'
    strFile.close
    return strTotalReport
  end

  def newTestName(name)
    #1个case的test方法new1个testname
    @reportContent2 = @reportContent2 + '<tr><td class ="alt" colspan="3" align="center" bgcolor="#B0C4DE">' + name + '</td></tr>'
  end

  def addtoReport(step, result, description)
    #定义检查点html的结构
    @reportContent2 = @reportContent2 + '<tr><td class="step">' + step + '</td>'
    if result == 'PASS'
      @reportContent2 = @reportContent2 + '<td class="result_pass" bgcolor="green" align="center">' + result + '</td>'
      @passed += 1
    else
      @overallResult = 'FAIL'
      @reportContent2 = @reportContent2 + '<td class="result_fail" bgcolor="red" align="center">' + result + '</td>'
      @failed += 1
    end

    @reportContent2 = @reportContent2 + ' <td class="result_text">' + description + '</td></tr>'
  end

  def add_to_report(result ,test)
    #针对测试检查点，输出单个检查点的html报告
    if result.class == Array
      result[0] == true ? self.addtoReport(test, 'PASS', result[1]) : self.addtoReport(test, 'FAIL', result[1])
    else
      result == true ? self.addtoReport(test, 'PASS', 'PASS') : self.addtoReport(test, 'FAIL', 'FAIL')
    end
  end


  def finishReport(reportName, env)
    #完善报告
    strFile = File.open(reportName, 'a')
    strFile.puts(@reportContent1)
    total = @passed + @failed
    percent_pass = ((@passed.to_f/total * 100)).to_s
    percent_fail = ((@failed.to_f/total * 100)).to_s
    strFile.puts('<td align="center" colspan=3>' + '<b><font color="green">' + "%.02f" % percent_pass + '% Passed, ' + '<font color="red">' + "%.02f" % percent_fail + '% Failed' + '</b></td></tr>')
    #填写测试时间
    seconds = (Time.now - @start_time)
    test_time = format_test_time(seconds)
    strFile.puts('</tr>
      <th width=15% bgcolor="#E0FFFF">Run time:</th>
      <td width=20% align="center">' + test_time  + '</td>
      <th width=25% bgcolor="#E0FFFF">Env:</th>
      <td align="center">' + env + '</td>
      </tr>
      </tbody></table>')
    strFile.puts(@reportContent2+'</tbody>
          </table>
          </center>
          </td>
          </tr>
          </tbody>
          </table>
          </center>
          </body>')
    strFile.close
  end
end