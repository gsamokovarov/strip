require 'set'
require 'English'

require 'temple'
require 'nokogiri'

require 'strip/error'
require 'strip/util'
require 'strip/base'
require 'strip/generator'
require 'strip/node'
require 'strip/nodes'
require 'strip/parser'
require 'strip/compiler'
require 'strip/engine'
require 'strip/version'

module Strip
  def self.version
    [Version::Major, Version::Minor, Version::Patch] * '.'
  end
end
