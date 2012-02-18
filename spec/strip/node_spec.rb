describe Strip::Node do
  after :each do
    Strip::Node.send :remove_const, :Custom if Strip::Node.const_defined?(:Custom)
  end

  describe '::node' do
    it 'should define custom nodes' do
      Strip::Node.node(:custom) do
        attr_accessor :name
      end

      Strip::Node.constants.should include(:Custom)

      Strip::Node::Custom.should < Strip::Node::Base
      Strip::Node::Custom.instance_methods.should include(:name)
    end
  end

  describe '::get' do
    it 'should have an alias of []' do
      Strip::Node.method(:get).should == Strip::Node.method(:[])
    end

    it 'should get custom nodes' do
      Strip::Node.node(:custom)

      Strip::Node.get(:custom).should be(Strip::Node::Custom)
    end
  end
end
