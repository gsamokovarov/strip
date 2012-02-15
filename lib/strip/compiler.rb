module Strip
  class Compiler
    include Base::Dispatcher

    on [:strip, :tag] do |name, ns, *expressions|
      [:nokogiri, :tag, name, ns, *expressions.map { |exp| compile exp }]
    end

    [:attr, :text, :comment, :cdata].each do |node|
      on([:strip, node]) { |*data| [:nokogiri, node, *data] }
    end
  end
end
