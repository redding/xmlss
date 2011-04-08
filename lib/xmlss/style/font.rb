module Xmlss::Style
  class Font
    include Xmlss::Xml
    def xml
      { :node => :font,
        :attributes => [
          :bold, :color, :italic, :size, :shadow,
          :strike_through, :underline, :vertical_align
        ] }
    end

    include Enumeration
    enum :underline, {
      :single => 'Single',
      :double => 'Double',
      :single_accounting => 'SingleAccounting',
      :double_accounting => 'DoubleAccounting'
    }
    enum :alignment, {
      :subscript => 'Subscript',
      :superscript => 'Superscript'
    }
    alias_method :vertical_align, :alignment

    attr_accessor :bold, :color, :italic, :size, :strike_through, :shadow

    def initialize(attrs={})
      self.bold = attrs[:bold] || false
      self.color = attrs[:color]
      self.italic = attrs[:italic] || false
      self.size = attrs[:size]
      self.strike_through = attrs[:strike_through] || false
      self.shadow = attrs[:shadow] || false
      self.underline = attrs[:underline]
      self.alignment = attrs[:alignment]
    end

    def bold?; !!self.bold; end
    def italic?; !!self.italic; end
    def strike_through?; !!self.strike_through; end
    def shadow?; !!self.shadow; end

  end
end
