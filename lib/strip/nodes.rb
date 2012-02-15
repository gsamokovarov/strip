module Strip
  class Node
    class << self
      [:extend, :include].each do |inclusion|
        send inclusion, Util::AbstractMethods
      end

      abstract_method :pattern

      def from_line(line)
        unless line.matched?
          raise ValueError, "The node must be matched against the line"
        end
        options = {}.tap do |hash|
          line.matched.names.each do |name|
            hash[name.to_sym] = line.matched[name]
          end
          hash[:line] = line
        end
        new options
      end

      def of(*attrs)
        Class.new self do
          attrs.each { |attr| attr_accessor attr }

          define_method :initialize do |*args|
            (Hash === args.last ? args.last : attrs.zip(args)).each do |attr, value|
              send :"#{attr}=", value if respond_to? attr.to_sym
            end
          end
        end
      end

      def ===(other)
        other === pattern
      end
    end

    abstract_method :to_exp

    attr_accessor :line
  end

  class Tag < Node.of(:name, :ns, :parent)
    def self.pattern
      /\A(?<name>[-.\w]+):?(?<ns>\g<name>)?/
    end

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

  class Attr < Node.of(:name, :value)
    def self.pattern
      /\b(?<name>[-:\w]+)\s*=\s*(?<quote>['"])(?<value>.*?)\k<quote>/
    end

    def to_exp
      [:strip, :attr, name, value]
    end
  end

  class Text < Node.of(:text)
    def self.pattern
      /\A\|\s?(?<text>.*)/
    end

    def to_exp
      [:strip, :text, text]
    end
  end

  class Comment < Node.of(:comment)
    def self.pattern
      /\b#(?<text>.*)/
    end

    def to_exp
      [:strip, :comment, comment]
    end
  end
end
