require 'rubygems'
require 'git'


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

def listpath(path,fitterpath=["service-bak","mock-umbpay","admin.bak","auto-invest-server","site-bak","site.bakk"])
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
  return resultpath
end

def  gitpull path
  path.each do |workdir|
    result=Git.open(workdir).pull
    if result.include?("Already up-to-date")
      puts "#{workdir}已经是最新的了"
    elsif result.include?("Updating")
      puts "#{workdir}更新完毕，请编译代码"
    end
  end
end


gitpull(listpath("/Users/wangmin/workspace/rui"))



