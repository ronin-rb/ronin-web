module Helpers
  module Web
    module Root
      ROOT_DIR = File.expand_path(File.join(File.dirname(__FILE__),'root'))

      def root_path(path=nil)
        if path
          File.join(ROOT_DIR,path)
        else
          ROOT_DIR
        end
      end
    end
  end
end
