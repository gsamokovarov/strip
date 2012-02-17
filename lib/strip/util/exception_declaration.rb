module Strip::Util::ExceptionDeclaration
  private

  def exception(name, options = {}, &block)
    base = options[:extends] || StandardError
    base = const_get base if Symbol === base
    const_set name, Class.new(base, &block)
  end
end
