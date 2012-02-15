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

      def [](*attrs)
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
end
