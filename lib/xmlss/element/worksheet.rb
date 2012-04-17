require 'xmlss/element/column'
require 'xmlss/element/row'
require 'xmlss/element/cell'

module Xmlss; end
module Xmlss::Element
  class Worksheet

    def self.writer; :worksheet; end

    attr_accessor :name

    def initialize(*args)
      attrs, self.name = [
        args.last.kind_of?(::Hash) ? args.pop : {},
        args.last
      ]
    end

    def name=(value)
      if value.to_s.length > 31
        raise ArgumentError, "worksheet names must be less than 32 characters long"
      end
      @name = if !value.nil? && !value.to_s.empty?
        sanitized_name(value.to_s)
      else
        ""
      end
    end

    private

    def sanitized_name(name)
      # worksheet name cannot contain: /, \, :, ;, * or start with '['
      name.to_s.gsub(/[\/|\\|:|;|\*]/, '').gsub(/^\[/, '')
    end
  end
end
