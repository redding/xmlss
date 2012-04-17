require 'xmlss/writer'
require 'xmlss/element_stack'
require 'xmlss/style/base'
require 'xmlss/element/worksheet'

module Xmlss
  class Workbook

    def self.writer(workbook)
      workbook.instance_variable_get("@__xmlss_writer")
    end

    def self.styles_stack(workbook)
      workbook.instance_variable_get("@__xmlss_styles_stack")
    end

    def self.worksheets_stack(workbook)
      workbook.instance_variable_get("@__xmlss_worksheets_stack")
    end

    def initialize(writer, data={}, &build)
      # (don't pollute workbook scope that the build may run in)

      # apply :data options to workbook scope
      if (data.keys.map(&:to_s) & self.public_methods.map(&:to_s)).size > 0
        raise ArgumentError, "data conflicts with workbook public methods."
      end
      metaclass = class << self; self; end
      data.each {|key, value| metaclass.class_eval { define_method(key){value} }}

      # setup the Undies xml writer with any :output options
      @__xmlss_writer           = writer
      @__xmlss_styles_stack     = ElementStack.new(writer, :styles)
      @__xmlss_worksheets_stack = ElementStack.new(writer, :worksheets)

      # run any instance workbook build given
      instance_eval(&build) if build
    end

    def to_s
      self.class.writer(self).workbook
    end

    def to_file(path)
      FileUtils.mkdir_p(File.dirname(path))
      File.open(path, 'w') { |f| f.write self.to_s }
      File.exists?(path) ? path : false
    end

    # Workbook styles API

    def style(*args, &block)
      self.class.styles_stack(self).using(Style::Base.new(*args), &block)
    end

    def alignment(*args, &block)
      self.class.styles_stack(self).using(Style::Alignment.new(*args), &block)
    end

    def borders(*args, &block)
      self.class.styles_stack(self).using(Style::Borders.new(*args), &block)
    end

    def border(*args, &block)
      self.class.styles_stack(self).using(Style::Border.new(*args), &block)
    end

    def font(*args, &block)
      self.class.styles_stack(self).using(Style::Font.new(*args), &block)
    end

    def interior(*args, &block)
      self.class.styles_stack(self).using(Style::Interior.new(*args), &block)
    end

    def number_format(*args, &block)
      self.class.styles_stack(self).using(Style::NumberFormat.new(*args), &block)
    end

    def protection(*args, &block)
      self.class.styles_stack(self).using(Style::Protection.new(*args), &block)
    end

    # Workbook elements API

    def worksheet(*args, &block)
      self.class.worksheets_stack(self).using(Element::Worksheet.new(*args), &block)
    end

    def column(*args, &block)
      self.class.worksheets_stack(self).using(Element::Column.new(*args), &block)
    end

    def row(*args, &block)
      self.class.worksheets_stack(self).using(Element::Row.new(*args), &block)
    end

    def cell(*args, &block)
      self.class.worksheets_stack(self).using(Element::Cell.new(*args), &block)
    end

    # Workbook element attributes API

    def data(value)  # cell
      self.class.worksheets_stack(self).current.data = value
    end

    def type(value)  # cell
      self.class.worksheets_stack(self).current.type = value
    end

    def index(value)  # cell
      self.class.worksheets_stack(self).current.index = value
    end

    def style_id(value)  # cell, row, column
      self.class.worksheets_stack(self).current.style_id = value
    end

    def formula(value)  # cell
      self.class.worksheets_stack(self).current.formula = value
    end

    def href(value)  # cell
      self.class.worksheets_stack(self).current.href = value
    end

    def merge_across(value)  # cell
      self.class.worksheets_stack(self).current.merge_across = value
    end

    def merge_down(value)  # cell
      self.class.worksheets_stack(self).current.merge_down = value
    end

    def height(value)  # row
      self.class.worksheets_stack(self).current.height = value
    end

    def auto_fit_height(value)  # row
      self.class.worksheets_stack(self).current.auto_fit_height = value
    end

    def hidden(value)  # row, column
      self.class.worksheets_stack(self).current.hidden = value
    end

    def width(value)  # column
      self.class.worksheets_stack(self).current.height = value
    end

    def auto_fit_width(value)  # column
      self.class.worksheets_stack(self).current.auto_fit_width = value
    end

    def name(value)  # worksheet
      self.class.worksheets_stack(self).current.name = value
    end

    # overriding to make less noisy
    def to_str(*args)
      "#<Xmlss::Workbook:#{self.object_id} " +
      "current_element=#{self.class.worksheets_stack(self).current.inspect}, " +
      "current_style=#{self.class.styles_stack(self).current.inspect}>"
    end
    alias_method :inspect, :to_str

  end
end
