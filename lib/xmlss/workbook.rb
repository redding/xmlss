require 'xmlss/item_set'
require 'xmlss/xml'
require 'stringio'

require 'xmlss/style/base'
require 'xmlss/worksheet'

module Xmlss
  class Workbook

    include Xmlss::Xml
    def xml
      { :node => :workbook,
        :children => [:styles, :worksheets] }
    end

    attr_accessor :styles, :worksheets

    def initialize(attrs={})
      self.styles = attrs[:styles]
      self.worksheets = attrs[:worksheets]
    end

    def styles=(collection)
      @styles = if (set = collection || []).kind_of?(ItemSet)
        set
      else
        ItemSet.new(:styles, set)
      end
    end

    def worksheets=(collection)
      @worksheets = if (set = collection || []).kind_of?(ItemSet)
        set
      else
        ItemSet.new(nil, set)
      end
    end

    def to_xml(opts={})
      build_xml(opts || {})
    end

  end
end
