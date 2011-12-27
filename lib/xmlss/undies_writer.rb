require 'undies'
require 'stringio'

module Xmlss
  class UndiesWriter

    XML_NS   = "xmlns"
    SHEET_NS = "ss"
    NS_URI   = "urn:schemas-microsoft-com:office:spreadsheet"

    # The Undies writer is responsible for driving the Undies API to generate
    # the xmlss xml markup for the workbook.
    # Because order doesn't matter when defining style and worksheet elements,
    # the writer has to buffer the style and worksheet markup separately,
    # then put them together according to Xmlss spec to build the final
    # workbook markup.

    def self.attributes(thing, *attrs)
      [*attrs].flatten.inject({}) do |xattrs, a|
        xattrs.merge(if !(xv = self.coerce(thing.send(a))).nil?
          {"#{SHEET_NS}:#{self.classify(a)}" => xv.to_s}
        else
          {}
        end)
      end
    end

    def self.classify(underscored_string)
      underscored_string.
        to_s.downcase.
        split("_").
        collect{|part| part.capitalize}.
        join('')
    end

    def self.coerce(value)
      if value == true
        1
      elsif ["",false].include?(value)
        # don't include false or empty string values
        nil
      else
        value
      end
    end

    attr_reader :style_markup, :element_markup

    def initialize(output_opts={})
      @opts = output_opts || {}

      # buffer style markup and create a template to write to it
      @style_markup = ""
      styles_out = Undies::Output.new(StringIO.new(@style_markup), @opts.merge({
        :pp_level => 2
      }))
      @styles_t = Undies::Template.new(styles_out)

      # buffer worksheet markup and create a template to write to it
      @element_markup = ""
      worksheets_out = Undies::Output.new(StringIO.new(@element_markup), @opts.merge({
        :pp_level => 1
      }))
      @worksheets_t = Undies::Template.new(worksheets_out)
    end

    def flush
      Undies::Template.flush(@worksheets_t)
      Undies::Template.flush(@styles_t)
      self
    end

    # return the full workbook markup, combining the buffers to xmlss spec
    def workbook
      self.flush
      "".tap do |markup|
        Undies::Template.new(Undies::Source.new(Proc.new do
          __ "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
          _Workbook(XML_NS => NS_URI, "#{XML_NS}:#{SHEET_NS}" => NS_URI) {
            _Styles {
              __ style_markup.to_s
              __
            }
            __ element_markup.to_s
          }
        end), {
          :style_markup => @style_markup,
          :element_markup => @element_markup
        }, Undies::Output.new(StringIO.new(markup), @opts))
      end.strip
    end

    # workbook style markup directives

    def alignment(alignment, &block)
      @styles_t._Alignment(self.class.attributes(alignment, [
        :horizontal, :vertical, :wrap_text, :rotate
      ]))
    end

    def border(border, &block)
      @styles_t._Border(self.class.attributes(border, [
        :color, :position, :weight, :line_style
      ]))
    end

    def borders(&block)
      @styles_t._Borders(&block)
    end

    def font(font, &block)
      @styles_t._Font(self.class.attributes(font, [
        :bold, :color, :italic, :size, :shadow, :font_name,
        :strike_through, :underline, :vertical_align
      ]))
    end

    def interior(interior, &block)
      @styles_t._Interior(self.class.attributes(interior, [
        :color, :pattern, :pattern_color
      ]))
    end

    def number_format(number_format, &block)
      @styles_t._NumberFormat(self.class.attributes(number_format, [
        :format
      ]))
    end

    def protection(protection, &block)
      @styles_t._Protection(self.class.attributes(protection, [
        :protect
      ]))
    end

    def style(style, &block)
      @styles_t._Style(self.class.attributes(style, :i_d), &block)
    end

    # workbook element markup directives

    def data(data, &block)
      @worksheets_t._Data(self.class.attributes(data, :type)) {
        @worksheets_t.__ data.xml_value
      }
    end

    def cell(cell, &block)
      @worksheets_t._Cell(self.class.attributes(cell, [
        :index, :style_i_d, :formula, :h_ref, :merge_across, :merge_down
      ]), &block)
    end

    def row(row, &block)
      @worksheets_t._Row(self.class.attributes(row, [
        :style_i_d, :height, :auto_fit_height, :hidden
      ]), &block)
    end

    def column(column, &block)
      @worksheets_t._Column(self.class.attributes(column, [
        :style_i_d, :width, :auto_fit_width, :hidden
      ]))
    end

    def worksheet(worksheet, &block)
      @worksheets_t._Worksheet(self.class.attributes(worksheet, :name)) {
        @worksheets_t._Table(&block)
      }
    end

  end
end
