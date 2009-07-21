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
      module Public
        # Directory to search for static content within
        DIR = File.join('ronin','web','server','public')

        def self.included(base)
          base.module_eval do
            @@public_dirs_mutex = Mutex.new
            @@public_dirs = []

            #
            # Hosts the static contents within the directory at the specified
            # _path_.
            #
            #   Server.public_dir 'path/to/another/public'
            #
            def Server.public_dir(path)
              @@public_dirs_mutex.synchronize do
                @@public_dirs << File.expand_path(path)
              end
            end

            before do
              path = @@public_dirs_mutex.synchronize do
                @@public_dirs.each do |public_dir|
                  path = File.join(public_dir,request.path_info)

                  break path if File.file?(path)
                end
              end

              return_file(path) if path
            end
          end
        end
      end
    end
  end
end
