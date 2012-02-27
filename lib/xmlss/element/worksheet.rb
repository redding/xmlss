require 'xmlss/element/column'
require 'xmlss/element/row'
require 'xmlss/element/cell'

module Xmlss; end
module Xmlss::Element
  class Worksheet

    attr_accessor :name

    def initialize(*args)
      attrs, self.name = [
        args.last.kind_of?(::Hash) ? args.pop : {},
        args.last
      ]
    end

    def name=(value)
      @name = if !value.nil? && !value.to_s.empty?
        sanitized_name(value.to_s)
      else
        ""  # TODO: make sure you don't write a worksheet with no sanitized_name
      end
    end

    def xml_attributes
      [:name]
    end

    private

    def sanitized_name(name)
      # worksheet name cannot contain: /, \, :, ;, * or start with '['
      name.to_s.gsub(/[\/|\\|:|;|\*]/, '').gsub(/^\[/, '')
    end
  end
end
