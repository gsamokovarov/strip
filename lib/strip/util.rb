module Strip::Util
  autoload :SubclassRequirements, 'strip/util/subclass_requirements'
  autoload :ExceptionDeclaration, 'strip/util/exception_declaration'

  class << self
    def extended(base)
      [SubclassRequirements, ExceptionDeclaration].each do |mod|
        base.extend mod
      end
    end
  end

  module_function

  def constantize(name)
    name.to_s.gsub(/-/, '_').split.map(&:capitalize).join
  end
end
