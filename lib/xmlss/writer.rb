require 'undies'
require 'stringio'

module Xmlss
  class Writer

    class Markup; end
    class AttrsHash; end

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

    attr_reader :styles_markup
    attr_reader :worksheets_markup

    def initialize(output_opts={})
      @opts = output_opts || {}

      @styles_markup     = Markup.new(@opts.merge(:level => 2))
      @worksheets_markup = Markup.new(@opts.merge(:level => 1))
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
          _ raw("<?xml version=\"1.0\" encoding=\"UTF-8\"?>")
          __open_element("Workbook", XML_NS => NS_URI, "#{XML_NS}:#{SHEET_NS}" => NS_URI) {
            __open_element("Styles") {
              __partial @styles
            }
            __partial @worksheets
          }
        end), {
          :styles => styles_markup.to_s,
          :worksheets => worksheets_markup.to_s
        }, Undies::IO.new(markup, @opts))
      end.strip
    end

    # workbook style markup directives

    def alignment(alignment)
      styles_markup.inline_element("Alignment", AttrsHash.new.
        value("Horizontal", alignment.horizontal).
        value("Vertical",   alignment.vertical).
        value("Rotate",     alignment.rotate).
        bool( "WrapText",   alignment.wrap_text).
        raw
      )
    end

    def border(border)
      styles_markup.inline_element("Border", AttrsHash.new.
        value("Color",     border.color).
        value("Position",  border.position).
        value("Weight",    border.weight).
        value("LineStyle", border.line_style).
        raw
      )
    end

    def borders(borders)
      styles_markup.element("Borders", nil, {})
    end

    def font(font)
      styles_markup.inline_element("Font", AttrsHash.new.
        bool( "Bold",          font.bold).
        value("Color",         font.color).
        bool( "Italic",        font.italic).
        value("Size",          font.size).
        bool( "Shadow",        font.shadow).
        value("FontName",      font.name).
        bool( "StrikeThrough", font.strike_through).
        value("Underline",     font.underline).
        value("VerticalAlign", font.alignment).
        raw
      )
    end

    def interior(interior)
      styles_markup.inline_element("Interior", AttrsHash.new.
        value("Color",        interior.color).
        value("Pattern",      interior.pattern).
        value("PatternColor", interior.pattern_color).
        raw
      )
    end

    def number_format(number_format)
      a = AttrsHash.new.value("Format", number_format.format).raw
      styles_markup.inline_element("NumberFormat", a)
    end

    def protection(protection)
      a = AttrsHash.new.bool("Protect", protection.protect).raw
      styles_markup.inline_element("Protection", a)
    end

    def style(style)
      a = AttrsHash.new.value("ID", style.id).raw
      styles_markup.element("Style", nil, a)
    end

    # workbook element markup directives

    def cell(cell)
      # write the cell markup and push
      worksheets_markup.element("Cell", nil, AttrsHash.new.
        value("Index",       cell.index).
        value("StyleID",     cell.style_id).
        value("Formula",     cell.formula).
        value("HRef",        cell.href).
        value("MergeAcross", cell.merge_across).
        value("MergeDown",   cell.merge_down).
        raw
      )
      push(:worksheets)

      # write nested data markup and push
      worksheets_markup.element(
        "Data",
        worksheets_markup.raw(cell.data_xml_value),
        AttrsHash.new.value("Type", cell.type).raw
      )

      pop(:worksheets)
    end

    def row(row)
      worksheets_markup.element("Row", nil, AttrsHash.new.
        value("StyleID",       row.style_id).
        value("Height",        row.height).
        bool( "AutoFitHeight", row.auto_fit_height).
        bool( "Hidden",        row.hidden).
        raw
      )
    end

    def column(column)
      worksheets_markup.inline_element("Column", AttrsHash.new.
        value("StyleID",      column.style_id).
        value("Width",        column.width).
        bool( "AutoFitWidth", column.auto_fit_width).
        bool( "Hidden",       column.hidden).
        raw
      )
    end

    def worksheet(worksheet)
      # flush any previous worksheet markup
      worksheets_markup.flush

      # write the worksheet markup and push
      a = AttrsHash.new.value("Name", worksheet.name).raw
      worksheets_markup.element("Worksheet", nil, a)
      push(:worksheets)

      # write the table container
      worksheets_markup.element("Table", nil, {})
      # TODO: do all pushing and popping within the writer
      # don't have outside do it?
      #push(:worksheets)
    end

  end



  # TODO: test
  class Writer::AttrsHash

    attr_reader :raw

    def initialize
      @raw = Hash.new
    end

    def value(k, v)
      # ignore any nil-value or empty string attrs
      @raw["#{Xmlss::Writer::SHEET_NS}:#{k}"] = v if v && v != ''
      self
    end

    def bool(k, v)
      # write truthy values as '1', otherwise ignore
      @raw["#{Xmlss::Writer::SHEET_NS}:#{k}"] = 1 if v
      self
    end

  end

  class Writer::Markup

    attr_reader :template, :push_count, :pop_count

    def initialize(opts={})
      @markup = ""
      @template = Undies::Template.new(Undies::IO.new(@markup, opts))
      @push_count = 0
      @pop_count  = 0
    end

    # TODO: test
    def raw(markup)
      @template.raw(
        Undies::Template.escape_html(markup).gsub(/(\r|\n)+/, Xmlss::Writer::LB)
      )
    end

    # TODO: test
    def element(name, data, attrs)
      # remove any nil-value attrs
      @template.__open_element(name, data, attrs)
    end

    # TODO: test?
    def inline_element(name, attrs)
      @template.__closed_element(name, attrs)
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
      self
    end

    def empty?; @markup.empty?; end

    def to_s
      @markup.to_s
    end

  end

end
