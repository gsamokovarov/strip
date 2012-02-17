module Strip::Parser::LineBasedParsing
  class << self
    def included(base)
      base.extend ClassMethods
      base.send :include, InstanceMethods
      base.send :include, Temple::Mixins::Options
    end
  end

  module ClassMethods
    def method_missing(name, *args, &block)
      if block_given?
        define_method name, &block
      else
        super
      end
    end
  end

  module InstanceMethods
    extend Strip::Util

    def call(markup)
      @lineno = 0
      @lines = markup.lines
      @stack = nil

      parse
    end

    private

    require_includer_to_implement :before_each_parsing
    require_includer_to_implement :parsing
    require_includer_to_implement :parsing_done

    def line
      @line || next_line!
    end

    def next_line
      Strip::Line.new @lines.peek, @lineno + 1, :tabsize => options[:tabsize]
    end

    def next_line!
      @line = Strip::Line.new @lines.next, @lineno += 1, :tabsize => options[:tabsize]
    end

    def syntax_error(message)
      raise Strip::SyntaxError.new(message, line)
    end

    def parse
      loop do
        begin
          before_each_parsing
          parsing
          next_line!
        rescue StopIteration
          break
        end
      end

      parsing_done
    end
  end
end
