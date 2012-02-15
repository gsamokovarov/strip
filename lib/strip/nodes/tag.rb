module Strip
  class Tag < Node[:name, :ns, :parent]
    def self.pattern
      /\A(?<name>[-.\w]+):?(?<ns>\g<name>)?/
    end

    def root?
      parent.nil?
    end

    def children
      @children ||= [].to_set
    end

    def children?
      not children.empty?
    end

    def <<(node)
      children << node
    end

    def parent=(node)
      return node if @parent == node
      node << self unless node.nil?
      @parent = node
    end

    def to_exp
      expression = [:strip, :tag, name, ns]
      children.each { |child| expression << child.to_exp } if children?
      expression
    end
  end
end
