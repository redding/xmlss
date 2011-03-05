module Xmlss
  class Data

    include Xmlss::Xml
    def xml
      { :node => :data,
        :attributes => [:type],
        :value => :value }
    end

    include Xmlss::Enum
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

    private

    def value_type(v)
      case v
      when ::Numeric
        :number
      when ::Date, ::Time
        :date_time
      when true, false
        :boolean
      when ::String, ::Symbol
        :string
      else
        :string
      end
    end

  end
end
