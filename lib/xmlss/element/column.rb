module Xmlss; end
module Xmlss::Element
  class Column

    def self.writer; :column; end

    attr_accessor :style_id, :width, :auto_fit_width, :hidden

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

    def autofit;         self.auto_fit_width;         end
    def autofit=(value); self.auto_fit_width = value; end

    def autofit?; !!self.autofit; end
    def hidden?;  !!self.hidden;  end

  end
end
