### 0.3.0 / 2011-05-27

* Upgraded to the GPL-3 license.
* Require nokogiri ~> 1.4.
* Require mechanize ~> 1.0.
* Require spidr ~> 0.2.
* Require rack ~> 1.3.
* Require sinatra ~> 1.2.
* Require data_paths ~> 0.3.
* Require ronin-support ~> 0.2.
* Require ronin ~> 1.1.
* Added {Ronin::Web::Middleware::Base}.
* Added {Ronin::Web::Middleware::Request}.
* Added {Ronin::Web::Middleware::Response}.
* Added {Ronin::Web::Middleware::Helpers}.
* Added {Ronin::Web::Middleware::Files}.
* Added {Ronin::Web::Middleware::Directories}.
* Added {Ronin::Web::Middleware::Rule}.
* Added {Ronin::Web::Middleware::Filters::CampaignFilter}.
* Added {Ronin::Web::Middleware::Filters::IPFilter}.
* Added {Ronin::Web::Middleware::Filters::PathFilter}.
* Added {Ronin::Web::Middleware::Filters::RefererFilter}.
* Added {Ronin::Web::Middleware::Filters::UserAgentFilter}.
* Added {Ronin::Web::Middleware::Filters::VHostFilter}.
* Added {Ronin::Web::Middleware::Router}.
* Added {Ronin::Web::Middleware::Proxy}.
* Renamed `Ronin::Helpers::Web` to {Ronin::Network::Mixins::Web}.
* Renamed `Ronin::Web::Server::Proxy` to {Ronin::Web::Proxy}.
* Switched from [Jeweler](https://github.com/technicalpickles/jeweler)
  to [Ore](http://github.com/ruby-ore/ore) and [Bundler](http://gembundler.com).
* Opted into [test.rubygems.org](http://test.rubygems.org/).

### 0.2.1 / 2009-10-18

* Require spidr >= 0.2.0.
* Added Ronin::Scanners::Web.
* Added more specs for Ronin::Web and Ronin::Scanners::Web.
* Renamed Ronin::Web.proxy to Ronin::Web.proxy_server, to not conflict
  with the original Ronin::Web.proxy method.

### 0.2.0 / 2009-09-24

* Require ronin >= 0.3.0.
* Require mechanize >= 0.9.3.
* Require sinatra >= 0.9.4.
* Require rspec >= 1.2.8.
* Require test-unit >= 1.2.3.
* Require rack-test >= 0.4.1.
* Require yard >= 0.2.3.5.
* Added Ronin::Web::Server::Base.
* Added Ronin::Web::Server::Files.
* Added Ronin::Web::Server::Hosts.
* Added Ronin::Web::Server::Proxy.
* Added Ronin::Web::Server::Helpers.
* Added Ronin::Web::Server::Helpers::Files.
* Added Ronin::Web::Server::Helpers::Hosts.
* Added Ronin::Web::Server::Helpers::Proxy.
* Added Ronin::Web::Server::App.
* Added Ronin::Web.server.
* Renamed Ronin::Sessions::Web to Ronin::Network::Helpers::Web.
* Moved to YARD based documentation.
* Updated the project summary and 3-point description for Ronin Web.
* Refactored the Ronin::Web::Server to build ontop of Sinatra.
* Refactored Ronin::Network::Helpers::Web.

### 0.1.3 / 2009-07-02

* Use Hoe >= 2.0.0.
* Require spidr >= 0.1.9.
* Require rack >= 1.0.0.
* Require ronin >= 0.2.4.
* Added Ronin::Web::Fingerprint.
* Added Web.build_html.
* Added Web.build_xml.
* Allow Web.html to accept a block.
* Allow Web.xml to accept a block.
* Allow Server#return_file to accept a content_type option.
* Make sure Ronin::Web::Server is thread safe.
* Blocks passed to Server.new will not be instance_evaled.
* Removed Spider#default_options.
* Removed Server.run.
* Removed Server#config.

### 0.1.2 / 2009-03-28

* Added Ronin::Web::Proxy.
* Added diagnostic messages to Ronin::Web::Spider.
* Fixed Rack 0.9.1 compatibility bugs in Ronin::Web::Server.
  * Server#response now uses Rack::Response.
  * Ronin::Web::Server now uses a Rack::Request object instead of the
    standard env Hash.
* Updated specs for Ronin::Web::Server.

### 0.1.1 / 2009-02-23

* Added a git style sub-command (`ronin-web`) which starts the Ronin
  console with `ronin/web` preloaded.
* Require Nokogiri >= 1.2.0.
* Require Ronin >= 0.2.1.
* Updated Ronin::Web::Server:
  * Properly catch load errors when attempting to load Mongrel.
  * Renamed Server#mount to Server#directory.
* Removed the last reference to Hpricot.
* Fixed a bug when loading the Nokogiri extensions with Nokogiri >= 1.2.0.
* Updated README.txt.

### 0.1.0 / 2009-01-22

* Initial release.
  * Provides Web.html and Web.xml methods, which use Nokogiri::HTML and
    Nokogiri::XML respectively, to parse HTML and XML content.
  * Supports custom Proxy and User-Agent strings, through
    the Web.proxy and Web.user_agent methods respectively.
  * Provides Web.agent, Web.get and Weg.post methods which access
    WWW::Mechanize.
  * Integrates Spidr::Agent into Web::Spider.
  * Provides Web::Server, a customizable Rack web server that supports path
    and host-name routing.
    * Web::Server will use Mongrel, only if Mongrel is installed, otherwise
      WEBrick will be used.

