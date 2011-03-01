module Xmlss::Style
  class Protection

    attr_accessor :protect

    def initialize(attrs={})
      @protect = attrs[:protect] || false
    end

    def protected?; !!@protect; end

  end
end
