require 'undies'

# common methods used for generating XML
module Xmlss
  XML_NS   = "xmlns"
  SHEET_NS = "ss"
  NS_URI   = "urn:schemas-microsoft-com:office:spreadsheet"

  module Xml

    def build_xml(opts={})
      out = ""
      outstream = StringIO.new(out)
      output = Undies::Output.new(outstream, opts)
      source = Undies::Source.new(Proc.new do
        __ "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"

        # self is the template this source is rendered in
        item.build_node(self)
      end)

      Undies::Template.new(source, {:item => self}, output)
      out.gsub(/#{Xmlss::Data::LB.gsub(/&/, "&amp;")}/, Xmlss::Data::LB)
    end

    def build_node(template)
      unless xml && xml.kind_of?(::Hash)
        raise ArgumentError, "no xml config provided"
      end

      if xml[:node] && !xml[:node].to_s.empty?
        node_name  = Xmlss.classify(xml[:node])
        node_attrs = build_attributes
        node_proc = if xml[:value] && (v = self.send(xml[:value]).to_s)
          Proc.new { template.send "__", v }
        elsif xml[:children] && !xml[:children].empty?
          Proc.new { build_children(template, xml[:children]) }
        end

        template.send("_#{node_name}", node_attrs, &node_proc)
      else
        build_children(template, xml[:children])
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

    def build_children(template, children)
      (children || []).each do |c|
        if (child = c.kind_of?(::Symbol) ? self.send(c) : c)
          child.build_node(template) if child.respond_to?(:build_node)
        end
      end
    end
    private :build_children

  end
end
