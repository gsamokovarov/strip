module Strip::Grammar
  extend Temple::Grammar

  %w{ strip xml }.each do |prefix|
    Expression <<
      [prefix, :tag, String, StringOrNil, 'Expression*'] |
      [prefix, :attr, String, String]                    |
      [prefix, :comment, String]                         |
      [prefix, :text, String]                            |
      [prefix, :cdata, String]
  end

  StringOrNil <<
    String | NilClass
end
