require 'enumeration'

module Xmlss; end
module Xmlss::Element
  class Cell

    def self.writer; :cell; end

    attr_accessor :index, :style_id, :formula, :href, :merge_across, :merge_down

    attr_accessor :data

    include Enumeration
    enum :type, {
      :number => "Number",
      :date_time => "DateTime",
      :boolean => "Boolean",
      :string => "String",
      :error => "Error"
    }

    def initialize(*args)
      attrs = args.last.kind_of?(::Hash) ? args.pop : {}

      self.data = [args.last, attrs.delete(:data), ''].reject{|v| v.nil?}.first
      self.merge_across = attrs.delete(:merge_across) || 0
      self.merge_down = attrs.delete(:merge_down) || 0

      attrs.keys.each { |k| self.send("#{k}=", attrs[k]) }
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

    def index=(value)
      if value && !value.kind_of?(::Fixnum)
        raise ArgumentError, "must specify `index` as a Fixnum"
      end
      @index = (value && value <= 0 ? nil : value)
    end

    def merge_across=(value)
      if value && !value.kind_of?(::Fixnum)
        raise ArgumentError, "must specify `merge_across` as a Fixnum"
      end
      @merge_across = (value && value <= 0 ? nil : value)
    end

    def merge_down=(value)
      if value && !value.kind_of?(::Fixnum)
        raise ArgumentError, "must specify `merge_down` as a Fixnum"
      end
      @merge_down = (value && value <= 0 ? nil : value)
    end

    private

    def data_type(v)
      if v.kind_of?(::String) || v.kind_of?(::Symbol)
        :string
      elsif v.kind_of?(::Numeric)
        :number
      elsif v.kind_of?(::Date) || v.kind_of?(::Time)
        :date_time
      elsif v.kind_of?(::TrueClass) || v.kind_of?(::FalseClass)
        :boolean
      else
        :string
      end
    end

  end
end
