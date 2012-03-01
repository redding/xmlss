require 'undies'
require 'stringio'

module Xmlss
  class Writer

    class Markup; end

    # Xmlss uses Undies to stream its xml markup
    # The Undies writer is responsible for driving the Undies API to generate
    # the xmlss xml markup for the workbook.
    # Because order doesn't matter when defining style and worksheet elements,
    # the writer has to buffer the style and worksheet markup separately,
    # then put them together according to Xmlss spec to build the final
    # workbook markup.

    XML_NS   = "xmlns"
    SHEET_NS = "ss"
    NS_URI   = "urn:schemas-microsoft-com:office:spreadsheet"
    LB       = "&#13;&#10;"

    def self.attributes(thing, *attrs)
      [*attrs].flatten.inject({}) do |xattrs, a|
        xattrs.merge(if !(xv = self.coerce(thing.send(a))).nil?
          {xmlss_attribute_name(a) => xv.to_s}
        else
          {}
        end)
      end
    end

    def self.xmlss_attribute_name(attr_name)
      "#{SHEET_NS}:#{self.classify(attr_name)}"
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

    attr_reader :styles_markup
    attr_reader :worksheets_markup

    def initialize(output_opts={})
      @opts = output_opts || {}

      @styles_markup     = Markup.new(@opts.merge(:pp_level => 2))
      @worksheets_markup = Markup.new(@opts.merge(:pp_level => 1))
    end

    def write(element)
      self.send(element.class.writer, element)
    end

    def push(template)
      self.send("#{template}_markup").push
    end

    def pop(template)
      self.send("#{template}_markup").pop
    end

    def flush
      # flush the worksheets markup first b/c it may add style elements to
      # the styles markup
      worksheets_markup.flush
      styles_markup.flush
      self
    end

    # return the full workbook markup, combining the buffers to xmlss spec
    def workbook
      self.flush
      "".tap do |markup|
        Undies::Template.new(Undies::Source.new(Proc.new do
          __ "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
          _Workbook(XML_NS => NS_URI, "#{XML_NS}:#{SHEET_NS}" => NS_URI) {
            _Styles {
              __partial styles
            }
            __partial worksheets
          }
        end), {
          :styles => styles_markup.to_s,
          :worksheets => worksheets_markup.to_s
        }, Undies::Output.new(StringIO.new(markup), @opts))
      end.strip
    end

    # workbook style markup directives

    def alignment(alignment)
      styles_markup.template._Alignment(self.class.attributes(alignment, [
        :horizontal, :vertical, :wrap_text, :rotate
      ]))
    end

    def border(border)
      styles_markup.template._Border(self.class.attributes(border, [
        :color, :position, :weight, :line_style
      ]))
    end

    def borders(borders)
      styles_markup.template._Borders
    end

    def font(font)
      styles_markup.template._Font(self.class.attributes(font, [
        :bold, :color, :italic, :size, :shadow, :font_name,
        :strike_through, :underline, :vertical_align
      ]))
    end

    def interior(interior)
      styles_markup.template._Interior(self.class.attributes(interior, [
        :color, :pattern, :pattern_color
      ]))
    end

    def number_format(number_format)
      styles_markup.template._NumberFormat(self.class.attributes(number_format, [
        :format
      ]))
    end

    def protection(protection)
      styles_markup.template._Protection(self.class.attributes(protection, [
        :protect
      ]))
    end

    def style(style)
      styles_markup.template._Style(self.class.attributes(style, [
        :i_d
      ]))
    end

    # workbook element markup directives

    def cell(cell)
      # write the cell markup and push
      worksheets_markup.template._Cell(self.class.attributes(cell, [
        [:index, :style_i_d, :formula, :h_ref, :merge_across, :merge_down]
      ]))
      push(:worksheets)

      # write nested data markup and push
      worksheets_markup.template._Data(self.class.attributes(cell, [
        [:type]
      ]))
      push(:worksheets)

      # write data value
      worksheets_markup.template.__ Undies::Template.
        escape_html(cell.data_xml_value).
        gsub(/(\r|\n)+/, LB)
    end

    def row(row)
      worksheets_markup.template._Row(self.class.attributes(row, [
        [:style_i_d, :height, :auto_fit_height, :hidden]
      ]))
    end

    def column(column)
      worksheets_markup.template._Column(self.class.attributes(column, [
        [:style_i_d, :width, :auto_fit_width, :hidden]
      ]))
    end

    def worksheet(worksheet)
      # write the worksheet markup and push
      worksheets_markup.template._Worksheet(self.class.attributes(worksheet, [
        [:name]
      ]))
      push(:worksheets)

      # write the table container
      worksheets_markup.template._Table
    end

  end



  class Writer::Markup

    attr_reader :template, :push_count, :pop_count

    def initialize(opts={})
      @markup = ""
      @template = Undies::Template.new(Undies::Output.new(StringIO.new(@markup), opts))
      @push_count = 0
      @pop_count  = 0
    end

    def push
      @push_count += 1
      @template.__push
    end

    def pop
      @pop_count += 1
      @template.__pop
    end

    def flush
      while @push_count > @pop_count
        pop
      end
      @template.__flush
    end

    def empty?; @markup.empty?; end

    def to_s
      @markup.to_s.strip
    end

  end

end
