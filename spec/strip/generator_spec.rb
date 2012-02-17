describe Strip::Generator do
  context [:xml, :tag].inspect do
    it 'should handle tags with reserved names' do
      expression = 
        [:xml, :tag, 'method_missing', nil, 
          [:xml, :tag, 'comment', nil,
            [:xml, :tag, 'initialize', nil,
              [:xml, :tag, 'to_s', nil]]]]

      generate(expression).should eq(
        xml {
          method_missing_ {
            comment_ {
              initialize_ {
                to_s_
              }
            }
          }
        }
      )
    end

    it 'should handle nested tag nodes' do
      expression = 
        [:xml, :tag, 'root', nil, 
          [:xml, :tag, 'child', nil]]

      generate(expression).should eq(
        xml {
          root {
            child
          }
        }
      )
    end

    it 'should handle deeply nested tag nodes' do
      expression =
        [:xml, :tag, 'root', nil, 
          [:xml, :tag, 'child', nil,
            [:xml, :tag, 'even-deeper', nil]]]

      generate(expression).should eq(
        xml {
          root {
            child {
              send 'even-deeper'
            }
          }
        }
      )
    end

    [:comment, :text, :cdata].each do |node|
      it "should handle nested #{node} nodes" do
        expression =
          [:xml, :tag, 'root', nil, 
            [:xml, :tag, 'child', nil,
              [:xml, :tag, 'even-deeper', nil],
              [:xml, node, 'foo']],
            [:xml, node, 'bar']]

        generate(expression).should eq(
          xml { |_|
            _.root {
              _.child {
                _.send 'even-deeper'
                _.send node, 'foo'
              }
              _.send node, 'bar'
            }
          }
        )
      end
    end

    it 'should handle xml namespaces' do
      expression =
        [:xml, :tag, 'root', nil, 
          [:xml, :attr, 'xmlns:foo', 'bar'],
          [:xml, :tag, 'child', 'foo']]

      generate(expression).should eq(
        xml { |_|
          _.root('xmlns:foo' => 'bar') {
            _['foo'].child
          }
        }
      )
    end
  end

  context [:xml, :attr].inspect do
    it 'should define attribtes' do
      expression =
        [:xml, :tag, 'p', nil, 
          [:xml, :attr, 'class', 'shiny']]

      generate(expression).should eq(
        xml { |xml|
          xml.p.shiny
        }
      )
    end

    it 'should define attributes and namespaces' do
      expression =
        [:xml, :tag, 'root', nil, 
          [:xml, :attr, 'xmlns:foo', 'bar']]

      generate(expression).should eq(
        xml { |_|
          _.root('xmlns:foo' => 'bar')
          _.parent.namespaces.should include('xmlns:foo' => 'bar')
        }
      )
    end
  end

  [:comment, :text, :cdata].each do |node|
    context [:xml, node].inspect do
      it "should render as xml #{node} node" do
        expression =
          [:xml, :tag, 'root', nil, 
            [:xml, node, 'Hello']]

        generate(expression).should eq(
          xml { |_|
            _.root {
              _.send node, 'Hello'
            }
          }
        )
      end
    end
  end
end
