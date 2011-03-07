require 'xmlss/item_set'
require 'xmlss/cell'

module Xmlss
  class Row

    include Xmlss::Xml
    def xml
      { :node => :row,
        :attributes => [:style_i_d, :height, :auto_fit_height, :hidden],
        :children => [:cells] }
    end

    attr_accessor :style_id, :height, :auto_fit_height, :hidden
    attr_accessor :cells
    alias_method :style_i_d, :style_id

    def initialize(attrs={})
      self.style_id = attrs[:style_id]
      self.height = attrs[:height]
      self.auto_fit_height = attrs[:auto_fit_height] || false
      self.hidden = attrs[:hidden] || false
      self.cells = Xmlss::ItemSet.new
    end

    def height=(value)
      if value && !value.kind_of?(::Numeric)
        raise ArgumentError, "must specify height as a Numeric"
      end
      @height = value && value < 0 ? nil : value
    end

  end
end
