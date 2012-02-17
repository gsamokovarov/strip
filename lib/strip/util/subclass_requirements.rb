module Strip::Util::SubclassRequirements
  private

  ALLOWED_SPECIFIERS = [:public, :private, :protected]

  def require_subclass_to_implement(*names)
    options = Hash === names.last ? names.pop : {}

    names.each do |name|
      define_method(name) do
        raise NotImplementedError,
          "Class #{self.class.name} requires implementation for #{name}"
      end
    end

    specifier = options[:as] || :public

    if not ALLOWED_SPECIFIERS.include? specifier
      raise ArgumentError, "Invalid specifier, use one of #{ALLOWED_SPECIFIERS}"
    end

    # Don't waste the extra cycle for the public methods, as define_method
    # creates them public by default.
    names.each { |name| send specifier, name } if specifier != :public 
  end

  alias :require_includer_to_implement :require_subclass_to_implement
end
