require 'xmlss/style/alignment'
require 'xmlss/style/border'
require 'xmlss/style/font'
require 'xmlss/style/interior'
require 'xmlss/style/number_format'
require 'xmlss/style/protection'

module Xmlss::Style
  class Base

    attr_reader :id
    attr_accessor :borders
    attr_writer :alignment, :font, :interior, :number_format, :protection

    def initialize(id, &block)
      raise ArgumentError, "please choose an id for the style" if id.nil?
      @id = id.to_s
      self.borders = []
      instance_eval(&block) if block
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
      Xmlss::Style.
        const_get(method_name.
          to_s.downcase.
          split("_").collect{|part| part.capitalize}.
          join('')
        )
    end
  end
end
