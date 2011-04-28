require 'nokogiri'

module Nokogiri
  module XML
    class Element < Node

      #
      # Determines if the element is similar to another element.
      #
      # @param [Nokogiri::XML::Element] other
      #   The other element.
      #
      # @return [Boolean]
      #   Specifies whether the element is equal, in identity or value, to
      #   another element.
      #
      def ==(other)
        return false unless super(other)
        return false unless attribute_nodes.length == other.attribute_nodes.length

        (0...attribute_nodes.length).each do |index|
          attr1 = attribute_nodes[index]
          attr2 = other.attribute_nodes[index]

          return false unless attr1.similar?(attr2)
        end

        return true
      end

    end
  end
end
