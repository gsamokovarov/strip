module Strip::Parser::StackSupport
  class Stack < Array
    alias :top :last
  end

  def stack
    @stack ||= Stack.new
  end
end
