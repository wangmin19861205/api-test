require_relative 'mysqldiy'

class Resultdiy
  def initialize result
    @result=result
  end

  def result_to_list
    @result.all
  end

  def result_count
    @result.count
  end

  def result_first *args, &block
    @result.first(*args, &block)
  end

end




