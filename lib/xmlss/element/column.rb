module Xmlss; end
module Xmlss::Element
  class Column

    attr_accessor :style_id, :width, :auto_fit_width, :hidden
    alias_method :style_i_d, :style_id

    def initialize(attrs={})
      self.style_id = attrs[:style_id]
      self.width = attrs[:width]
      self.auto_fit_width = attrs[:auto_fit_width] || false
      self.hidden = attrs[:hidden] || false
    end

    def width=(value)
      if value && !value.kind_of?(::Numeric)
        raise ArgumentError, "must specify width as a Numeric"
      end
      @width = value && value < 0 ? nil : value
    end

    def xml_attributes
      [:style_i_d, :width, :auto_fit_width, :hidden]
    end

  end
end
