require 'xmlss/style/base'

module Xmlss::Style
  class Protection

    attr_accessor :protect

    def initialize(attrs={})
      self.protect = attrs[:protect] || false
    end

    def protected?; !!self.protect; end

  end
end
