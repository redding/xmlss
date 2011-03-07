require 'xmlss/data'

module Xmlss
  class Cell

    include Xmlss::Xml
    def xml
      { :node => :cell,
        :attributes => [:style_i_d, :formula, :h_ref, :merge_across, :merge_down],
        :children => [:data] }
    end

    attr_accessor :style_id, :formula, :href, :merge_across, :merge_down
    attr_accessor :data
    alias_method :style_i_d, :style_id
    alias_method :h_ref, :href

    def initialize(attrs={})
      self.style_id = attrs[:style_id]
      self.formula = attrs[:formula]
      self.href = attrs[:href]
      self.merge_across = attrs[:merge_across] || 0
      self.merge_down = attrs[:merge_down] || 0
      self.data = attrs[:data]
    end

    [:merge_across, :merge_down].each do |meth|
      define_method("#{meth}=") do |value|
        if value && !value.kind_of?(::Fixnum)
          raise ArgumentError, "must specify #{meth} as a Fixnum"
        end
        instance_variable_set("@#{meth}", value && value <= 0 ? nil : value)
      end
    end

  end
end
