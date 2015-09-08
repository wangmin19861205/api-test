class ABC
  def initialize
    @a=1
  end
end


class BBC<ABC
  def abc
    puts @a
  end
end

a=BBC.new.abc