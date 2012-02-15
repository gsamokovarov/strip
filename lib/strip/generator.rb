module Strip
  class Generator
    include Base::Dispatcher

    def call(expression)
      super
      document.to_xml
    end

    on [:nokogiri, :tag] do |name, ns, *expressions|
      next_node = nil
      with_current_tag do |xml|
        xml = xml[ns] unless ns.nil?
        next_node = xml.send :"#{name}_"
      end
      expressions.each do |expression|
        set_current_tag next_node
        compile expression
      end
    end

    on [:nokogiri, :attr] do |name, value|
      with_current_tag do |xml|
        if /^xmlns(:\w+)?$/ =~ name
          xml.parent.add_namespace_definition name.split(':', 2).last, value
        else
          xml.parent[name] = value
        end
      end
    end

    [:comment, :text, :cdata].each do |node|
      on [:nokogiri, node] do |text|
        with_current_tag { |xml| xml.send node, text }
      end
    end

    private

    def document
      @document ||= Nokogiri::XML::Builder.new
    end

    def with_current_tag(&block)
      return document.instance_eval &block if @current_tag.nil?
      Nokogiri::XML::Builder.with @current_tag, &block
    end

    def set_current_tag(node)
      @current_tag = node.instance_variable_get :@node
    end
  end
end
