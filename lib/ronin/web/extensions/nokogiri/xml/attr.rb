require 'ronin/web/extensions/nokogiri/xml/node'

require 'nokogiri/xml/attr'

module Nokogiri
  module XML
    class Attr < Node

      def eql?(other)
        super(other) && (self.value == other.value)
      end
      
      alias == eql?

    end
  end
end
