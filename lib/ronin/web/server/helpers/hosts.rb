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
    module Server
      module Helpers
        module Hosts
          #
          # Calls the given _block_ if the host field fo the request
          # matches the specified _name_or_pattern_.
          #
          #   downloads = 0
          #
          #   get '/file' do
          #     for_host /^ftp/ do
          #       downloads += 1
          #   
          #       content_type :txt
          #       'some file'
          #     end
          #
          #     for_host /^www/ do
          #       downloads += 1
          #   
          #       'some file'
          #     end
          #
          #     for_host 'localhost' do
          #       "Total Downloads: #{downloads}"
          #     end
          #   end
          #
          def for_host(name_or_pattern,&block)
            if name_or_pattern.kind_of?(Regexp)
              halt(*block.call()) if request.host =~ name_or_pattern
            else
              halt(*block.call()) if request.host == name_or_pattern.to_s
            end
          end
        end
      end
    end
  end
end
