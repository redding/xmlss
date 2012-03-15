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

    [ :data,            # cell
      :type,            # cell
      :index,           # cell
      :style_id,        # cell, row, :column
      :formula,         # cell
      :href,            # cell
      :merge_across,    # cell
      :merge_down,      # cell
      :height,          # row
      :auto_fit_height, # row
      :hidden,          # row, column
      :width,           # column
      :auto_fit_width,  # column
      :name             # worksheet
    ].each do |a|
      define_method(a) do |value|
        if (current_element = self.class.worksheets_stack(self).current)
          current_element.send("#{a}=", value)
        end
      end
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
