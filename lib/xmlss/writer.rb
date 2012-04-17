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

    # # TODO: remove this method - have attributes do their own
    # # coercing
    # def self.coerce(value)
    #   if value == true
    #     1
    #   elsif ["",false].include?(value)
    #     # don't include false or empty string values
    #     nil
    #   else
    #     value
    #   end
    # end

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
      styles_markup.inline_element("Alignment", {
        "#{SHEET_NS}:Horizontal" => alignment.horizontal,
        "#{SHEET_NS}:Vertical"   => alignment.vertical,
        "#{SHEET_NS}:Rotate"     => alignment.rotate,
        "#{SHEET_NS}:WrapText"   => alignment.wrap_text ? 1 : nil,
      })
    end

    def border(border)
      styles_markup.inline_element("Border", {
        "#{SHEET_NS}:Color"     => border.color,
        "#{SHEET_NS}:Position"  => border.position,
        "#{SHEET_NS}:Weight"    => border.weight,
        "#{SHEET_NS}:LineStyle" => border.line_style
      })
    end

    def borders(borders)
      styles_markup.element("Borders", nil, {})
    end

    def font(font)
      styles_markup.inline_element("Font", {
        "#{SHEET_NS}:Bold"          => font.bold ? 1 : nil,
        "#{SHEET_NS}:Color"         => font.color,
        "#{SHEET_NS}:Italic"        => font.italic ? 1 : nil,
        "#{SHEET_NS}:Size"          => font.size,
        "#{SHEET_NS}:Shadow"        => font.shadow ? 1 : nil,
        "#{SHEET_NS}:FontName"      => font.name,
        "#{SHEET_NS}:StrikeThrough" => font.strike_through ? 1 : nil,
        "#{SHEET_NS}:Underline"     => font.underline,
        "#{SHEET_NS}:VerticalAlign" => font.alignment,
      })
    end

    def interior(interior)
      styles_markup.inline_element("Interior", {
        "#{SHEET_NS}:Color"        => interior.color,
        "#{SHEET_NS}:Pattern"      => interior.pattern,
        "#{SHEET_NS}:PatternColor" => interior.pattern_color
      })
    end

    def number_format(number_format)
      styles_markup.inline_element("NumberFormat", {
        "#{SHEET_NS}:Format" => number_format.format,
      })
    end

    def protection(protection)
      styles_markup.inline_element("Protection", {
        "#{SHEET_NS}:Protect" => protection.protect ? 1 : nil,
      })
    end

    def style(style)
      styles_markup.element("Style", nil, {
        "#{SHEET_NS}:ID" => style.id,
      })
    end

    # workbook element markup directives

    def cell(cell)
      # write the cell markup and push
      worksheets_markup.element("Cell", nil, {
        "#{SHEET_NS}:Index"       => cell.index,
        "#{SHEET_NS}:StyleID"     => cell.style_id,
        "#{SHEET_NS}:Formula"     => cell.formula,
        "#{SHEET_NS}:HRef"        => cell.href,
        "#{SHEET_NS}:MergeAcross" => cell.merge_across,
        "#{SHEET_NS}:MergeDown"   => cell.merge_down
      })
      push(:worksheets)

      # write nested data markup and push
      worksheets_markup.element(
        "Data",
        worksheets_markup.raw(cell.data_xml_value),
        { "#{SHEET_NS}:Type" => cell.type }
      )

      pop(:worksheets)
    end

    def row(row)
      worksheets_markup.element("Row", nil, {
        "#{SHEET_NS}:StyleID"       => row.style_id,
        "#{SHEET_NS}:Height"        => row.height,
        "#{SHEET_NS}:AutoFitHeight" => row.auto_fit_height ? 1 : nil,
        "#{SHEET_NS}:Hidden"        => row.hidden ? 1 : nil
      })
    end

    def column(column)
      worksheets_markup.inline_element("Column", {
        "#{SHEET_NS}:StyleID"      => column.style_id,
        "#{SHEET_NS}:Width"        => column.width,
        "#{SHEET_NS}:AutoFitWidth" => column.auto_fit_width ? 1 : nil,
        "#{SHEET_NS}:Hidden"       => column.hidden ? 1 : nil
      })
    end

    def worksheet(worksheet)
      # flush any previous worksheet markup
      worksheets_markup.flush

      # write the worksheet markup and push
      worksheets_markup.element("Worksheet", nil, {
        "#{SHEET_NS}:Name" => worksheet.name
      })
      push(:worksheets)

      # write the table container
      worksheets_markup.element("Table", nil, {})
      # TODO: do all pushing and popping within the writer
      # don't have outside do it?
      #push(:worksheets)
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
      @template.__open_element(name, data, attrs.delete_if do |k,v|
        v.nil? || v == ''
      end)
    end

    # TODO: test?
    def inline_element(name, attrs)
      @template.__closed_element(name, attrs.delete_if do |k,v|
        v.nil? || v == ''
      end)
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
