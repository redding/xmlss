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

    def initialize(name)
      if name.nil? || name.empty?
        raise ArgumentError, "'#{name.inspect}' is not a good name for a worksheet"
      end
      self.name = sanitized_name(name)
      self.table = Table.new
    end

    def table=(value)
      if value.nil? || !value.kind_of?(Table)
        raise ArgumentError, "you must set table to an actual Table object"
      end
      @table = value
    end

    private

    def sanitized_name(value)
      # worksheet name cannot contain: /, \, ?, *, [, ]
      value.to_s.gsub(/[\/|\\|\?|\*|\[|\]]/, '')
    end
  end
end
