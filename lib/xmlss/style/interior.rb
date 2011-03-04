module Xmlss::Style
  class Interior
    include Xmlss::Xml
    def xml
      { :node => :interior,
        :attributes => [:color, :pattern, :pattern_color] }
    end

    PATTERNS = {
      :one => 0,
      :solid => 1,
      :gray75 => 2,
      :gray50 => 3,
      :gray25 => 4,
      :gray125 => 5,
      :gray0625 => 6,
      :horz_stripe => 7,
      :vert_stripe => 8,
      :diag_stripe => 9,
      :diag_cross => 10,
      :reverseDiagStripe => 11,
      :thin_reverse_diag_stripe => 12,
      :thick_diag_cross => 13,
      :thin_diag_cross => 14,
      :thin_horz_stripe => 15,
      :thin_vert_stripe => 16,
      :thin_diag_strip => 17,
      :thin_horz_cross => 18
    }.freeze

    class << self
      def pattern(p)
        PATTERNS[p.to_sym]
      end
    end

    attr_accessor :color, :pattern, :pattern_color

    def initialize(attrs={})
      self.color = attrs[:color]
      self.pattern = attrs[:pattern]
      self.pattern_color = attrs[:pattern_color]
    end

    def pattern=(value)
      @pattern = if value && PATTERNS.has_key?(value.to_sym)
        PATTERNS[value.to_sym]
      elsif PATTERNS.has_value?(value)
        value
      else
        nil
      end
    end

  end
end
