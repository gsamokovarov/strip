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

  def scan(node)
    patterns = node.respond_to?(:patterns) ? node.patterns : [node]

    last_matched = matched

    node.patterns.each do |pattern|
      next unless match? pattern

      begin
        yield matched
      end while match? pattern
    end

    last_matched != matched
  end

  def match?(pattern)
    match_position = postmatch =~ pattern

    return false if match_position.nil?

    @matched   = $LAST_MATCH_INFO
    @prematch  = $PREMATCH
    @postmatch = $POSTMATCH
    @cursor    = match_position + "#@matched".size

    true
  end

  alias :=== :match?
end
