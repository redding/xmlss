module Xmlss
  class ItemSet < ::Array
    include Xmlss::Xml
    def xml
      { :node => name,
        :children => self }
    end

    attr_accessor :name

    def initialize(name=nil, *args)
      self.name = name
      super *args
    end

  end
end
