require 'xmlss/style/base'

module Xmlss::Style
  class NumberFormat

    attr_accessor :format

    def initialize(attrs={})
      self.format = attrs[:format]
    end

    def format=(value)
      @format = (value && value.respond_to?(:to_s) ? value.to_s : nil)
    end

  end
end
