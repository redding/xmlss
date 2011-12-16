module Xmlss; end
module Xmlss::Element
  class Cell

    attr_accessor :index, :style_id, :formula, :href, :merge_across, :merge_down
    alias_method :style_i_d, :style_id
    alias_method :h_ref, :href

    def initialize(attrs={}, &build)
      self.index = attrs[:index]
      self.style_id = attrs[:style_id]
      self.formula = attrs[:formula]
      self.href = attrs[:href]
      self.merge_across = attrs[:merge_across] || 0
      self.merge_down = attrs[:merge_down] || 0
    end

    [:index, :merge_across, :merge_down].each do |meth|
      define_method("#{meth}=") do |value|
        if value && !value.kind_of?(::Fixnum)
          raise ArgumentError, "must specify #{meth} as a Fixnum"
        end
        instance_variable_set("@#{meth}", value && value <= 0 ? nil : value)
      end
    end

  end
end
