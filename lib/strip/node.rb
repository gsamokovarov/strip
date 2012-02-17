module Strip::Node
  autoload :Base, 'strip/node/base'

  class << self
    def node(name, &block)
      cls = Class.new Base, &block
      constant_name = Strip::Util.constantize name

      const_set constant_name, cls
    end

    def get(node_name)
      const_get Strip::Util.constantize(node_name)
    end

    alias :[] :get
  end
end

require 'strip/node/attr'
require 'strip/node/comment'
require 'strip/node/tag'
require 'strip/node/text'
