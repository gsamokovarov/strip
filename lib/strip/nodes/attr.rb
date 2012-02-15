module Strip
  class Attr < Node[:name, :value]
    def self.pattern
      /\b(?<name>[-:\w]+)\s*=\s*(?<quote>['"])(?<value>.*?)\k<quote>/
    end

    def to_exp
      [:strip, :attr, name, value]
    end
  end
end
