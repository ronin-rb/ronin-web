#
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
#

require 'ronin/web/spider'
require 'ronin/scanners/scanner'

module Ronin
  module Scanners
    class Web < Web::Spider

      include Scanner

      protected

      def each_target(&block)
        print_info "Started web spidering ..."

        history.clear

        unless visit_hosts.empty?
          enqueue("http://#{visit_hosts.first}/")
        end

        run do |page|
          print_info "Scanning page: #{page.url}"
          block.call(page)
        end

        print_info "Finished web spidering."
      end

    end
  end
end
