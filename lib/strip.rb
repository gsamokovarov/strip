require 'English'

require 'nokogiri'
require 'temple'

module Strip
  autoload :Compiler,   'strip/compiler'
  autoload :Dispatcher, 'strip/dispatcher'
  autoload :Engine,     'strip/engine'
  autoload :Generator,  'strip/generator'
  autoload :Grammar,    'strip/grammar'
  autoload :Line,       'strip/line'
  autoload :Node,       'strip/node'
  autoload :Parser,     'strip/parser'
  autoload :Util,       'strip/util'
  autoload :Version,    'strip/version'

  extend Strip::Util

  class << self
    def version
      [Version::Major, Version::Minor, Version::Patch].join('.')
    end
  end

  exception :Error

  exception :SyntaxError, :extends => :Error do
    attr_accessor :line

    def initialize(message, line)
      @message = message
      @line    = line
    end

    def to_s
      "[Line: #@line] #@message"
    end
  end
end
