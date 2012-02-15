module Strip
  class Engine < Temple::Engine
    # Parse the markup into `[:strip, ...]` expressions.
    use Strip::Parser

    # Compiles `[:strip, ...]` expressions into `[:xml, ...]` ones.
    use Strip::Compiler

    # Generates xml out of `[:xml, ...]` expressions.
    use(:Generator) { Strip::Generator.new }
  end
end
