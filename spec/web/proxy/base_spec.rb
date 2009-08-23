require 'ronin/web/proxy/base'

require 'spec_helper'

describe Web::Proxy::Base do
  it "should run on a different port than Web::Server::Base" do
    Web::Proxy::Base.port.should_not == Web::Server::Base.port
  end
end
