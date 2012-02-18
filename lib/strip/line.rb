class Strip::Line
  attr_reader :cursor
  attr_reader :indentation
  attr_reader :matched
  attr_reader :number
  attr_reader :text
  attr_reader :unstripped

  def initialize(line, number, options = {})
    @unstripped  = line
    @text        = line.strip
    @indentation = line[/^[ \t]*/].gsub(/\t/, ' ' * options.fetch(:tabsize, 2)).size
    @number      = number
    @cursor      = indentation
  end

  def empty?
    text.empty?
  end

  def matched?
    not @matched.nil?
  end

  def prematch
    @prematch ||= unstripped[/^[ \t]*/]
  end

  def postmatch
    @postmatch ||= text.dup
  end

  def expect(pattern)
    pattern = /^#{pattern}/ unless "#{pattern}".start_with? '^'

    unless match? pattern
      raise Strip::SyntaxError.new("Expected #{pattern} after #{prematch.inspect}", self)
    end
  end

  def scan(node, options = {})
    last_matched = matched

    while node === self
      yield matched

      expect options[:after] unless options[:after].nil?
    end

    last_matched != matched
  end

  def match?(pattern)
    match_position = postmatch =~ pattern

    return false if match_position.nil?

    @matched   = $LAST_MATCH_INFO
    @prematch  = $PREMATCH
    @postmatch = $POSTMATCH
    @cursor    += match_position + "#@matched".size

    true
  end

  alias :===  :match?
  alias :to_s :unstripped
end
