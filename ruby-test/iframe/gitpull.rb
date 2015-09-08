require 'rubygems'
require 'git'

module Filelist
  def listfile(filepath)
    if File.directory?(filepath)
      puts "Dirs:" + filepath
      Dir.foreach(filepath) do |filename|
        if filename != "." and filename != ".."
          listfile(filepath + "/" + filename)
        end
      end
    else
      puts "Files:" + filepath
    end
  end

  def listpath(path,fitterpath=[])
    resultpath=[]
    Dir.entries(path).each do |sub|
      if File.directory?(path+'/'+sub) and sub != "." and sub != ".."
        resultpath.push(path+'/'+sub)
      end
    end
    return resultpath
  end


  # 获取需要更新的path,
  # fitterpath为需要过滤的目录列表,
  # 默认过滤掉没有.git的目录
  def listgitpath(path,fitterpath=[])
    resultpath=[]
    Dir.entries(path).each do |sub|
      if File.directory?(path+'/'+sub)
        unless fitterpath.include?sub
          Dir.foreach(path+'/'+sub) do |filename|
            if filename == '.git'
              resultpath.push(path+'/'+sub)
            end
          end
        end
      end
    end
    puts resultpath
    return resultpath
  end
end


include Filelist
# 根据path列表pull
# 返回结果中包括Already up-to-date 无异常，提示已经是最新代码
# 返回结果中包括updating 无异常,提示更新、编译及目录
def  gitpull path
  path.each do |workdir|
    begin
      result=Git.open(workdir).pull
      if result.include?("Already up-to-date")
        puts "#{workdir}已经是最新的了"
      elsif result.include?("Updating")
        puts "#{workdir}更新完毕，请编译代码"
      end
    rescue Exception=>e
      puts "#{workdir}更新失败，错误:#{e.message}"
    end
  end
end




#path='/Users/wangmin/workspace/rui'
#gitpull(listgitpath(path))
#gitpull(['/Users/wangmin/workspace3/site-thrift'])
#listpath("/Users/wangmin/workspace")