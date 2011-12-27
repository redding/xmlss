require 'xmlss/undies_writer'
require 'xmlss/style/base'
require 'xmlss/element/worksheet'

module Xmlss
  class Workbook

    def initialize(opts={}, &build)
      # (don't pollute workbook scope that the build may run in)

      # apply :data options to workbook scope
      data = (opts || {})[:data] || {}
      if (data.keys.map(&:to_s) & self.public_methods.map(&:to_s)).size > 0
        raise ArgumentError, "data conflicts with template public methods."
      end
      metaclass = class << self; self; end
      data.each {|key, value| metaclass.class_eval { define_method(key){value} }}

      # setup the Undies xml writer with any :output options
      @__xmlss_undies_writer = UndiesWriter.new((opts || {})[:output] || {})

      # run any instance workbook build given
      instance_eval(&build) if build
    end

    def to_s
      @__xmlss_undies_writer.workbook
    end

    def to_file(path)
      FileUtils.mkdir_p(File.dirname(path))
      File.open(path, 'w') { |f| f.write self.to_s }
      File.exists?(path) ? path : false
    end

    # Workbook elements API

    def worksheet(*args, &block)
      Element::Worksheet.new(*args).tap do |elem|
        @__xmlss_undies_writer.worksheet(elem, &block)
      end
    end

    def column(*args, &block)
      Element::Column.new(*args).tap do |elem|
        @__xmlss_undies_writer.column(elem, &block)
      end
    end

    def row(*args, &block)
      Element::Row.new(*args).tap do |elem|
        @__xmlss_undies_writer.row(elem, &block)
      end
    end

    def cell(*args, &block)
      Element::Cell.new(*args).tap do |elem|
        @__xmlss_undies_writer.cell(elem, &block)
      end
    end

    def data(*args, &block)
      Element::Data.new(*args).tap do |elem|
        @__xmlss_undies_writer.data(elem, &block)
      end
    end

    # Workbook styles API

    def style(*args, &block)
      Style::Base.new(*args).tap do |style|
        @__xmlss_undies_writer.style(style, &block)
      end
    end

    def alignment(*args, &block)
      Style::Alignment.new(*args).tap do |style|
        @__xmlss_undies_writer.alignment(style, &block)
      end
    end

    def borders(*args, &block)
      @__xmlss_undies_writer.borders(&block)
    end

    def border(*args, &block)
      Style::Border.new(*args).tap do |style|
        @__xmlss_undies_writer.border(style, &block)
      end
    end

    def font(*args, &block)
      Style::Font.new(*args).tap do |style|
        @__xmlss_undies_writer.font(style, &block)
      end
    end

    def interior(*args, &block)
      Style::Interior.new(*args).tap do |style|
        @__xmlss_undies_writer.interior(style, &block)
      end
    end

    def number_format(*args, &block)
      Style::NumberFormat.new(*args).tap do |style|
        @__xmlss_undies_writer.number_format(style, &block)
      end
    end

    def protection(*args, &block)
      Style::Protection.new(*args).tap do |style|
        @__xmlss_undies_writer.protection(style, &block)
      end
    end

  end
end
