require 'nokogiri'

# common methods used for generating XML
module Xmlss
  XML_NS   = "xmlns"
  SHEET_NS = "ss"
  NS_URI   = "urn:schemas-microsoft-com:office:spreadsheet"

  module Xml

    def xml_builder
      ::Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |builder|
        yield(builder) if block_given?
      end
    end

    def build_node(builder, attrs={})
      unless xml && xml.kind_of?(::Hash)
        raise ArgumentError, "no xml config provided"
      end
      if xml[:node] && !xml[:node].to_s.empty?
        if xml[:value] && (v = self.send(xml[:value]).to_s)
          builder.send(Xmlss.classify(xml[:node]), v, build_attributes(attrs))
        else
          builder.send(Xmlss.classify(xml[:node]), build_attributes(attrs)) do
            build_children(builder)
          end
        end
      else
        build_children(builder)
      end
    end

    def build_attributes(attrs={})
      (xml[:attributes] || []).inject({}) do |xattrs, a|
        xattrs.merge(if !(xv = Xmlss.xmlify(self.send(a))).nil?
          {"#{Xmlss::SHEET_NS}:#{Xmlss.classify(a)}" => xv}
        else
          {}
        end)
      end.merge(attrs)
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