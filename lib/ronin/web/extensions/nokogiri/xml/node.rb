module Nokogiri
  module XML
    class Node

      #
      # Returns the total count of all sub-children of the node.
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

      def traverse_text(&block)
        block.call(self) if text?

        first = self.child

        while first
          first.traverse_text(&block)

          first = first.next
        end

        self
      end

      def similar?(other)
        return false unless other

        (self.type == other.type) && (self.name == other.name)
      end

    end
  end
end
