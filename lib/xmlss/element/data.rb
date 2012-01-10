require 'date'
require 'enumeration'

module Xmlss; end
module Xmlss::Element
  class Data

    LB = "&#13;&#10;"

    include Enumeration
    enum :type, {
      :number => "Number",
      :date_time => "DateTime",
      :boolean => "Boolean",
      :string => "String",
      :error => "Error"
    }

    attr_accessor :value

    def initialize(value="", attrs={})
      self.value = value
      self.type = attrs[:type] if attrs[:type]
    end

    def value=(v)
      if self.type.nil?
        self.type = value_type(v)
      end
      @value = v
    end

    def xml_value
      case self.value
      when ::Date, ::Time, ::DateTime
        self.value.strftime("%Y-%m-%dT%H:%M:%S")
      when ::String, ::Symbol
        self.value.to_s.gsub(/(\r|\n)+/, LB)
      else
        self.value.to_s
      end
    end

    private

    def value_type(v)
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
