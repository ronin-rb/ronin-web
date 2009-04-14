#
#--
# Ronin Web - A Ruby library for Ronin that provides support for web
# scraping and spidering functionality.
#
# Copyright (c) 2006-2009 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#++
#

module Ronin
  module Web
    module Fingerprint
      #
      # The Hash of web application identities and their associated
      # fingerprint tests.
      #
      def Fingerprint.tests
        @@ronin_web_fingerprints ||= Hash.new do |hash,key|
          hash[key] ||= []
        end
      end

      #
      # Adds a test for the web application identity with the specified
      # _name_ and _block_. When the _block_ is called, it will be passed
      # the URL of the unknown web application.
      #
      #   Fingerprint.test_for('app') do |url|
      #     url.path.include?('/app/')
      #   end
      #
      def Fingerprint.test_for(name,&block)
        Fingerprint.tests[name.to_sym] << block
        return nil
      end

      #
      # Identifies the web application represented by the specified _url_,
      # returning the name of identified web application. If the
      # web application cannot be identified, +nil+ will be returned.
      #
      def Fingerprint.identify(url)
        unless url.kind_of?(URI)
          url = URI(url.to_s)
        end

        Fingerprint.tests.each do |name,blocks|
          blocks.each do |block|
            return name if block.call(url)
          end
        end

        return nil
      end
    end
  end
end
