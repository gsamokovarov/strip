describe Strip::Util::ExceptionDeclaration do
  context 'when extended' do
    describe '#exception' do
      { :class => Class, :module => Module }.each do |kind, wrapper|
        it "should define exceptions binded to the current #{kind}" do
          custom_class_or_module =
            create kind do
              extend Strip::Util::ExceptionDeclaration

              exception :Custom
            end

          custom_class_or_module.const_get(:Custom).should <= StandardError
        end
      end

      it 'should extends from custom errors' do
        custom_class =
          create :class do
            extend Strip::Util::ExceptionDeclaration

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
