module Strip
  class Comment < Node[:text]
    def self.pattern
      /\b#(?<text>.*)/
    end

    def to_exp
      [:strip, :text, text]
    end
  end
end
