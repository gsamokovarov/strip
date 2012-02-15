describe Strip::Error::Definition do
  context 'when extended' do
    describe '#exception' do
      it 'should be aliased to error' do
        Strip::Error::Definition.instance_method(:exception).should ==
          Strip::Error::Definition.instance_method(:error)
      end

      { :class => Class, :module => Module }.each do |kind, wrapper|
        it "should define exceptions binded to the current #{kind}" do
          custom_class_or_module =
            create kind do
              extend Strip::Error::Definition

              exception :Custom
            end

          custom_class_or_module.const_get(:Custom).should <= StandardError
        end
      end

      it 'should extends from custom errors' do
        custom_class =
          create :class do
            extend Strip::Error::Definition

            exception :Base
            exception :Custom, :extends => :Base
          end

        constant = proc { |name| custom_class.const_get name }

        constant[:Base].should <= StandardError
        constant[:Custom].should <= constant[:Base]
      end
    end
  end
end
