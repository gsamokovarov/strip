$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))

%w{strip rspec}.each { |gem| require gem }

module Support
  def deindent(text, options = {})
    text.lines.map { |line| line.gsub %r<^#{' ' * (options[:by] || 6)}>, '' }.join
  end

  def xml(options = {}, &block)
    Nokogiri::XML::Builder.new(options, &block).to_xml
  end

  def generate(expression)
    Strip::Generator.new.call expression
  end

  def parse(markup)
    Strip::Parser.new.call markup
  end

  def create(kind, &block)
    fail "Can only create :class or :module" unless [:class, :module].include? kind
    { :class => Class, :module => Module }[kind].new(&block)
  end
end

RSpec.configure do |config|
  config.include Support
  config.fail_fast = true
end
