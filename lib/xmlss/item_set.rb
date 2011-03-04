module Xmlss
  class ItemSet < ::Array
    include Xmlss::Xml

    attr_accessor :name

    def initialize(name=nil, *args)
      self.name = name
      super *args
    end

    def xml
      { :node => name,
        :children => self }
    end

  end
end
