require 'xmlss/writer'
require 'xmlss/style/base'
require 'xmlss/element/worksheet'

module Xmlss
  class Workbook

    def self.writer(workbook)
      workbook.instance_variable_get("@__xmlss_undies_writer")
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
      @__xmlss_undies_writer = writer

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
      Style::Base.new(*args).tap do |style|
        self.class.writer(self).style(style, &block)
      end
    end

    def alignment(*args, &block)
      Style::Alignment.new(*args).tap do |style|
        self.class.writer(self).alignment(style, &block)
      end
    end

    def borders(*args, &block)
      self.class.writer(self).borders(&block)
    end

    def border(*args, &block)
      Style::Border.new(*args).tap do |style|
        self.class.writer(self).border(style, &block)
      end
    end

    def font(*args, &block)
      Style::Font.new(*args).tap do |style|
        self.class.writer(self).font(style, &block)
      end
    end

    def interior(*args, &block)
      Style::Interior.new(*args).tap do |style|
        self.class.writer(self).interior(style, &block)
      end
    end

    def number_format(*args, &block)
      Style::NumberFormat.new(*args).tap do |style|
        self.class.writer(self).number_format(style, &block)
      end
    end

    def protection(*args, &block)
      Style::Protection.new(*args).tap do |style|
        self.class.writer(self).protection(style, &block)
      end
    end

    # Workbook elements API

    def worksheet(*args, &block)
      Element::Worksheet.new(*args).tap do |elem|
        self.class.writer(self).worksheet(elem, &block)
      end
    end

    def column(*args, &block)
      Element::Column.new(*args).tap do |elem|
        self.class.writer(self).column(elem, &block)
      end
    end

    def row(*args, &block)
      Element::Row.new(*args).tap do |elem|
        self.class.writer(self).row(elem, &block)
      end
    end

    def cell(*args, &block)
      Element::Cell.new(*args).tap do |elem|
        self.class.writer(self).cell(elem, &block)
      end
    end

    def data(*args, &block)
      Element::Data.new(*args).tap do |elem|
        self.class.writer(self).data(elem, &block)
      end
    end

    # Workbook element attributes API

    [ :type,            # data
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
      define_method(a) do |*args|
        self.class.writer(self).current.send(a, *args)
      end
    end

  end
end
