describe Strip::Node::Tag do
  describe '::new' do
    it 'should populate to #name, #ns and #parent' do
      tag = Strip::Node::Tag.new(:name   => 'root',
                                 :ns     => nil,
                                 :parent => nil)

      tag.name.should   == 'root'
      tag.ns.should     eq(nil)
      tag.parent.should eq(nil)
    end

    describe '#children' do
      it 'should contain tag children' do
        parent = Strip::Node::Tag.new(:name => 'root')
        child  = Strip::Node::Tag.new(:name => 'child')

        parent << child

        parent.children.should include(child)
      end
    end

    describe '#<<' do
      it 'should add children to a tag, but only once' do
        parent = Strip::Node::Tag.new(:name => 'parent')
        child  = Strip::Node::Tag.new(:name => 'child')

        parent << child
        parent << child

        parent.children.should      include(child)
        parent.children.size.should be(1)
      end
    end

    describe '#root?' do
      it 'should tell if a tag is the root one' do
        tag = Strip::Node::Tag.new(:name => 'root')

        tag.root?.should be(true)

        root = Strip::Node::Tag.new(:name => 'real-root')
        tag.parent = root

        root.root?.should be(true)
        tag.root?.should be(false)
      end
    end

    describe '#to_exp' do
      it 'should render the node as s-expression' do
        root  = Strip::Node::Tag.new(:name => 'root')
        child = Strip::Node::Tag.new(:name => 'child')

        root << child

        root.to_exp.should eq(
          [:strip, :tag, 'root', nil,
            [:strip, :tag, 'child', nil]]
        )
      end
    end
  end
end
