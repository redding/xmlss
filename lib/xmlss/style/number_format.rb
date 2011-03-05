module Xmlss::Style
  class NumberFormat
    include Xmlss::Xml
    def xml
      { :node => :number_format,
        :attributes => [:format] }
    end

    include Xmlss::Enum
    enum :format, {
      :general => "General",
      :general_number => "General Number",
      :general_date => "General Date",
      :long_date => "Long Date",
      :medium_date => "Medium Date",
      :short_date => "Short Date",
      :long_time => "Long Time",
      :medium_time => "Medium Time",
      :short_time => "Short Time",
      :currency => "Currency",
      :euro_currency => "Euro Currency",
      :fixed => "Fixed",
      :standard => "Standard",
      :percent => "Percent",
      :scientific => "Scientific",
      :yes_no => "Yes/No",
      :true_false => "True/False",
      :on_off => "On/Off"
    }

    def initialize(attrs={})
      self.format = attrs[:format]
    end

  end
end
