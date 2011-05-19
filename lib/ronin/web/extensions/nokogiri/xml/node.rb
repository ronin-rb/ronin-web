require 'nokogiri'

module Nokogiri
  module XML
    class Node

      #
      # Calculates the sum of all children of the node.
      #
      # @return [Integer]
      #   The total number of children of the node.
      #
      def total_children
        count = 0

        traverse { |node| count += 1 }

        return count - 1
      end

      #
      # Traverses all text nodes which are children of the node.
      #
      # @yield [node]
      #   A block will be passed each text node.
      #
      # @yieldparam [Nokogiri::XML::Text] node
      #   A text node.
      #
      # @return [Enumerator]
      #   If no block is given, an Enumerator object will be returned.
      #
      def traverse_text
        return enum_for(:traverse_text) unless block_given?

        yield self if text?

        traverse do |node|
          yield node if node.text?
        end
      end

      #
      # Determines if the node is similar to another node.
      #
      # @return [Boolean]
      #   Specifies whether the node is equal, in identity or value, to
      #   another node.
      #
      def ==(other)
        return false unless other

        (self.type == other.type) && (self.name == other.name)
      end

    end
  end
end
