module Xmlss; end
module Xmlss::Element
  class Row

    def self.writer; :row; end

    attr_accessor :style_id, :height, :auto_fit_height, :hidden

    def initialize(attrs={})
      self.style_id = attrs[:style_id]
      self.height = attrs[:height]
      self.auto_fit_height = attrs[:auto_fit_height] || false
      self.hidden = attrs[:hidden] || false
    end

    def height=(value)
      if value && !value.kind_of?(::Numeric)
        raise ArgumentError, "must specify height as a Numeric"
      end
      @height = value && value < 0 ? nil : value
    end

  end
end
