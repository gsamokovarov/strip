module Strip::Node
  node :text do
    attr_accessor :text

    match_with /\A\|\s?(?<text>.*)/
    scan_with  /\|\s?(?<text>.*)/

    def to_exp
      [:strip, :text, text]
    end
  end
end
