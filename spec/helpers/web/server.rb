require 'ronin/web/server'

def web_server_get(server,path)
  server.call('PATH_INFO' => path).last
end
