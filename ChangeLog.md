### 0.3.0 / 2013-06-18

* Upgraded to the GPL-3 license.
* Require [Ruby] >= 1.9.1.
* Require [nokogiri] ~> 1.4.
* Require [mechanize] ~> 1.0.
* Require [spidr] ~> 0.2.
* Require [rack] ~> 1.3.
* Require [sinatra] ~> 1.2.
* Require [data\_paths] ~> 0.3.
* Require [ronin-support] ~> 0.2.
* Require [ronin] ~> 1.1.
* Added {Ronin::Web.proxy=}.
* Added {Ronin::Web.user_agents}.
* Added {Ronin::Web::UserAgents}.
* Refactored {Ronin::Web::Server}:
  * Added {Ronin::Web::Server::Base}.
  * Added {Ronin::Web::Server::Conditions}.
  * Added {Ronin::Web::Server::Helpers#mime_type_for}.
  * Added {Ronin::Web::Server::Helpers#content_type_for}.
  * Added {Ronin::Web::Server::Helpers::ClassMethods#files}.
  * Added {Ronin::Web::Server::Helpers::ClassMethods#directories}.
* Renamed `Ronin::Helpers::Web` to {Ronin::Network::Mixins::Web}.
* Renamed `Ronin::Web::Server::Proxy` to {Ronin::Web::Proxy}.
* Moved `Ronin::Scanners::Web` into [ronin-scanners].
* Made {Ronin::Web.agent} persistent.
* Switched from [Jeweler](https://github.com/technicalpickles/jeweler)
  [rubygems-tasks](http://github.com/postmodern/rubygems-tasks) and to
  [Bundler](http://gembundler.com).

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
* Added {Ronin::Web::Server::Base}.
* Added `Ronin::Web::Server::Files`.
* Added `Ronin::Web::Server::Hosts`.
* Added `Ronin::Web::Server::Proxy`.
* Added {Ronin::Web::Server::Helpers}.
* Added `Ronin::Web::Server::Helpers::Files`.
* Added `Ronin::Web::Server::Helpers::Hosts`.
* Added `Ronin::Web::Server::Helpers::Proxy`.
* Added {Ronin::Web::Server::App}.
* Added {Ronin::Web.server}.
* Removed `Ronin::Web::Fingerprint`.
* Renamed Ronin::Sessions::Web to Ronin::Network::Helpers::Web.
* Moved to YARD based documentation.
* Updated the project summary and 3-point description for Ronin Web.
* Refactored the Ronin::Web::Server to build ontop of Sinatra.
* Refactored Ronin::Network::Helpers::Web.

### 0.1.3 / 2009-07-02

* Use Hoe >= 2.0.0.
* Require [spidr] >= 0.1.9.
* Require [rack] >= 1.0.0.
* Require [ronin] >= 0.2.4.
* Added `Ronin::Web::Fingerprint`.
* Added {Ronin::Web.build_html}.
* Added {Ronin::Web.build_xml}.
* Allow {Ronin::Web.html} to accept a block.
* Allow {Ronin::Web.xml} to accept a block.
* Allow `Ronin::Web::Server#return_file` to accept a content_type option.
* Make sure {Ronin::Web::Server} is thread safe.
* Blocks passed to Server.new will not be instance_evaled.
* Removed `Ronin::Web::Spider#default_options`.
* Removed `Ronin::web::Server.run`.
* Removed `Ronin::Web::Server#config`.

### 0.1.2 / 2009-03-28

* Added {Ronin::Web::Proxy}.
* Added diagnostic messages to {Ronin::Web::Spider}.
* Fixed Rack 0.9.1 compatibility bugs in {Ronin::Web::Server}.
  * Server#response now uses `Rack::Response`.
  * {Ronin::Web::Server} now uses a `Rack::Request` object instead of the
    standard env Hash.
* Updated specs for {Ronin::Web::Server}.

### 0.1.1 / 2009-02-23

* Added a git style sub-command (`ronin-web`) which starts the Ronin
  console with `ronin/web` preloaded.
* Require [nokogiri] >= 1.2.0.
* Require [ronin] >= 0.2.1.
* Updated {Ronin::Web::Server}:
  * Properly catch load errors when attempting to load Mongrel.
  * Renamed Server#mount to `Ronin::Web::Server#directory`.
* Removed the last reference to Hpricot.
* Fixed a bug when loading the Nokogiri extensions with [nokogiri] >= 1.2.0.
* Updated README.txt.

### 0.1.0 / 2009-01-22

* Initial release.
  * Provides {Ronin::Web.html} and {Ronin::Web.xml} methods, which use
    `Nokogiri::HTML` and `Nokogiri::XML` respectively, to parse HTML and XML
    content.
  * Supports custom Proxy and User-Agent strings, through
    the Web.proxy and Web.user_agent methods respectively.
  * Provides {Ronin::Web.agent}, {Ronin::Web.get} and {Ronin::Web.post} methods
    which access [WWW::Mechanize][mechanize].
  * Integrates [Spidr::Agent][spidr] into [Ronin::Web::Spider].
  * Provides Web::Server, a customizable Rack web server that supports path
    and host-name routing.
    * Web::Server will use Mongrel, only if Mongrel is installed, otherwise
      WEBrick will be used.

[Ruby]: http://www.ruby-lang.org
[nokogiri]: https://github.com/tenderlove/nokogiri
[libxml2]: http://xmlsoft.org/
[libxslt]: http://xmlsoft.org/XSLT/
[mechanize]: https://github.com/tenderlove/mechanize
[spidr]: https://github.com/postmodern/spidr
[rack]: https://github.com/rack/rack
[sinatra]: https://github.com/sinatra/sinatra
[data_paths]: https://github.com/postmodern/data_paths
[ronin-support]: https://github.com/ronin-rb/ronin-support
[ronin]: https://github.com/ronin-rb/ronin
[ronin-scanners]: https://github.com/ronin-rb/ronin-scanners
