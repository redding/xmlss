require 'nokogiri'

module Xmlss

  XML_NS   = "xmlns"
  SHEET_NS = "ss"
  NS_URI   = "urn:schemas-microsoft-com:office:spreadsheet"

  module Helpers

    # TODO: move to the main workbook model eventually...
    def to_xml
      ::Nokogiri::XML::Builder.new do |builder|
        builder.root({
          Xmlss::XML_NS => Xmlss::NS_URI,
          "#{Xmlss::XML_NS}:#{Xmlss::SHEET_NS}" => Xmlss::NS_URI
        }) do
          element(builder)
        end
      end.to_xml
    end

    def element_attributes(*attrs)
      attrs.inject({}) do |xattrs, a|
        xattrs.merge(if !(xv = xmlify(self.send(a))).nil?
          {"#{Xmlss::SHEET_NS}:#{classify(a)}" => xv}
        else
          {}
        end)
      end
    end

    def classify(underscored_string)
      underscored_string.
        to_s.downcase.
        split("_").
        collect{|part| part.capitalize}.
        join('')
    end
    private :classify

    def xmlify(value)
      if value == true
        1
      elsif ["",false].include?(value)
        # don't include false or empty string values
        nil
      else
        value
      end
    end
    private :xmlify

  end
end

require 'xmlss/style/base'
