describe Strip::Node::Attr do
  describe '#to_exp' do
    it 'should render the node as s-expression' do
      attr= Strip::Node::Text.new(:text  => 'pesho')

      attr.to_exp.should eq([:strip, :text, 'pesho'])
    end
  end
end
