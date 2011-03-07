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
      self.columns = Xmlss::ItemSet.new
      self.rows = Xmlss::ItemSet.new
    end

  end
end
