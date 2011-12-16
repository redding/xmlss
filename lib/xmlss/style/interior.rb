require 'xmlss/style/base'

module Xmlss::Style
  class Interior

    include Enumeration
    enum :pattern, {
      :none => "None",
      :solid => "Solid",
      :gray75 => "Gray75",
      :gray50 => "Gray50",
      :gray25 => "Gray25",
      :gray125 => "Gray125",
      :gray0625 => "Gray0625",
      :horz_stripe => "HorzStripe",
      :vert_stripe => "VertStripe",
      :reverse_diag_stripe => "ReverseDiagStripe",
      :diag_stripe => "DiagStripe",
      :diag_cross => "DiagCross",
      :thick_diag_cross => "ThickDiagCross",
      :thin_horz_stripe => "ThinHorzStripe",
      :thin_vert_stripe => "ThinVertStripe",
      :thin_reverse_diag_stripe => "ThinReverseDiagStripe",
      :thin_diag_stripe => "ThineDiagStripe",
      :thin_horz_cross => "ThinHorzCross",
      :thin_diag_cross => "ThinDiagCross"
    }

    attr_accessor :color, :pattern_color

    def initialize(attrs={})
      self.color = attrs[:color]
      self.pattern = attrs[:pattern]
      self.pattern_color = attrs[:pattern_color]
    end

  end
end
