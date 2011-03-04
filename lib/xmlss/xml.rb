require 'nokogiri'

# common methods used for generating XML
module Xmlss
  XML_NS   = "xmlns"
  SHEET_NS = "ss"
  NS_URI   = "urn:schemas-microsoft-com:office:spreadsheet"

  module Xml

    # TODO: move to the main workbook model eventually...
    def to_xml
      ::Nokogiri::XML::Builder.new do |builder|
        builder.root({
          Xmlss::XML_NS => Xmlss::NS_URI,
          "#{Xmlss::XML_NS}:#{Xmlss::SHEET_NS}" => Xmlss::NS_URI
        }) do
          build_node(builder)
        end
      end.to_xml
    end

    def build_node(builder)
      unless xml && xml.kind_of?(::Hash)
        raise ArgumentError, "no xml config provided"
      end
      if xml[:node] && !xml[:node].to_s.empty?
        builder.send(Xmlss.classify(xml[:node]), build_attributes) do
          build_children(builder)
        end
      else
        build_children(builder)
      end
    end

    def build_attributes
      (xml[:attributes] || []).inject({}) do |xattrs, a|
        xattrs.merge(if !(xv = Xmlss.xmlify(self.send(a))).nil?
          {"#{Xmlss::SHEET_NS}:#{Xmlss.classify(a)}" => xv}
        else
          {}
        end)
      end
    end
    private :build_attributes

    def build_children(builder)
      (xml[:children] || []).each do |c|
        if (child = c.kind_of?(::Symbol) ? self.send(c) : c)
          child.build_node(builder) if child.respond_to?(:build_node)
        end
      end
    end
    private :build_children

  end
end