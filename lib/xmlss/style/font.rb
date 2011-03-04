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

    UNDERLINES = {
      :none => 0,
      :single => 1,
      :double => 2
    }.freeze

    ALIGNMENTS = {
      :none => 0,
      :subscript => 1,
      :superscript => 2
    }.freeze

    class << self
      def underline(u)
        UNDERLINES[u.to_sym]
      end
      def alignment(a)
        ALIGNMENTS[a.to_sym]
      end
    end

    attr_accessor :bold, :color, :name, :italic, :size, :strike_through
    attr_accessor :underline, :alignment

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

    def underline=(value)
      @underline = if value && UNDERLINES.has_key?(value.to_sym)
        UNDERLINES[value.to_sym]
      elsif UNDERLINES.has_value?(value)
        value
      else
        nil
      end
    end

    def alignment=(value)
      @alignment = if value && ALIGNMENTS.has_key?(value.to_sym)
        ALIGNMENTS[value.to_sym]
      elsif ALIGNMENTS.has_value?(value)
        value
      else
        nil
      end
    end

  end
end
