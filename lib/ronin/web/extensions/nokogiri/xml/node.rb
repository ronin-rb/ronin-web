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
        first = self.child

        return count unless first

        while first
          count += (1 + first.total_children)

          first = first.next
        end

        count
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
      def traverse_text(&block)
        block.call(self) if text?

        first = self.child

        while first
          first.traverse_text(&block)

          first = first.next
        end

        self
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
