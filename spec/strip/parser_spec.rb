describe Strip::Parser do
  context 'tags' do
    it 'should be the first word of the line' do
      markup = deindent <<-STRIP, :by => 8
        root
      STRIP

      parse(markup).should eq([:strip, :tag, 'root', nil])
    end

    it 'should nest other tags with semantic indentation' do
      markup = deindent <<-STRIP, :by => 8
        root
          child
      STRIP

      parse(markup).should eq(
        [:strip, :tag, 'root', nil,
          [:strip, :tag, 'child', nil]]
      )
    end

    it 'should match tags on different indentation levels' do
      markup = deindent <<-STRIP, :by => 8
        root
          child1
            inner1
          child2
              inner2
              inner3
               deep1
                even-deeper1
              inner4
      STRIP

      # Yeah, that works, but seriously, don't do it.

      parse(markup).should eq(
        [:strip, :tag, 'root', nil,
          [:strip, :tag, 'child1', nil,
            [:strip, :tag, 'inner1', nil]],
          [:strip, :tag, 'child2', nil,
            [:strip, :tag, 'inner2', nil],
            [:strip, :tag, 'inner3', nil,
              [:strip, :tag, 'deep1', nil,
                [:strip, :tag, 'even-deeper1', nil]]],
            [:strip, :tag, 'inner4', nil]]]
      )
    end

    context 'should raise SyntaxError' do
      it 'on bad indentation' do
        markup = deindent <<-STRIP, :by => 10
          root
            child1
           inner1
        STRIP

        expect { parse(markup) }.to raise_error(Strip::Error::SyntaxError)
      end

      it 'on multiple root elements' do
        markup = deindent <<-STRIP, :by => 10
          root
            child1
          root2
        STRIP

        expect { parse(markup) }.to raise_error(Strip::Error::SyntaxError)
      end
    end
  end

  context 'attrs' do
    it 'should match attributes optionally follow a tag definition' do
      markup = deindent <<-STRIP, :by => 8
        root attr="value"
      STRIP

      parse(markup).should eq(
        [:strip, :tag, 'root', nil,
          [:strip, :attr, 'attr', 'value']]
      )
    end

    it 'should match multiple attributes after a tag' do
      markup = deindent <<-STRIP, :by => 8
        root attr1="value" attr2="value" attr3="value"
      STRIP

      parse(markup).should eq(
        [:strip, :tag, 'root', nil,
          [:strip, :attr, 'attr1', 'value'],
          [:strip, :attr, 'attr2', 'value'],
          [:strip, :attr, 'attr3', 'value']]
      )
    end

    it 'should match attribute values with single quotes' do
      markup = deindent <<-STRIP, :by => 8
        root attr1='value' attr2="value"
      STRIP

      parse(markup).should eq(
        [:strip, :tag, 'root', nil,
          [:strip, :attr, 'attr1', 'value'],
          [:strip, :attr, 'attr2', 'value']]
      )
    end

    context 'should raise SyntaxError' do
      it 'on malformed attributes' do
        markup = deindent <<-STRIP, :by => 10
          root attr1='value' attr2
        STRIP

        expect { parse(markup) }.to raise_error Strip::Error::SyntaxError
      end
    end
  end

  context 'text' do
    it 'should match text nodes prefixed by | on a new line' do
      markup = deindent <<-STRIP, :by => 8
        root
          | Hey, I'm a text node!
      STRIP

      parse(markup).should eq(
        [:strip, :tag, 'root', nil,
          [:strip, :text, "Hey, I'm a text node!"]]
      )
    end

    it 'should ignore | after the first indicator' do
      markup = deindent <<-STRIP, :by => 8
        root
          | It's | fine.
      STRIP

      parse(markup).should eq(
        [:strip, :tag, 'root', nil,
          [:strip, :text, "It's | fine."]]
      )
    end
  end
end
