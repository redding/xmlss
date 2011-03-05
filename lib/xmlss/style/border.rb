module Xmlss::Style
  class Border
    include Xmlss::Xml
    def xml
      { :node => :border,
        :attributes => [:color, :position, :weight, :style] }
    end

    include Xmlss::Enum
    enum :position, {
      :left => 0,
      :top => 1,
      :right => 2,
      :bottom => 3
    }
    enum :weight, {
      :hairline => 0,
      :thin => 1,
      :medium => 2,
      :thick => 3
    }
    enum :style, {
      :none => 0,
      :continuous => 1,
      :dash => 2,
      :dot => 3,
      :dash_dot => 4,
      :dask_dot_dot => 5
    }

    attr_accessor :color

    def initialize(attrs={})
      self.color = attrs[:color]
      self.position = attrs[:position]
      self.weight = attrs[:weight]
      self.style = attrs[:style]
    end

  end
end
