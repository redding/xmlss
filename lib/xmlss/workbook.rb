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

    def initialize
      self.styles = Xmlss::ItemSet.new(:styles)
      self.worksheets = Xmlss::ItemSet.new
    end

    def to_xml
      xml_builder do |builder|
        build_node(builder, {
          Xmlss::XML_NS => Xmlss::NS_URI,
          "#{Xmlss::XML_NS}:#{Xmlss::SHEET_NS}" => Xmlss::NS_URI
        })
      end.to_xml
    end

  end
end
