# Web Server root directory
WEB_SERVER_ROOT = File.expand_path(File.join(File.dirname(__FILE__),'root'))

def get_path(server,path)
  server.route_path(path).last
end

def get_url(server,url)
  server.route(url).last
end
