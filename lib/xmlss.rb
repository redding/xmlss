module Xmlss
  # some helpers
  class << self

    def classify(underscored_string)
      underscored_string.
        to_s.downcase.
        split("_").
        collect{|part| part.capitalize}.
        join('')
    end

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

  end
end

require 'xmlss/xml'
require 'xmlss/style/base'
