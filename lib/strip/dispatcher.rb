module Strip::Dispatcher
  class << self
    def included(base)
      base.extend ClassMethods
      base.send :include, Temple::Mixins::Dispatcher
      base.send :include, Temple::Mixins::Options
    end
  end

  module ClassMethods
    def on(expression, &block)
      handler = ["on"].push(expression.map(&:to_s)).join('_')
      define_method handler, &block
    end
  end
end
