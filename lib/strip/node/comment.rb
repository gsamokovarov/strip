module Strip::Node
  node :comment do
    attr_accessor :comment

    scan_with /\b#(?<comment>.*)/

    def to_exp
      [:strip, :comment, comment]
    end
  end
end
