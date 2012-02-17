class Strip::Compiler
  include Strip::Dispatcher

  on [:strip, :tag] do |name, ns, *expressions|
    [:xml, :tag, name, ns,
      *expressions.map { |exp| compile exp }]
  end

  [:attr, :text, :comment, :cdata].each do |node|
    on([:strip, node]) { |*data| [:xml, node, *data] }
  end
end
