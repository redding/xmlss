require 'xmlss/item_set'
require 'xmlss/style/alignment'
require 'xmlss/style/border'
require 'xmlss/style/font'
require 'xmlss/style/interior'
require 'xmlss/style/number_format'
require 'xmlss/style/protection'

module Xmlss::Style
  class Base
    include Xmlss::Xml
    def xml
      { :node => :style,
        :attributes => [:i_d],
        :children => [
          :alignment, :borders, :font, :interior, :number_format, :protection
        ]}
    end

    attr_reader :id, :borders
    alias_method :i_d, :id
    attr_writer :alignment, :font, :interior, :number_format, :protection

    def initialize(id, &block)
      raise ArgumentError, "please choose an id for the style" if id.nil?
      @id = id.to_s
      self.borders = Xmlss::ItemSet.new(:borders)
      instance_eval(&block) if block
    end

    def borders=(value)
      if !value.kind_of? Xmlss::ItemSet
        raise ArgumentError, "must set borders to an Xmlss::ItemSet value"
      end
      @borders = value
    end

    def border(opts = nil)
      valid_attrs?(opts) do |attrs|
        @borders << Border.new(attrs)
      end
    end

    [:alignment, :font, :interior, :number_format, :protection].each do |meth|
      define_method(meth) do |*args|
        valid_attrs?(args.first) do |attrs|
          instance_variable_set("@#{meth}", klass(meth).new(attrs))
        end
        instance_variable_get("@#{meth}")
      end
    end

    protected

    def valid_attrs?(attrs)
      yield attrs if block_given? && attrs && attrs.kind_of?(::Hash)
    end

    def klass(method_name)
      Xmlss::Style.const_get(Xmlss.classify(method_name))
    end
  end
end
