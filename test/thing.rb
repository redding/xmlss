class Thing
  attr_accessor :one, :two, :three, :xml

  include Xmlss::Xml

  def child_nodes
    Xmlss::ItemSet.new(:nodes, [])
  end
end
