module Xmlss;end
module Xmlss::Style; end

require 'enumeration'
require 'xmlss/style/alignment'
require 'xmlss/style/border'
require 'xmlss/style/font'
require 'xmlss/style/interior'
require 'xmlss/style/number_format'
require 'xmlss/style/protection'

module Xmlss::Style
  class Base

    def self.writer; :style; end

    attr_reader :id

    def initialize(id)
      raise ArgumentError, "please choose an id for the style" if id.nil?
      @id = id.to_s
    end

  end
end
