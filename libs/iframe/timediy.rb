require 'time'

module Timediy

  #"2015-09-08 23:23:28"
  def getnowtimeall
    Time.new.strftime("%F %H:%M:%S")
  end

  #"23:23:50"
  def getnowtimesimple
    Time.new.strftime('%T')
  end

  #"2015-09-08"
  def getnowdatesimple
    Time.new.strftime("%F")
  end

  #格式化秒数
  def format_test_time(seconds)
    if seconds < 60
      "0 min, #{"%.02f" % seconds} sec"
    else
      minutes = (seconds/60).to_i
      seconds = seconds - (minutes*60)
      "#{minutes} min, #{"%.02f" % seconds} sec"
    end
  end
end



