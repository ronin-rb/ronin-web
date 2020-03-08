require 'spec_helper'
require 'ronin/web/server/base'

require 'web/server/classes/test_app'
require 'web/helpers/rack_app'

describe Web::Server::Base do
  include Helpers::Web::RackApp

  before(:all) do
    self.app = TestApp
  end

  it "should still bind blocks to paths" do
    get '/tests/get'

    expect(last_response).to be_ok
    expect(last_response.body).to eq('block tested')
  end

  it "should bind a block to a path for all request types" do
    post '/tests/any'

    expect(last_response).to be_ok
    expect(last_response.body).to eq('any tested')
  end

  it "should have a default response" do
    get '/totally/non/existant/path'

    expect(last_response).not_to be_ok
    expect(last_response.body).to be_empty
  end

  it "should allow for defining custom responses" do
    TestApp.default do
      halt 404, 'nothing to see here'
    end

    get '/whats/here'

    expect(last_response).not_to be_ok
    expect(last_response.body).to eq('nothing to see here')
  end

  it "should map paths to sub-apps" do
    get '/tests/subapp/'

    expect(last_response).to be_ok
    expect(last_response.body).to eq('SubApp')
  end

  it "should not modify the path_info as it maps paths to sub-apps" do
    get '/tests/subapp/hello'

    expect(last_response).to be_ok
    expect(last_response.body).to eq('SubApp greets you')
  end

  it "should host static content from public directories" do
    get '/static1.txt'

    expect(last_response).to be_ok
    expect(last_response.body).to eq("Static file1.\n")
  end

  it "should host static content from multiple public directories" do
    get '/static2.txt'

    expect(last_response).to be_ok
    expect(last_response.body).to eq("Static file2.\n")
  end
end
