module Xmlss::Style
  class Border
    include Xmlss::Xml
    def xml
      { :node => :border,
        :attributes => [:color, :position, :weight, :style] }
    end

    POSITIONS = {
      :left => 0,
      :top => 1,
      :right => 2,
      :bottom => 3
    }.freeze

    WEIGHTS = {
      :hairline => 0,
      :thin => 1,
      :medium => 2,
      :thick => 3
    }.freeze

    STYLES = {
      :none => 0,
      :continuous => 1,
      :dash => 2,
      :dot => 3,
      :dash_dot => 4,
      :dask_dot_dot => 5
    }.freeze

    class << self
      def position(v)
        POSITIONS[v.to_sym]
      end
      def weight(v)
        WEIGHTS[v.to_sym]
      end
      def style(v)
        STYLES[v.to_sym]
      end
    end

    attr_accessor :color, :position, :weight, :style

    def initialize(attrs={})
      self.color = attrs[:color]
      self.position = attrs[:position]
      self.weight = attrs[:weight]
      self.style = attrs[:style]
    end

    def position=(value)
      @position = if value && POSITIONS.has_key?(value.to_sym)
        POSITIONS[value.to_sym]
      elsif POSITIONS.has_value?(value)
        value
      else
        nil
      end
    end

    def weight=(value)
      @weight = if value && WEIGHTS.has_key?(value.to_sym)
        WEIGHTS[value.to_sym]
      elsif WEIGHTS.has_value?(value)
        value
      else
        nil
      end
    end

    def style=(value)
      @style = if value && STYLES.has_key?(value.to_sym)
        STYLES[value.to_sym]
      elsif STYLES.has_value?(value)
        value
      else
        nil
      end
    end

  end
end
