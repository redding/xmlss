# this file is automatically required when you run `assert`
# put any test helpers here

# add the root dir to the load path
$LOAD_PATH.unshift(File.expand_path("../..", __FILE__))

# require pry for debugging (`binding.pry`)
require 'pry'

require 'test/support/factory'

class Assert::Context

  def self.be_styled
    called_from = caller.first
    Assert::Macro.new("have style attributes") do
      should have_accessor :style_id

      should "set the style default" do
        assert_equal nil, subject.class.new.style_id
      end
    end
  end

end

# 1.8.7 backfills

# Array#sample
if !(a = Array.new).respond_to?(:sample) && a.respond_to?(:choice)
  class Array
    alias_method :sample, :choice
  end
end
