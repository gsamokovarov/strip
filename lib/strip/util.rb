module Strip
  module Util
    module AbstractMethods
      def abstract_method(*names)
        names.each do |name|
          define_method(name) do
            raise NotImplementedError, "Expected implementation of #{name}"
          end
        end
      end

      [:private, :protected].each do |access|
        define_method :"#{access}_abstract_method" do
          abstract_method name, message
          send access, name
        end
      end
    end
  end
end
