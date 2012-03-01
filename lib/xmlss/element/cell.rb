require 'enumeration'

module Xmlss; end
module Xmlss::Element
  class Cell

    def self.writer; :cell; end

    attr_accessor :index, :style_id, :formula, :href, :merge_across, :merge_down
    alias_method :style_i_d, :style_id
    alias_method :h_ref, :href

    attr_accessor :data

    include Enumeration
    enum :type, {
      :number => "Number",
      :date_time => "DateTime",
      :boolean => "Boolean",
      :string => "String",
      :error => "Error"
    }

    def initialize(*args, &build)
      attrs = args.last.kind_of?(::Hash) ? args.pop : {}

      self.data = args.last.nil? ? (attrs[:data] || "") : args.last
      self.type = attrs[:type] unless attrs[:type].nil?

      self.index = attrs[:index]
      self.style_id = attrs[:style_id]
      self.formula = attrs[:formula]
      self.href = attrs[:href]
      self.merge_across = attrs[:merge_across] || 0
      self.merge_down = attrs[:merge_down] || 0
    end

    def data=(v)
      self.type = data_type(v)
      @data = v
    end

    def data_xml_value
      case self.data
      when ::Date, ::Time, ::DateTime
        self.data.strftime("%Y-%m-%dT%H:%M:%S")
      else
        self.data.to_s
      end
    end

    [:index, :merge_across, :merge_down].each do |meth|
      define_method("#{meth}=") do |value|
        if value && !value.kind_of?(::Fixnum)
          raise ArgumentError, "must specify #{meth} as a Fixnum"
        end
        instance_variable_set("@#{meth}", value && value <= 0 ? nil : value)
      end
    end

    private

    def data_type(v)
      case v
      when ::Numeric
        :number
      when ::Date, ::Time
        :date_time
      when ::TrueClass, ::FalseClass
        :boolean
      when ::String, ::Symbol
        :string
      else
        :string
      end
    end

  end
end
