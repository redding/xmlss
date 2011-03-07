module Xmlss::Style
  class NumberFormat
    include Xmlss::Xml
    def xml
      { :node => :number_format,
        :attributes => [:format] }
    end

    attr_accessor :format

    def initialize(attrs={})
      self.format = attrs[:format]
    end

    def format=(value)
      @format = (value && value.respond_to?(:to_s) ? value.to_s : nil)
    end

  end
end
