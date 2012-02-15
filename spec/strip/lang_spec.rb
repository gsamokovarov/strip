describe 'Language' do
  def engine(markup, options = {})
    Strip::Engine.new(options).call(markup)
  end

  context 'tags' do
    it 'should declare tags on the beginning of the line' do
      strip = deindent <<-STRIP, :by => 8
        root
      STRIP

      engine(strip).should eq(xml { root })
    end

    it 'should declare childs with semantic identation' do
      strip = deindent <<-STRIP, :by => 8
        outer
          inner
            another-inner-one
      STRIP

      engine(strip).should eq(
        xml {
          outer {
            inner {
              send 'another-inner-one'
            }
          }
        }
      )
    end
  end

  context 'attributes' do
    it 'should declare attributes after the tag with <name>="<text>"' do
      strip = deindent <<-STRIP, :by => 8
        project name="Hello" default="compile"
      STRIP

      engine(strip).should eq(xml { project :name => 'Hello', :default => 'compile' })
    end

    xit 'should allow you to omit the quotes if the value is a single word' do
      strip = deindent <<-STRIP, :by => 8
        project name=Hello default=compile
      STRIP

      engine(strip).should eq(xml { project :name => 'Hello', :default => 'compile' })
    end
  end
end
