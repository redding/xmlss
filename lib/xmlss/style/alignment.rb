module Xmlss::Style
  class Alignment
    include Xmlss::Xml
    def xml
      { :node => :alignment,
        :attributes => [:horizontal, :vertical, :wrap_text] }
    end

    include Xmlss::Enum
    enum :horizontal, {
      :automatic => 0,
      :left => 1,
      :center => 2,
      :right => 3
    }
    enum :vertical, {
      :automatic => 0,
      :top => 1,
      :center => 2,
      :bottom => 3
    }

    attr_accessor :wrap_text

    def initialize(attrs={})
      self.wrap_text = attrs[:wrap_text] || false
      self.horizontal = attrs[:horizontal]
      self.vertical = attrs[:vertical]
    end

    def wrap_text?; !!self.wrap_text; end

  end
end
