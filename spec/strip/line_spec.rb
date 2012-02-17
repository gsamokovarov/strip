describe Strip::Line do
  let :line do
    Strip::Line.new "  root attr='value' another=. | Text and stuff.\n", 1
  end

  let :node do
    Strip::Node
  end

  describe '#initialize' do
    it 'should initialize #cursor #indentation, #number, #text and #unstripped' do
      expected_unstripped = 
        "  root attr='value' another=. | Text and stuff.\n"

      line.unstripped.should  == expected_unstripped
      line.text.should        == expected_unstripped.strip
      line.indentation.should be(2)
      line.cursor.should      be(2)
      line.number.should      be(1)
    end
  end

  describe '#scan' do
    it 'should be able to match nodes with many patterns' do
      # First step, match the tag.
      matched = line.scan(node[:tag]) do |data|
        data[:name].should == 'root'
        data[:ns].should   == nil
      end
      matched.should be(true)

      # Second step, match the attributes.
      matched = line.scan(node[:attr]) do |data|
        %w{attr another}.should include(data[:name])
        %w{value .}.should      include(data[:value])
      end
      matched.should be(true)
      
      # Third step, match the text node.
      matched = line.scan(node[:text]) do |data|
        data[:text].should == 'Text and stuff.'
      end
      matched.should be(true)
    end
  end
end
