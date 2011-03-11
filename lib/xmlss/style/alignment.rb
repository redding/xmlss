module Xmlss::Style
  class Alignment
    include Xmlss::Xml
    def xml
      { :node => :alignment,
        :attributes => [:horizontal, :vertical, :wrap_text, :rotate] }
    end

    include Xmlss::Enum
    enum :horizontal, {
      :automatic => "Automatic",
      :left => "Left",
      :center => "Center",
      :right => "Right"
    }
    enum :vertical, {
      :automatic => "Automatic",
      :top => "Top",
      :center => "Center",
      :bottom => "Bottom"
    }

    attr_accessor :wrap_text, :rotate

    def initialize(attrs={})
      self.wrap_text = attrs[:wrap_text] || false
      self.rotate = attrs[:rotate]
      self.horizontal = attrs[:horizontal]
      self.vertical = attrs[:vertical]
    end

    def wrap_text?; !!self.wrap_text; end

    def rotate=(value)
      @rotate = if value.kind_of?(::Numeric)
        if value <= 90 && value >= -90
          value.round
        else
          nil
        end
      else
        nil
      end
    end

  end
end
