module Strip
  module Error
    module Definition
      def exception(name, options = {}, &block)
        base = options[:extends] || StandardError
        base = const_get base if Symbol === base
        const_set name, Class.new(base, &block)
      end

      alias_method :error, :exception
    end

    extend Definition

    exception :Base

    exception :SyntaxError, :extends => :Base do
      attr_accessor :line

      def initialize(message, line)
        @message = message
        @line    = line
      end

      def to_s
        "[Line: #@line] #@message"
      end
    end

    def syntax_error(message, line)
      raise SyntaxError.new(message, line)
    end

    exception :ExpectationError, :extends => :SyntaxError

    def expectation_error(expected, reason=nil, got=nil)
      raise ExpectationError, %[Expected #{expected} #{"got: #{got}" unless got.nil?}]
    end
  end
end
