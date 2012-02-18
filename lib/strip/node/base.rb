class Strip::Node::Base
  extend Strip::Util

  attr_accessor :line

  class << self
    attr_accessor :patterns

    def from(line, attributes = {})
      unless line.matched?
        raise ValueError, "The node must be matched against the line"
      end

      line.matched.names.each do |name|
        attributes[name] = line.matched[name]
      end
      attributes[:line] = line

      new attributes
    end

    def match_with(pattern)
      (@patterns ||= []) << pattern
    end

    def match?(target)
      patterns.each { |pattern| return true if target === pattern }
      false
    end

    alias :scan_with :match_with
    alias :=== :match?
  end

  def initialize(attributes = {})
    attributes.each do |attr, value|
      setter = "#{attr}=".to_sym
      send setter, value if respond_to? setter
    end
  end

  require_subclass_to_implement :to_exp
end
