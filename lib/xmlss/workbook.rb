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
      @__xmlss_undies_writer.worksheet(Element::Worksheet.new(*args), &block)
    end

    def column(*args, &block)
      @__xmlss_undies_writer.column(Element::Column.new(*args), &block)
    end

    def row(*args, &block)
      @__xmlss_undies_writer.row(Element::Row.new(*args), &block)
    end

    def cell(*args, &block)
      @__xmlss_undies_writer.cell(Element::Cell.new(*args), &block)
    end

    def data(*args, &block)
      @__xmlss_undies_writer.data(Element::Data.new(*args), &block)
    end

    # Workbook styles API

    def style(*args, &block)
      @__xmlss_undies_writer.style(Style::Base.new(*args), &block)
    end

    def alignment(*args, &block)
      @__xmlss_undies_writer.alignment(Style::Alignment.new(*args), &block)
    end

    def borders(*args, &block)
      @__xmlss_undies_writer.borders(&block)
    end

    def border(*args, &block)
      @__xmlss_undies_writer.border(Style::Border.new(*args), &block)
    end

    def font(*args, &block)
      @__xmlss_undies_writer.font(Style::Font.new(*args), &block)
    end

    def interior(*args, &block)
      @__xmlss_undies_writer.interior(Style::Interior.new(*args), &block)
    end

    def number_format(*args, &block)
      @__xmlss_undies_writer.number_format(Style::NumberFormat.new(*args), &block)
    end

    def protection(*args, &block)
      @__xmlss_undies_writer.protection(Style::Protection.new(*args), &block)
    end

  end
end
