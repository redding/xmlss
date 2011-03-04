module Xmlss::Style
  class Alignment
    include Xmlss::Xml
    def xml
      { :node => :alignment,
        :attributes => [:horizontal, :vertical, :wrap_text] }
    end

    HORIZONTALS = {
      :automatic => 0,
      :left => 1,
      :center => 2,
      :right => 3
    }.freeze

    VERTICALS = {
      :automatic => 0,
      :top => 1,
      :center => 2,
      :bottom => 3
    }.freeze

    class << self
      def horizontal(v)
        HORIZONTALS[v.to_sym]
      end
      def vertical(v)
        VERTICALS[v.to_sym]
      end
    end

    attr_accessor :horizontal, :vertical, :wrap_text

    def initialize(attrs={})
      self.wrap_text = attrs[:wrap_text] || false
      self.horizontal = attrs[:horizontal]
      self.vertical = attrs[:vertical]
    end

    def wrap_text?; !!self.wrap_text; end

    def horizontal=(value)
      @horizontal = if value && HORIZONTALS.has_key?(value.to_sym)
        HORIZONTALS[value.to_sym]
      elsif HORIZONTALS.has_value?(value)
        value
      else
        nil
      end
    end

    def vertical=(value)
      @vertical = if value && VERTICALS.has_key?(value.to_sym)
        VERTICALS[value.to_sym]
      elsif VERTICALS.has_value?(value)
        value
      else
        nil
      end
    end

  end
end
