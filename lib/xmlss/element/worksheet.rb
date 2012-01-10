require 'xmlss/element/column'
require 'xmlss/element/row'
require 'xmlss/element/cell'
require 'xmlss/element/data'

module Xmlss; end
module Xmlss::Element
  class Worksheet

    attr_accessor :name

    def initialize(name, attrs={})
      self.name = name
    end

    def name=(value)
      if value.nil? || value.to_s.empty?
        raise ArgumentError, "'#{name.inspect}' is not a good name for a worksheet"
      end
      @name = sanitized_name(value.to_s)
    end

    private

    def sanitized_name(name)
      # worksheet name cannot contain: /, \, :, ;, * or start with '['
      name.to_s.gsub(/[\/|\\|:|;|\*]/, '').gsub(/^\[/, '')
    end
  end
end
