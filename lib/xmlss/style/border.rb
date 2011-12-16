require 'xmlss/style/base'

module Xmlss::Style
  class Border

    include Enumeration

    enum :position, {
      :left => "Left",
      :top => "Top",
      :right => "Right",
      :bottom => "Bottom",
      :diagonal_left => "DiagonalLeft",
      :diagonal_right => "DiagonalRight"
    }

    enum :weight, {
      :hairline => 0,
      :thin => 1,
      :medium => 2,
      :thick => 3
    }

    enum :line_style, {
      :none => "None",
      :continuous => "Continuous",
      :dash => "Dash",
      :dot => "Dot",
      :dash_dot => "DashDot",
      :dash_dot_dot => "DashDotDot"
    }

    attr_accessor :color

    def initialize(attrs={})
      self.color = attrs[:color]
      self.position = attrs[:position]
      self.weight = attrs[:weight] || :thin
      self.line_style = attrs[:line_style] || :continuous
    end

  end
end
