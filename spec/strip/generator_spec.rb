describe Strip::Generator do
  context [:nokogiri, :tag].inspect do
    it 'should handle tags with reserved names' do
      expression = 
        [:nokogiri, :tag, 'method_missing', nil, 
          [:nokogiri, :tag, 'comment', nil,
            [:nokogiri, :tag, 'initialize', nil,
              [:nokogiri, :tag, 'to_s', nil]]]]

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
        [:nokogiri, :tag, 'root', nil, 
          [:nokogiri, :tag, 'child', nil]]

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
        [:nokogiri, :tag, 'root', nil, 
          [:nokogiri, :tag, 'child', nil,
            [:nokogiri, :tag, 'even-deeper', nil]]]

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
          [:nokogiri, :tag, 'root', nil, 
            [:nokogiri, :tag, 'child', nil,
              [:nokogiri, :tag, 'even-deeper', nil],
              [:nokogiri, node, 'foo']],
            [:nokogiri, node, 'bar']]

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
        [:nokogiri, :tag, 'root', nil, 
          [:nokogiri, :attr, 'xmlns:foo', 'bar'],
          [:nokogiri, :tag, 'child', 'foo']]

      generate(expression).should eq(
        xml { |_|
          _.root('xmlns:foo' => 'bar') {
            _['foo'].child
          }
        }
      )
    end
  end

  context [:nokogiri, :attr].inspect do
    it 'should define attribtes' do
      expression =
        [:nokogiri, :tag, 'p', nil, 
          [:nokogiri, :attr, 'class', 'shiny']]

      generate(expression).should eq(
        xml { |xml|
          xml.p.shiny
        }
      )
    end

    it 'should define attributes and namespaces' do
      expression =
        [:nokogiri, :tag, 'root', nil, 
          [:nokogiri, :attr, 'xmlns:foo', 'bar']]

      generate(expression).should eq(
        xml { |_|
          _.root('xmlns:foo' => 'bar')
          _.parent.namespaces.should include('xmlns:foo' => 'bar')
        }
      )
    end
  end

  [:comment, :text, :cdata].each do |node|
    context [:nokogiri, node].inspect do
      it "should render as xml #{node} node" do
        expression =
          [:nokogiri, :tag, 'root', nil, 
            [:nokogiri, node, 'Hello']]

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
