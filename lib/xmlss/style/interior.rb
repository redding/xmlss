module Xmlss::Style
  class Interior
    include Xmlss::Xml
    def xml
      { :node => :interior,
        :attributes => [:color, :pattern, :pattern_color] }
    end

    include Xmlss::Enum
    enum :pattern, {
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
    }

    attr_accessor :color, :pattern_color

    def initialize(attrs={})
      self.color = attrs[:color]
      self.pattern = attrs[:pattern]
      self.pattern_color = attrs[:pattern_color]
    end

  end
end
