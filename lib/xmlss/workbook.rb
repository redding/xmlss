require 'xmlss/item_set'
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

  end
end
