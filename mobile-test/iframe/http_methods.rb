require 'jq/extend'
require 'cgi'
require 'uri'

module Httpmethod
  def httpget (url,head={})
    begin
      result=RestClient::Request.execute(:method => :get,url:url,headers: {:params => head},timeout: 10)
      if not result.code == 200
        raise Exception,"请求报错,httpcode:#{result.code}"
      elsif not result.headers[:content_type] == "application/json; charset=utf-8"
        raise Exception,"返回数据非JSON:#{result.headers[:content_type]}"
      else
        JSON.parse result
      end
    rescue Exception => e
      raise Exception,e.message
    end
  end

  def httppost (url,data,head={})
    begin
      result=RestClient::Request.execute(:method => :post,url:url,payload:data,headers: head,timeout: 10)
      if not result.code == 200
        raise Exception,"请求报错,httpcode:#{result.code}"
      elsif not result.headers[:content_type] == "application/json; charset=utf-8"
        raise Exception,"返回数据非JSON:#{result.headers[:content_type]}"
      else
        JSON.parse result
      end
    rescue Exception => e
      raise Exception,e.message
    end
  end


  def jsonlist respresult,path
    #解析json,resoresult是http请求返回的json数据,path为解析路劲，如'.data.new_user_loan[]'
    #解析完后返回一个列表，如果长度为1，默认返回为index=1的值，目的是一般值为hash或普通数值，直接返回，便于处理对比
    begin
      data=respresult.jq(path)
      if data.length == 1
        return data[0]
      else
        return data
      end
    rescue Exception => e
      raise Exception,e.message
    end
  end


  def assall jsondata,sqldata
    #接受一个hash或array的jsondata
    #如果=hash   对比hash中的每个value(只判断value与顺序)
    #如果=araay  遍历列表再对比每个hash中的每个value
    #sqldata一般为数据库取出的结果array
    #返回true，flase ，信息str
    if jsondata.class == Hash
      jsondata=[].push(jsondata)
    elsif jsondata.class == Array
    else
      raise "既不是hash,也不是array"
    end
    if  asslength jsondata,sqldata
      abc=0
      str=''
      while abc<jsondata.length
        assvalue=jsondata[abc].values
        assvalue0=sqldata[abc].values.collect { |value| value.class == BigDecimal ? value.to_f : value }
        lengths=0
        while lengths<assvalue.length
          if assvalue[lengths] == assvalue0[lengths]
            str+="第#{lengths}组pass,#{assvalue[lengths]}与#{assvalue0[lengths]}对比成功"
          else
            return FALSE,str+="第#{lengths}组pass,#{assvalue[lengths]}与#{assvalue0[lengths]}对比失败"
          end
          lengths+=1
        end
        return TRUE,str
        abc+=1
      end
    else
      raise "长度不一致"
    end
  end

  def asslength jsondata,sqldata
    # 接受一个hash或array的jsondata
    # 判断jsondata与sqldata的长度
    # 返回true，fasle
    if jsondata.class == Hash and sqldata.length == 1
      #puts "json=hash,sql长度为1"
      return TRUE
    elsif jsondata.class == Array and jsondata.length == sqldata.length
      #puts "长度#{jsondata.length},#{sqldata.length}"
      return TRUE
    else
      return FALSE
    end
  end

  def asskey jsondata,sqldata,diykey
    #接受一个hash或array的jsondata
    #如果=hash   对比jsondata中的key=diykey[0]的值与sqldata中的hash中的key=diykey[1]的值
    #如果=araay  遍历列表jsondata与sqldata，取出hash后对比两者的key的值
    #sqldata一般为数据库取出的结果array
    #返回true，flase ，信息str
    if jsondata.class == Hash
      jsondata=[].push(jsondata)
    elsif jsondata.class == Array
    else
      raise "既不是hash,也不是array"
    end
    if asslength jsondata,sqldata and jsondata.empty?
      return TRUE,"json与sql的数据均为空"
    elsif  asslength jsondata,sqldata
      str=''
      abc=0
      while abc<jsondata.length
        assvalue1=jsondata[abc][diykey[0]]
        assvalue2=(sqldata[abc][diykey[1]].class == BigDecimal ? sqldata[abc][diykey[1]].to_f : sqldata[abc][diykey[1]])
        if assvalue1 == assvalue2
          str+="第#{abc}组pass,#{assvalue1},#{assvalue2}\n"
        else
          return FALSE,str+="第#{abc}组failed,#{assvalue1},#{assvalue2}\n"
        end
        abc+=1
      end
      return TRUE,str
    else
      return FALSE,"长度不一致"
    end
  end


  def assreqbody_sqlkey reqbody,sqldata,path
    #接受一个存在长度为1且key值==reqbody中key值的sqldata
    #从sqldata[0]取出hash遍历key值
    #与reqbody的path路径的json进行key的值对比
    str=''
    if sqldata[0].class == Hash
      sqldata[0].each_pair do  |key,value|
        jsonvalue=jsonlist reqbody,path+'.'+key.to_s
        value = value.class == BigDecimal ? value.to_f : value
        if value == jsonvalue
          str+="对比,#{jsonvalue},#{value}\n"
        end
      end
      return true,str
    else
      return false
    end
  end

  def asssqllist sqldata,diykey,assvalue
    sqldata.each do |row|
      row[diykey].class == BigDecimal ? row[diykey].to_f : row[diykey]
      if row[diykey] == assvalue
        #puts "asslist        #{row[diykey]},,,#{assvalue}pass"
      else
        #puts "asslist        #{row[diykey]},,,#{assvalue}不相等"
        return FALSE
      end
    end
    return TRUE
  end

  def urlencode url
    return CGI::escape url
  end

  def urldecode url
    return CGI::unescape url
  end


  def utfencode str
    return URI::escape str
  end

  def utfdecode str
    return URI::unescape str
  end

end
=begin   共用方法
  def httpcoon (meth,url,data={},head={})
    begin
      result=RestClient::Request.execute(method: meth.to_sym,url:url,payload:data,headers: head,timeout: 10)
      resultbody=JSON.parse result
      return result.code,resultbody
    end
  end
=end


