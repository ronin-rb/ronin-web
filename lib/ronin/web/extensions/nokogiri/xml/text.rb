module Nokogiri
  module XML
    class Text < Node

      def similar?(other)
        super(other) && (self.content == other.content)
      end

    end
  end
end
