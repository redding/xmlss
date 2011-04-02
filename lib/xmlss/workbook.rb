require 'xmlss/item_set'
require 'xmlss/xml'

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

    def to_xml
      xml_builder do |builder|
        build_node(builder, {
          Xmlss::XML_NS => Xmlss::NS_URI,
          "#{Xmlss::XML_NS}:#{Xmlss::SHEET_NS}" => Xmlss::NS_URI
        })
      end.to_xml.gsub(/#{Xmlss::Data::LB.gsub(/&/, "&amp;")}/, Xmlss::Data::LB)
    end

  end
end
