require 'xmlss/table'

module Xmlss
  class Worksheet

    include Xmlss::Xml
    def xml
      { :node => :worksheet,
        :attributes => [:name],
        :children => [:table] }
    end

    attr_accessor :name, :table

    def initialize(name, attrs={})
      self.name = name
      self.table = attrs[:table] || Table.new
    end

    def name=(value)
      if value.nil? || value.to_s.empty?
        raise ArgumentError, "'#{name.inspect}' is not a good name for a worksheet"
      end
      @name = sanitized_name(value.to_s)
    end

    def table=(value)
      if value.nil? || !value.kind_of?(Table)
        raise ArgumentError, "you must set table to an actual Table object"
      end
      @table = value
    end

    private

    def sanitized_name(name)
      # worksheet name cannot contain: /, \, :, ;, * or start with '['
      name.to_s.gsub(/[\/|\\|:|;|\*]/, '').gsub(/^\[/, '')
    end
  end
end
