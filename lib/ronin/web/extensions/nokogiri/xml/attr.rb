require 'nokogiri'

module Nokogiri
  module XML
    class Attr < Node

      def similar?(other)
        super(other) && (self.value == other.value)
      end

    end
  end
end
