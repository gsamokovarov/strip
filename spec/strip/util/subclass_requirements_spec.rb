describe Strip::Util::SubclassRequirements do
  context 'when extended' do
    describe '#require_subclass_to_implement' do
      it "should raise NotImplementedError on missing implementations" do
        cls =
          create :class do
            extend Strip::Util::SubclassRequirements

            require_subclass_to_implement :foo
          end

        expect { cls.new.foo }.to raise_error(NotImplementedError)
      end

      it "should also define protected and private requiremets" do
        base =
          Class.new do
            extend Strip::Util::SubclassRequirements

            require_subclass_to_implement :foo, :as => :private
            require_subclass_to_implement :boo, :as => :protected
          end

        subclass =
          Class.new base do
            define_method(:initialize) { |&block| instance_eval &block }
          end

        expect { subclass.new { foo } }.to raise_error(NotImplementedError)
        expect { subclass.new { boo } }.to raise_error(NotImplementedError)

        subclass.private_instance_methods.should   include(:foo)
        subclass.protected_instance_methods.should include(:boo)
      end
    end
  end
end
