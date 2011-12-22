require 'xmlss/style/base'

module Xmlss::Style
  class Protection

    attr_accessor :protect

    def initialize(value=nil)
      self.protect = value
    end

    def protected?; !!self.protect; end

  end
end
