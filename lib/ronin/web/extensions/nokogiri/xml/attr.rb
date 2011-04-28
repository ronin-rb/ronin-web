require 'nokogiri'

module Nokogiri
  module XML
    class Attr < Node

      #
      # Determines if the attribute is similar to another attribute.
      #
      # @param [Nokogiri::XML::Attr] other
      #   The other attribute.
      #
      # @return [Boolean]
      #   Specifies if the attribute is similar, in indentity or value,
      #   to the other attribute.
      #
      def ==(other)
        super(other) && (self.value == other.value)
      end

    end
  end
end
