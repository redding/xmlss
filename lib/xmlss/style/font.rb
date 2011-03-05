module Xmlss::Style
  class Font
    include Xmlss::Xml
    def xml
      { :node => :font,
        :attributes => [
          :bold, :color, :name, :italic, :size,
          :strike_through, :underline, :alignment
        ] }
    end

    include Xmlss::Enum
    enum :underline, {
      :none => 0,
      :single => 1,
      :double => 2
    }
    enum :alignment, {
      :none => 0,
      :subscript => 1,
      :superscript => 2
    }

    attr_accessor :bold, :color, :name, :italic, :size, :strike_through

    def initialize(attrs={})
      self.bold = attrs[:bold] || false
      self.color = attrs[:color]
      self.name = attrs[:name]
      self.italic = attrs[:italic] || false
      self.size = attrs[:size]
      self.strike_through = attrs[:strike_through] || false
      self.underline = attrs[:underline]
      self.alignment = attrs[:alignment]
    end

    def bold?; !!self.bold; end
    def italic?; !!self.italic; end
    def strike_through?; !!self.strike_through; end

  end
end
