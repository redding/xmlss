require 'xmlss/item_set'
require 'xmlss/column'
require 'xmlss/row'

module Xmlss
  class Table

    include Xmlss::Xml
    def xml
      { :node => :table,
        :children => [:columns, :rows] }
    end

    attr_accessor :columns, :rows

    def initialize(attrs={})
      self.columns = Xmlss::ItemSet.new(nil, attrs[:columns] || [])
      self.rows = Xmlss::ItemSet.new(nil, attrs[:rows] || [])
    end

  end
end
