require 'nokogiri/xml/document'

module Nokogiri
  module XML
    class Document < Node

      #
      # Returns the total count of all sub-children of the document.
      #
      def total_children
        return 0 unless root

        1 + root.total_children
      end

    end
  end
end
