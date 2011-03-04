module Xmlss::Style
  class Protection
    include Xmlss::Xml
    def xml
      { :node => :protection,
        :attributes => [:protect] }
    end

    attr_accessor :protect

    def initialize(attrs={})
      self.protect = attrs[:protect] || false
    end

    def protected?; !!self.protect; end

  end
end
