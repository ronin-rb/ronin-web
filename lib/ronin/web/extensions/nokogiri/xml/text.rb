require 'nokogiri'

module Nokogiri
  module XML
    class Text < CharacterData

      def similar?(other)
        super(other) && (self.content == other.content)
      end

    end
  end
end
