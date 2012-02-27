require 'undies'
require 'stringio'

module Xmlss
  class Writer

    class ElementStack < ::Array; end

    # Xmlss uses Undies to writer stream its xml markup

    XML_NS   = "xmlns"
    SHEET_NS = "ss"
    NS_URI   = "urn:schemas-microsoft-com:office:spreadsheet"
    LB       = "&#13;&#10;"

    # The Undies writer is responsible for driving the Undies API to generate
    # the xmlss xml markup for the workbook.
    # Because order doesn't matter when defining style and worksheet elements,
    # the writer has to buffer the style and worksheet markup separately,
    # then put them together according to Xmlss spec to build the final
    # workbook markup.

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

    attr_reader :style_markup, :element_markup

    def initialize(output_opts={})
      @opts = output_opts || {}
      @element_stack = ElementStack.new

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
          __ "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
          _Workbook(XML_NS => NS_URI, "#{XML_NS}:#{SHEET_NS}" => NS_URI) {
            _Styles {
              __partial style_markup.to_s.strip
            }
            __partial element_markup.to_s.strip
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

    # def data(data, &block)
    #   build = Proc.new do
    #     @element_stack.using(data, &block)
    #     @worksheets_t.__ Undies::Template.
    #       escape_html(data.xml_value).
    #       gsub(/(\r|\n)+/, LB)
    #   end
    #   xml_attrs = self.class.attributes(data, data.xml_attributes)
    #   @worksheets_t._Data(xml_attrs, &build)
    # end

    def cell(cell, &block)
      build = Proc.new do
        @element_stack.using(cell, &block)

        data_xml_attrs = self.class.attributes(cell, cell.data_xml_attributes)
        @worksheets_t._Data(data_xml_attrs) {
          @worksheets_t.__ Undies::Template.
            escape_html(cell.data_xml_value).
            gsub(/(\r|\n)+/, LB)
        }
      end
      xml_attrs = self.class.attributes(cell, cell.xml_attributes)
      @worksheets_t._Cell(xml_attrs, &build)
    end

    def row(row, &block)
      build = block ? Proc.new { @element_stack.using(row, &block) } : nil
      xml_attrs = self.class.attributes(row, row.xml_attributes)
      @worksheets_t._Row(xml_attrs, &build)
    end

    def column(column, &block)
      build = block ? Proc.new { @element_stack.using(column, &block) } : nil
      xml_attrs = self.class.attributes(column, column.xml_attributes)
      @worksheets_t._Column(xml_attrs, &build)
    end

    def worksheet(worksheet, &block)
      build = block ? Proc.new { @element_stack.using(worksheet, &block) } : nil
      xml_attrs = self.class.attributes(worksheet, worksheet.xml_attributes)
      @worksheets_t._Worksheet(xml_attrs) {
        @worksheets_t._Table(&build)
      }
    end

    # workbook element attribute directives

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
        @element_stack.current.tap do |elem|
          elem.send("#{a}=", value)
          xml_attrs = self.class.attributes(elem, elem.xml_attributes)
          @worksheets_t.__attrs(xml_attrs)
        end
      end
    end

  end

  class Writer::ElementStack

    # this class is just a wrapper to Array.  I want to treat this as a
    # stack of objects for the workbook DSL to reference.  I need to push
    # an object onto the stack, reference it using the 'current' method,
    # and pop it off the stack when I'm done.

    def initialize
      super
    end

    def push(*args)
      super
    end

    def pop(*args)
      super
    end

    def current
      self.last
    end

    def size(*args)
      super
    end

    def using(obj, &block)
      push(obj)
      block.call if !block.nil?
      pop
    end

  end

end
