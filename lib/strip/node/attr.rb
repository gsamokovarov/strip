module Strip::Node
  node :attr do
    attr_accessor :name
    attr_accessor :value

    scan_with /^(?<name>[-:\w]+)\s*=\s*(?<value>[^'"\s]+)/
    scan_with /^(?<name>[-:\w]+)\s*=\s*(?<quote>['"])(?<value>.*?)\k<quote>/

    def to_exp
      [:strip, :attr, name, value]
    end
  end
end
