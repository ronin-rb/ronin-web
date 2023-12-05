require 'spec_helper'
require 'ronin/web/cli/commands/vulns'
require_relative 'man_page_example'

require 'sinatra/base'
require 'webmock/rspec'

describe Ronin::Web::CLI::Commands::Vulns do
  include_examples "man_page"

  describe "options" do
    context "when the --header option is given" do
      let(:header_name1)  { 'X-Foo' }
      let(:header_value1) { 'foo' }
      let(:header1)       { "#{header_name1}: #{header_value1}" }

      let(:header_name2)  { 'X-Bar' }
      let(:header_value2) { 'bar' }
      let(:header2)       { "#{header_name2}: #{header_value2}" }

      before do
        subject.option_parser.parse(['--header', header1, '--header', header2])
      end

      it "must set :default_headers in #agent_kwargs" do
        expect(subject.agent_kwargs[:default_headers]).to eq(
          {
            header_name1 => header_value1,
            header_name2 => header_value2
          }
        )
      end

      it "must set :headers in the #scan_kwargs" do
        expect(subject.scan_kwargs[:headers]).to eq(
          {
            header_name1 => header_value1,
            header_name2 => header_value2
          }
        )
      end
    end

    context "when the --user-agent-string option is given" do
      let(:user_agent) { 'Foo Bot' }

      before do
        subject.option_parser.parse(['--user-agent-string', user_agent])
      end

      it "must set :user_agent in #agent_kwargs" do
        expect(subject.agent_kwargs[:user_agent]).to eq(user_agent)
      end

      it "must set :user_agent in #scan_kwargs" do
        expect(subject.scan_kwargs[:user_agent]).to eq(user_agent)
      end
    end

    context "when the --user-agent option is given" do
      Ronin::Support::Network::HTTP::UserAgents::ALIASES.transform_keys { |key|
        key.to_s.tr('_','-')
      }.each do |user_agent_alias,user_agent_string|
        context "and the value is '#{user_agent_alias}'" do
          let(:user_agent) { user_agent_string }

          before do
            subject.option_parser.parse(['--user-agent', user_agent_alias])
          end

          it "must set :user_agent in #agent_kwargs to '#{user_agent_string}'" do
            expect(subject.agent_kwargs[:user_agent]).to eq(user_agent_string)
          end

          it "must set :user_agent in #scan_kwargs to '#{user_agent_string}'" do
            expect(subject.scan_kwargs[:user_agent]).to eq(user_agent_string)
          end
        end
      end
    end

    context "when the --referer option is given" do
      let(:referer) { 'http://example.com/page' }

      before do
        subject.option_parser.parse(['--referer', referer])
      end

      it "must set :referer in #agent_kwargs" do
        expect(subject.agent_kwargs[:referer]).to eq(referer)
      end

      it "must set :referer in #scan_kwargs" do
        expect(subject.scan_kwargs[:referer]).to eq(referer)
      end
    end

    context "when the '--lfi-os' option is given" do
      let(:os)   { :windows }
      let(:argv) { ['--lfi-os', os.to_s] }

      before { subject.option_parser.parse(argv) }

      it "must set the :os key in #lfi_kwargs" do
        expect(subject.lfi_kwargs[:os]).to eq(os)
      end
    end

    context "when the '--lfi-depth' option is given" do
      let(:depth) { 9 }
      let(:argv)  { ['--lfi-depth', depth.to_s] }

      before { subject.option_parser.parse(argv) }

      it "must set the :depth key in the Hash" do
        expect(subject.lfi_kwargs[:depth]).to eq(depth)
      end
    end

    context "when the '--lfi-filter-bypass' option is given" do
      let(:argv) { ['--lfi-filter-bypass', option_value] }

      before { subject.option_parser.parse(argv) }

      context "and it's value is 'null-byte'" do
        let(:option_value)  { 'null-byte' }
        let(:filter_bypass) { :null_byte }

        it "must set the :filter_bypass key in #lfi_kwargs to :null_byte" do
          expect(subject.lfi_kwargs[:filter_bypass]).to eq(filter_bypass)
        end
      end

      context "and it's value is 'double-escape'" do
        let(:option_value)  { 'double-escape' }
        let(:filter_bypass) { :double_escape }

        it "must set the :filter_bypass key in #lfi_kwargs to :double_escape" do
          expect(subject.lfi_kwargs[:filter_bypass]).to eq(filter_bypass)
        end
      end

      context "and it's value is 'base64'" do
        let(:option_value)  { 'base64' }
        let(:filter_bypass) { :base64 }

        it "must set the :filter_bypass key in #lfi_kwargs to :base64" do
          expect(subject.lfi_kwargs[:filter_bypass]).to eq(filter_bypass)
        end
      end

      context "and it's value is 'rot13'" do
        let(:option_value)  { 'rot13' }
        let(:filter_bypass) { :rot13 }

        it "must set the :filter_bypass key in #lfi_kwargs to :rot13" do
          expect(subject.lfi_kwargs[:filter_bypass]).to eq(filter_bypass)
        end
      end

      context "and it's value is 'zlib'" do
        let(:option_value)  { 'zlib' }
        let(:filter_bypass) { :zlib }

        it "must set the :filter_bypass key in #lfi_kwargs" do
          expect(subject.lfi_kwargs[:filter_bypass]).to eq(filter_bypass)
        end
      end
    end

    context "when the '--rfi-filter-bypass' option is given" do
      let(:argv) { ['--rfi-filter-bypass', option_value] }

      before { subject.option_parser.parse(argv) }

      context "when the option value is 'double-encode'" do
        let(:option_value)  { 'double-encode' }
        let(:filter_bypass) { :double_encode }

        it "must set the :filter_bypass key in the #rfi_kwargs to :double_encode" do
          expect(subject.rfi_kwargs[:filter_bypass]).to eq(filter_bypass)
        end
      end

      context "when the option value is 'suffix-escape'" do
        let(:option_value)  { 'suffix-escape' }
        let(:filter_bypass) { :suffix_escape }

        it "must set the :filter_bypass key in the #rfi_kwargs to :suffix_escape" do
          expect(subject.rfi_kwargs[:filter_bypass]).to eq(filter_bypass)
        end
      end

      context "when the option value is 'null-byte'" do
        let(:option_value)  { 'null-byte' }
        let(:filter_bypass) { :null_byte }

        it "must set the :filter_bypass key in the #rfi_kwargs to :null_byte" do
          expect(subject.rfi_kwargs[:filter_bypass]).to eq(filter_bypass)
        end
      end
    end

    context "when the '--rfi-script-lang' option is given" do
      let(:argv) { ['--rfi-script-lang', option_value] }

      before { subject.option_parser.parse(argv) }

      context "when the option value is 'asp'" do
        let(:option_value) { 'asp' }
        let(:script_lang)  { :asp }

        it "must set the :script_lang key in #rfi_kwargs to :asp" do
          expect(subject.rfi_kwargs[:script_lang]).to eq(script_lang)
        end
      end

      context "when the option value is 'asp.net'" do
        let(:option_value) { 'asp.net' }
        let(:script_lang)  { :asp_net }

        it "must set the :script_lang key in #rfi_kwargs to :asp_net" do
          expect(subject.rfi_kwargs[:script_lang]).to eq(script_lang)
        end
      end

      context "when the option value is 'coldfusion'" do
        let(:option_value) { 'coldfusion' }
        let(:script_lang)  { :cold_fusion }

        it "must set the :script_lang key in #rfi_kwargs to :cold_fusion" do
          expect(subject.rfi_kwargs[:script_lang]).to eq(script_lang)
        end
      end

      context "when the option value is 'jsp'" do
        let(:option_value) { 'jsp' }
        let(:script_lang)  { :jsp }

        it "must set the :script_lang key in #rfi_kwargs to :jsp" do
          expect(subject.rfi_kwargs[:script_lang]).to eq(script_lang)
        end
      end

      context "when the option value is 'php'" do
        let(:option_value) { 'php' }
        let(:script_lang)  { :php }

        it "must set the :script_lang key in #rfi_kwargs to :php" do
          expect(subject.rfi_kwargs[:script_lang]).to eq(script_lang)
        end
      end

      context "when the option value is 'perl'" do
        let(:option_value) { 'perl' }
        let(:script_lang)  { :perl }

        it "must set the :script_lang key in #rfi_kwargs to :perl" do
          expect(subject.rfi_kwargs[:script_lang]).to eq(script_lang)
        end
      end
    end

    context "when the '--rfi-test-script-url' option is given" do
      let(:test_script_url) { 'https://other-website.com/path/to/rfi_test.php' }
      let(:argv) { ['--rfi-test-script-url', test_script_url] }

      before { subject.option_parser.parse(argv) }

      it "must set the :test_script_url key in the Hash" do
        expect(subject.rfi_kwargs[:test_script_url]).to eq(test_script_url)
      end
    end

    context "when the '--sqli-escape-quote' option is given" do
      let(:argv) { %w[--sqli-escape-quote] }

      before { subject.option_parser.parse(argv) }

      it "must set the :escape_quote key in the Hash" do
        expect(subject.sqli_kwargs[:escape_quote]).to be(true)
      end
    end

    context "when the '--sqli-escape-parens' option is given" do
      let(:argv) { %w[--sqli-escape-parens] }

      before { subject.option_parser.parse(argv) }

      it "must set the :escape_parens key in the Hash" do
        expect(subject.sqli_kwargs[:escape_parens]).to be(true)
      end
    end

    context "when the '--sqli-terminate' option is given" do
      let(:argv) { %w[--sqli-terminate] }

      before { subject.option_parser.parse(argv) }

      it "must set the :terminate key in the Hash" do
        expect(subject.sqli_kwargs[:terminate]).to be(true)
      end
    end

    context "when the '--ssti-test-expr' option is given" do
      let(:test) { '7*7' }
      let(:argv) { ['--ssti-test-expr', test] }

      before { subject.option_parser.parse(argv) }

      it "must set the :test_expr key in the Hash" do
        kwargs = subject.ssti_kwargs

        expect(kwargs[:test_expr]).to be_kind_of(Ronin::Vulns::SSTI::TestExpression)
        expect(kwargs[:test_expr].string).to eq(test)
      end
    end

    context "when the '--open-redirect-url' option is given" do
      let(:test_url) { 'https://example.com/test' }
      let(:argv)     { ['--open-redirect-url', test_url] }

      before { subject.option_parser.parse(argv) }

      it "must set the :test_url key in the Hash" do
        expect(subject.open_redirect_kwargs[:test_url]).to eq(test_url)
      end
    end
  end

  describe "#initialize" do
    it "must default #scan_mode to :all" do
      expect(subject.scan_mode).to eq(:all)
    end

    it "must default #scan_kwargs to {}" do
      expect(subject.scan_kwargs).to eq({})
    end
  end

  describe "#run" do
    module TestVulnsCommand
      class App < Sinatra::Base

        set :host, 'example.com'
        set :port, 80

        get '/' do
          <<~HTML
            <html>
              <body>
                <ul>
                  <li><a href="/page1?id=1">Page 1</a></li>
                  <li><a href="/page2?q=foo">Page 2</a></li>
                </ul>
              </body>
            </html>
          HTML
        end

        get '/page1' do
          <<~HTML
            <html>
              <body>
                <h1>Page 1</h1>

                <p>Foo bar baz</p>
              </body>
            </html>
          HTML
        end

        get '/page2' do
          <<~HTML
            <html>
              <body>
                <h1>Page 2</h1>

                <p>Foo bar baz</p>
              </body>
            </html>
          HTML
        end

      end
    end

    let(:host) { 'example.com' }
    let(:app)  { TestVulnsCommand::App }

    before do
      stub_request(:get, /#{Regexp.escape(host)}/).to_rack(app)

      subject.option_parser.parse(['--host', host])
    end

    it "must spider the website and test every URL" do
      expect {
        subject.run
      }.to output(
        <<~OUTPUT
          >>> Testing http://#{host}/
          >>> Testing http://#{host}/page1?id=1
          >>> Testing http://#{host}/page2?q=foo
          No vulnerabilities found
        OUTPUT
      ).to_stdout

      expect(WebMock).to have_requested(:get, "http://#{host}/")
      expect(WebMock).to have_requested(:get, "http://#{host}/page1?id=1")
      expect(WebMock).to have_requested(:get, "http://#{host}/page2?q=foo")
    end

    context "when one of the URLs is vulnerable" do
      module TestVulnsCommand
        class VulnApp < Sinatra::Base

          set :host, 'example.com'
          set :port, 80

          get '/' do
            <<~HTML
              <html>
                <body>
                  <ul>
                    <li><a href="/page1?id=1">Page 1</a></li>
                    <li><a href="/page2?q=foo">Page 2</a></li>
                  </ul>
                </body>
              </html>
            HTML
          end

          get '/page1' do
            if params[:id] =~ /\A1'\) OR \d+=\d+--\z/
              <<~HTML
                <html>
                  <body>
                    <ul>
                      <li>entry 1</li>
                      <li>entry 2</li>
                      <li>entry 3</li>
                    </ul>
                  </body>
                </html>
              HTML
            else
              <<~HTML
                <html>
                  <body>
                    <ul>
                      <li>entry 1</li>
                    </ul>
                  </body>
                </html>
              HTML
            end
          end

          get '/page2' do
            if params[:q] =~ %r{\A(\.\./){3,}etc/passwd\z}
              <<~HTML
                <html>
                  <body>
                    <h1>Page 2</h1>

                    root:x:0:0:Super User:/root:/bin/bash
                  </body>
                </html>
              HTML
            else
              <<~HTML
                <html>
                  <body>
                    <h1>Page 2</h1>

                    <p>Foo bar baz</p>
                  </body>
                </html>
              HTML
            end
          end

        end
      end

      let(:app) { TestVulnsCommand::VulnApp }

      it "must print the vulnerabilities that are found" do
        expect {
          subject.run
        }.to output(
          <<~OUTPUT
            >>> Testing http://#{host}/
            >>> Testing http://#{host}/page1?id=1
            /!\\ Found SQLi on http://#{host}/page1?id=1 via query param 'id'!
            >>> Testing http://#{host}/page2?q=foo
            /!\\ Found LFI on http://example.com/page2?q=foo via query param 'q'!

            Vulnerabilities found!

              SQLi on http://#{host}/page1?id=1 via query param 'id'
              LFI on http://example.com/page2?q=foo via query param 'q'

          OUTPUT
        ).to_stdout

        expect(WebMock).to have_requested(:get, "http://#{host}/")
        expect(WebMock).to have_requested(:get, "http://#{host}/page1?id=1")
        expect(WebMock).to have_requested(:get, "http://#{host}/page2?q=foo")
      end

      context "but the --first option is given" do
        before { subject.option_parser.parse(%w[--first]) }

        it "must stop spidering once the first vulnerability is found" do
          expect {
            subject.run
          }.to output(
            <<~OUTPUT
              >>> Testing http://#{host}/
              >>> Testing http://#{host}/page1?id=1
              /!\\ Found SQLi on http://#{host}/page1?id=1 via query param 'id'!

              Vulnerabilities found!

                SQLi on http://#{host}/page1?id=1 via query param 'id'

            OUTPUT
          ).to_stdout

          expect(WebMock).to have_requested(:get, "http://#{host}/")
        end
      end
    end
  end

  describe "#scan_kwargs" do
    it "must default to an empty Hash" do
      expect(subject.scan_kwargs).to eq({})
    end
  end

  describe "#lfi_kwargs" do
    it "must default to an empty Hash" do
      expect(subject.lfi_kwargs).to eq({})
    end

    it "must also set :lfi in scan_kwargs to #lfi_kwargs" do
      subject.lfi_kwargs

      expect(subject.scan_kwargs[:lfi]).to be(subject.lfi_kwargs)
    end
  end

  describe "#rfi_kwargs" do
    it "must default to an empty Hash" do
      expect(subject.rfi_kwargs).to eq({})
    end

    it "must also set :rfi in scan_kwargs to #rfi_kwargs" do
      subject.rfi_kwargs

      expect(subject.scan_kwargs[:rfi]).to be(subject.rfi_kwargs)
    end
  end

  describe "#sqli_kwargs" do
    it "must default to an empty Hash" do
      expect(subject.sqli_kwargs).to eq({})
    end

    it "must also set :sqli in scan_kwargs to #sqli_kwargs" do
      subject.sqli_kwargs

      expect(subject.scan_kwargs[:sqli]).to be(subject.sqli_kwargs)
    end
  end

  describe "#ssti_kwargs" do
    it "must default to an empty Hash" do
      expect(subject.ssti_kwargs).to eq({})
    end

    it "must also set :ssti in scan_kwargs to #ssti_kwargs" do
      subject.ssti_kwargs

      expect(subject.scan_kwargs[:ssti]).to be(subject.ssti_kwargs)
    end
  end

  describe "#open_redirect_kwargs" do
    it "must default to an empty Hash" do
      expect(subject.open_redirect_kwargs).to eq({})
    end

    it "must also set :open_redirect in scan_kwargs to #open_redirect_kwargs" do
      subject.open_redirect_kwargs

      expect(subject.scan_kwargs[:open_redirect]).to be(subject.open_redirect_kwargs)
    end
  end

  describe "#reflected_xss_kwargs" do
    it "must return an empty Hash by default" do
      expect(subject.reflected_xss_kwargs).to eq({})
    end

    it "must also set :reflected_xss in scan_kwargs to #reflected_xss_kwargs" do
      subject.reflected_xss_kwargs

      expect(subject.scan_kwargs[:reflected_xss]).to be(subject.reflected_xss_kwargs)
    end
  end

  describe "#process_vuln" do
    let(:vuln) { double('WebVuln object') }

    it "must call #log_vuln with the given vuln object" do
      expect(subject).to receive(:log_vuln).with(vuln)

      subject.process_vuln(vuln)
    end

    context "when options[:import] is true" do
      before { subject.options[:import] = true }

      it "must call #log_vuln and then #import_vuln with the vuln object" do
        expect(subject).to receive(:log_vuln).with(vuln)
        expect(subject).to receive(:import_vuln).with(vuln)

        subject.process_vuln(vuln)
      end
    end
  end

  describe "#default_headers" do
    it "must return a Hash" do
      expect(subject.default_headers).to eq({})
    end

    before { subject.default_headers }

    it "must set :default_headers in #agent_kwargs to an empty Hash" do
      expect(subject.agent_kwargs[:default_headers]).to be(subject.default_headers)
    end

    it "must set :headers in #scan_kwargs to an empty Hash" do
      subject.default_headers

      expect(subject.scan_kwargs[:headers]).to be(subject.default_headers)
      expect(subject.agent_kwargs[:default_headers]).to be(subject.default_headers)
    end
  end

  describe "#user_agent=" do
    let(:user_agent) { 'Foo Bar' }

    before { subject.user_agent = user_agent }

    it "must set :user_agent in #agent_kwargs" do
      expect(subject.agent_kwargs[:user_agent]).to eq(user_agent)
    end

    it "must set :user_agent in #scan_kwargs" do
      expect(subject.scan_kwargs[:user_agent]).to eq(user_agent)
    end
  end

  describe "#referer=" do
    let(:referer) { 'https://example.com/' }

    before { subject.referer = referer }

    it "must set :referer in #agent_kwargs" do
      expect(subject.agent_kwargs[:referer]).to eq(referer)
    end

    it "must set :referer in #scan_kwargs" do
      expect(subject.scan_kwargs[:referer]).to eq(referer)
    end
  end

  describe "#lfi_kwargs" do
    it "must return a Hash" do
      expect(subject.lfi_kwargs).to eq({})
    end

    it "must set :lfi_kwargs in #scan_kwargs to an empty Hash" do
      subject.lfi_kwargs

      expect(subject.scan_kwargs[:lfi]).to eq({})
    end
  end

  describe "#rfi_kwargs" do
    it "must return a Hash" do
      expect(subject.rfi_kwargs).to eq({})
    end

    it "must set :rfi_kwargs in #scan_kwargs to an empty Hash" do
      subject.rfi_kwargs

      expect(subject.scan_kwargs[:rfi]).to eq({})
    end
  end

  describe "#sqli_kwargs" do
    it "must return a Hash" do
      expect(subject.sqli_kwargs).to eq({})
    end

    it "must set :sqli_kwargs in #scan_kwargs to an empty Hash" do
      subject.sqli_kwargs

      expect(subject.scan_kwargs[:sqli]).to eq({})
    end
  end

  describe "#ssti_kwargs" do
    it "must return a Hash" do
      expect(subject.ssti_kwargs).to eq({})
    end

    it "must set :ssti_kwargs in #scan_kwargs to an empty Hash" do
      subject.ssti_kwargs

      expect(subject.scan_kwargs[:ssti]).to eq({})
    end
  end

  describe "#open_redirect_kwargs" do
    it "must return a Hash" do
      expect(subject.open_redirect_kwargs).to eq({})
    end

    it "must set :open_redirect_kwargs in #scan_kwargs to an empty Hash" do
      subject.open_redirect_kwargs

      expect(subject.scan_kwargs[:open_redirect]).to eq({})
    end
  end

  describe "#reflected_xss_kwargs" do
    it "must return a Hash" do
      expect(subject.reflected_xss_kwargs).to eq({})
    end

    it "must set :reflected_xss_kwargs in #scan_kwargs to an empty Hash" do
      subject.reflected_xss_kwargs

      expect(subject.scan_kwargs[:reflected_xss]).to eq({})
    end
  end

  let(:url) { 'https://example.com/page.php?id=1' }

  describe "#scan_url" do
    it "must call Ronin::Vulns::URLScanner.scan with the URL and #scan_kwargs" do
      expect(Ronin::Vulns::URLScanner).to receive(:scan).with(
        url, **subject.scan_kwargs
      )

      subject.scan_url(url)
    end
  end

  describe "#test_url" do
    it "must call Ronin::Vulns::URLScanner.scan with the URL and #scan_kwargs" do
      expect(Ronin::Vulns::URLScanner).to receive(:test).with(
        url, **subject.scan_kwargs
      )

      subject.test_url(url)
    end
  end
end
