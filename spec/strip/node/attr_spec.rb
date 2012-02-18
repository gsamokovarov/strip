describe Strip::Node::Attr do
  describe '#to_exp' do
    it 'should render the node as s-expression' do
      attr= Strip::Node::Attr.new(:name  => 'attr',
                                  :value => 'value')

      attr.to_exp.should eq([:strip, :attr, 'attr', 'value'])
    end
  end
end
