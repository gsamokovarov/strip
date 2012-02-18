module Strip::Node
  node :tag do
    attr_accessor :name
    attr_accessor :ns
    attr_accessor :parent

    match_with /\A(?<name>[-.\w]+):?(?<ns>\g<name>)?/
  
    def root?
      parent.nil?
    end

    def children
      @children ||= Set.new
    end

    def children?
      not children.empty?
    end

    def <<(node)
      children << node
    end

    def parent=(node)
      raise ArgumentError, "Can not be parent of itself" if node == self

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
