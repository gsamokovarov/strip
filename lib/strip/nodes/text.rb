module Strip
  class Text < Node[:text]
    def self.pattern
      /\A\|\s?(?<text>.*)/
    end

    def to_exp
      [:strip, :text, text]
    end
  end
end
