module Strip
  module Base
    class Stack < Array
      alias_method :top, :last
    end

    class Line
      DEFAULT_OPTIONS = { tabsize: 2 }

      attr_reader :unstripped, :number, :options, :matched

      def initialize(line, number, options = {})
        @unstripped = line
        @number = number
        @options = DEFAULT_OPTIONS.dup.merge options
      end

      def text
        @text ||= unstripped.strip
      end

      def indentation
        @indentation ||= unstripped[/^[ \t]*/].gsub(/\t/, ' ' * options[:tabsize]).size
      end

      def empty?
        text.empty?
      end
    
      def matched?
        not @matched.nil?
      end

      def prematch
        @prematch ||= unstripped[/^[ \t]*/]
      end

      def postmatch
        @postmatch ||= text.dup
      end

      def match?(pattern)
        not (postmatch =~ pattern).nil?
      ensure
        @matched = $LAST_MATCH_INFO
        @prematch = $PREMATCH unless $PREMATCH.nil?
        @postmatch = $POSTMATCH unless $POSTMATCH.nil?
      end

      alias_method :===, :match?

      def scan(node)
        yield matched while self === (node.respond_to?(:pattern) ? node.pattern : node)
      end

      def reset
        @prematch = @match = @postmatch = nil
      end
    end

    module Dispatcher
      def self.included(base)
        base.extend ClassMethods
        base.send :include, Temple::Mixins::Dispatcher
        base.send :include, Temple::Mixins::Options
      end

      module ClassMethods
        def on(expression, &block)
          define_method ["on"].push(expression.map(&:to_s)).join('_'), &block
        end
      end
    end

    class Parser
      extend Strip::Util::AbstractMethods
      include Strip::Error
      include Temple::Mixins::Options

      set_default_options :tabsize => 2

      class << self
        def method_missing(name, *args, &block)
          if block_given?
            define_method name, &block
          else
            super
          end
        end
      end

      def call(markup)
        @lineno = 0
        @lines = markup.lines
        @stack = nil

        parse
      end

      private

      abstract_method :before_each_parsing, :parsing, :parsing_done

      def stack
        @stack ||= Stack.new
      end
      
      def line
        @line || next_line!
      end

      def next_line
        @line = Line.new @lines.peek, @lineno + 1, :tabsize => options[:tabsize]
      end

      def next_line!
        @line = Line.new @lines.next, @lineno += 1, :tabsize => options[:tabsize]
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
end
