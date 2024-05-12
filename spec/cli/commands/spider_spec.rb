require 'spec_helper'
require 'ronin/web/cli/commands/spider'
require_relative 'man_page_example'

describe Ronin::Web::CLI::Commands::Spider do
  include_examples "man_page"

  describe "options" do
    context "when --open-timeout option is given" do
      let(:timeout) { 10 }

      before do
        subject.option_parser.parse(['--open-timeout', timeout.to_s])
      end

      it "must set :open_timeout in #agent_kwargs" do
        expect(subject.agent_kwargs[:open_timeout]).to eq(timeout)
      end
    end

    context "when --read-timeout option is given" do
      let(:timeout) { 10 }

      before do
        subject.option_parser.parse(['--read-timeout', timeout.to_s])
      end

      it "must set :read_timeout in #agent_kwargs" do
        expect(subject.agent_kwargs[:read_timeout]).to eq(timeout)
      end
    end

    context "when --ssl-timeout option is given" do
      let(:timeout) { 10 }

      before do
        subject.option_parser.parse(['--ssl-timeout', timeout.to_s])
      end

      it "must set :ssl_timeout in #agent_kwargs" do
        expect(subject.agent_kwargs[:ssl_timeout]).to eq(timeout)
      end
    end

    context "when --continue-timeout option is given" do
      let(:timeout) { 10 }

      before do
        subject.option_parser.parse(['--continue-timeout', timeout.to_s])
      end

      it "must set :continue_timeout in #agent_kwargs" do
        expect(subject.agent_kwargs[:continue_timeout]).to eq(timeout)
      end
    end

    context "when --keep-alive-timeout option is given" do
      let(:timeout) { 10 }

      before do
        subject.option_parser.parse(['--keep-alive-timeout', timeout.to_s])
      end

      it "must set :keep_alive_timeout in #agent_kwargs" do
        expect(subject.agent_kwargs[:keep_alive_timeout]).to eq(timeout)
      end
    end

    context "when the --proxy option is given" do
      let(:proxy) { 'http://example.com:8080' }

      before do
        subject.option_parser.parse(['--proxy', proxy])
      end

      it "must set :proxy in #agent_kwargs" do
        expect(subject.agent_kwargs[:proxy]).to eq(proxy)
      end
    end

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
    end

    context "when the --host-header option is given" do
      let(:host_ip1)     { '192.168.1.1' }
      let(:host1)        { 'foo.example.com' }
      let(:host_header1) { "#{host_ip1}=#{host1}" }

      let(:host_ip2)     { '192.168.1.100' }
      let(:host2)        { 'bar.example.com' }
      let(:host_header2) { "#{host_ip2}=#{host2}" }

      before do
        subject.option_parser.parse(['--host-header', host_header1, '--host-header', host_header2])
      end

      it "must set :host_headers in #agent_kwargs" do
        expect(subject.agent_kwargs[:host_headers]).to eq(
          {
            host_ip1 => host1,
            host_ip2 => host2
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
    end

    context "when the --delay option is given" do
      let(:delay) { 10 }

      before do
        subject.option_parser.parse(['--delay', delay.to_s])
      end

      it "must set :delay in #agent_kwargs" do
        expect(subject.agent_kwargs[:delay]).to eq(delay)
      end
    end

    context "when the --limit option is given" do
      let(:limit) { 10 }

      before do
        subject.option_parser.parse(['--limit', limit.to_s])
      end

      it "must set :limit in #agent_kwargs" do
        expect(subject.agent_kwargs[:limit]).to eq(limit)
      end
    end

    context "when the --max-depth option is given" do
      let(:max_depth) { 10 }

      before do
        subject.option_parser.parse(['--max-depth', max_depth.to_s])
      end

      it "must set :max_depth in #agent_kwargs" do
        expect(subject.agent_kwargs[:max_depth]).to eq(max_depth)
      end
    end

    context "when the --enqueue option is given" do
      let(:url1) { 'https://example.com/page1' }
      let(:url2) { 'https://example.com/page2' }

      before do
        subject.option_parser.parse(['--enqueue', url1, '--enqueue', url2])
      end

      it "must set :queue in #agent_kwargs" do
        expect(subject.agent_kwargs[:queue]).to eq([url1, url2])
      end
    end

    context "when the --visited option is given" do
      let(:url1) { 'https://example.com/page1' }
      let(:url2) { 'https://example.com/page2' }

      before do
        subject.option_parser.parse(['--visited', url1, '--visited', url2])
      end

      it "must set :history in #agent_kwargs" do
        expect(subject.agent_kwargs[:history]).to eq([url1, url2])
      end
    end

    context "when the --strip-fragments option is given" do
      before do
        subject.option_parser.parse(%w[--strip-fragments])
      end

      it "must set :strip_fragments in #agent_kwargs" do
        expect(subject.agent_kwargs[:strip_fragments]).to be(true)
      end
    end

    context "when the --strip-query option is given" do
      before do
        subject.option_parser.parse(%w[--strip-query])
      end

      it "must set :strip_query in #agent_kwargs" do
        expect(subject.agent_kwargs[:strip_query]).to be(true)
      end
    end

    context "when the --visit-scheme option is given" do
      let(:scheme1) { 'http' }
      let(:scheme2) { 'https' }

      before do
        subject.option_parser.parse(['--visit-scheme', scheme1, '--visit-scheme', scheme2])
      end

      it "must set :schemes in #agent_kwargs" do
        expect(subject.agent_kwargs[:schemes]).to eq([scheme1, scheme2])
      end
    end

    context "when the --visit-schemes-like option is given" do
      let(:scheme1) { '/http/' }
      let(:scheme2) { '/https/' }
      let(:regex1)  { /http/ }
      let(:regex2)  { /https/ }

      before do
        subject.option_parser.parse(['--visit-schemes-like', scheme1, '--visit-schemes-like', scheme2])
      end

      it "must set :schemes in #agent_kwargs" do
        expect(subject.agent_kwargs[:schemes]).to eq([regex1, regex2])
      end
    end

    context "when the --ignore-scheme option is given" do
      let(:scheme1) { 'http' }
      let(:scheme2) { 'https' }

      before do
        subject.option_parser.parse(['--ignore-scheme', scheme1, '--ignore-scheme', scheme2])
      end

      it "must set :ignore_schemes in #agent_kwargs" do
        expect(subject.agent_kwargs[:ignore_schemes]).to eq([scheme1, scheme2])
      end
    end

    context "when the --ignore-schemes-like option is given" do
      let(:scheme1) { '/http/' }
      let(:scheme2) { '/https/' }
      let(:regex1)  { /http/ }
      let(:regex2)  { /https/ }

      before do
        subject.option_parser.parse(['--ignore-schemes-like', scheme1, '--ignore-schemes-like', scheme2])
      end

      it "must set :schemes in #agent_kwargs" do
        expect(subject.agent_kwargs[:ignore_schemes]).to eq([regex1, regex2])
      end
    end

    context "when the --visit-host option is given" do
      let(:host1) { 'foo.example.com' }
      let(:host2) { 'bar.example.com' }

      before do
        subject.option_parser.parse(['--visit-host', host1, '--visit-host', host2])
      end

      it "must set :hosts in #agent_kwargs" do
        expect(subject.agent_kwargs[:hosts]).to eq([host1, host2])
      end
    end

    context "when the --visit-hosts-like option is given" do
      let(:host1) { '/foo\./' }
      let(:host2) { '/bar\./' }
      let(:regex1)  { /foo\./ }
      let(:regex2)  { /bar\./ }

      before do
        subject.option_parser.parse(['--visit-hosts-like', host1, '--visit-hosts-like', host2])
      end

      it "must set :hosts in #agent_kwargs" do
        expect(subject.agent_kwargs[:hosts]).to eq([regex1, regex2])
      end
    end

    context "when the --ignore-host option is given" do
      let(:host1) { 'foo.example.com' }
      let(:host2) { 'bar.example.com' }

      before do
        subject.option_parser.parse(['--ignore-host', host1, '--ignore-host', host2])
      end

      it "must set :ignore_hosts in #agent_kwargs" do
        expect(subject.agent_kwargs[:ignore_hosts]).to eq([host1, host2])
      end
    end

    context "when the --ignore-hosts-like option is given" do
      let(:host1) { '/foo\./' }
      let(:host2) { '/bar\./' }
      let(:regex1)  { /foo\./ }
      let(:regex2)  { /bar\./ }

      before do
        subject.option_parser.parse(['--ignore-hosts-like', host1, '--ignore-hosts-like', host2])
      end

      it "must set :hosts in #agent_kwargs" do
        expect(subject.agent_kwargs[:ignore_hosts]).to eq([regex1, regex2])
      end
    end

    context "when the --visit-port option is given" do
      let(:port1) { 80 }
      let(:port2) { 8080 }

      before do
        subject.option_parser.parse(['--visit-port', port1.to_s, '--visit-port', port2.to_s])
      end

      it "must set :ports in #agent_kwargs" do
        expect(subject.agent_kwargs[:ports]).to eq([port1, port2])
      end
    end

    context "when the --visit-ports-like option is given" do
      let(:port1) { '/100\d/' }
      let(:port2) { '/8080/' }
      let(:regex1)  { /100\d/ }
      let(:regex2)  { /8080/ }

      before do
        subject.option_parser.parse(['--visit-ports-like', port1, '--visit-ports-like', port2])
      end

      it "must set :ports in #agent_kwargs" do
        expect(subject.agent_kwargs[:ports]).to eq([regex1, regex2])
      end
    end

    context "when the --ignore-port option is given" do
      let(:port1) { 80 }
      let(:port2) { 8080 }

      before do
        subject.option_parser.parse(['--ignore-port', port1.to_s, '--ignore-port', port2.to_s])
      end

      it "must set :ignore_ports in #agent_kwargs" do
        expect(subject.agent_kwargs[:ignore_ports]).to eq([port1, port2])
      end
    end

    context "when the --ignore-ports-like option is given" do
      let(:port1) { '/100\d/' }
      let(:port2) { '/8080/' }
      let(:regex1)  { /100\d/ }
      let(:regex2)  { /8080/ }

      before do
        subject.option_parser.parse(['--ignore-ports-like', port1, '--ignore-ports-like', port2])
      end

      it "must set :ports in #agent_kwargs" do
        expect(subject.agent_kwargs[:ignore_ports]).to eq([regex1, regex2])
      end
    end

    context "when the --visit-link option is given" do
      let(:link1) { 'https://example.com/page.html' }
      let(:link2) { 'https://example.com/page.xml' }

      before do
        subject.option_parser.parse(['--visit-link', link1, '--visit-link', link2])
      end

      it "must set :links in #agent_kwargs" do
        expect(subject.agent_kwargs[:links]).to eq([link1, link2])
      end
    end

    context "when the --visit-links-like option is given" do
      let(:link1) { '/\.html\z/' }
      let(:link2) { '/\.xml\z/' }
      let(:regex1)  { /\.html\z/ }
      let(:regex2)  { /\.xml\z/ }

      before do
        subject.option_parser.parse(['--visit-links-like', link1, '--visit-links-like', link2])
      end

      it "must set :links in #agent_kwargs" do
        expect(subject.agent_kwargs[:links]).to eq([regex1, regex2])
      end
    end

    context "when the --ignore-link option is given" do
      let(:link1) { 'https://example.com/page.html' }
      let(:link2) { 'https://example.com/page.xml' }

      before do
        subject.option_parser.parse(['--ignore-link', link1, '--ignore-link', link2])
      end

      it "must set :ignore_links in #agent_kwargs" do
        expect(subject.agent_kwargs[:ignore_links]).to eq([link1, link2])
      end
    end

    context "when the --ignore-links-like option is given" do
      let(:link1) { '/\.html\z/' }
      let(:link2) { '/\.xml\z/' }
      let(:regex1)  { /\.html\z/ }
      let(:regex2)  { /\.xml\z/ }

      before do
        subject.option_parser.parse(['--ignore-links-like', link1, '--ignore-links-like', link2])
      end

      it "must set :links in #agent_kwargs" do
        expect(subject.agent_kwargs[:ignore_links]).to eq([regex1, regex2])
      end
    end

    context "when the --visit-ext option is given" do
      let(:ext1) { '.html' }
      let(:ext2) { '.xml' }

      before do
        subject.option_parser.parse(['--visit-ext', ext1, '--visit-ext', ext2])
      end

      it "must set :exts in #agent_kwargs" do
        expect(subject.agent_kwargs[:exts]).to eq([ext1, ext2])
      end
    end

    context "when the --visit-exts-like option is given" do
      let(:ext1) { '/\.htm/' }
      let(:ext2) { '/\.xml/' }
      let(:regex1)  { /\.htm/ }
      let(:regex2)  { /\.xml/ }

      before do
        subject.option_parser.parse(['--visit-exts-like', ext1, '--visit-exts-like', ext2])
      end

      it "must set :exts in #agent_kwargs" do
        expect(subject.agent_kwargs[:exts]).to eq([regex1, regex2])
      end
    end

    context "when the --ignore-ext option is given" do
      let(:ext1) { '.htm' }
      let(:ext2) { '.xml' }

      before do
        subject.option_parser.parse(['--ignore-ext', ext1, '--ignore-ext', ext2])
      end

      it "must set :ignore_exts in #agent_kwargs" do
        expect(subject.agent_kwargs[:ignore_exts]).to eq([ext1, ext2])
      end
    end

    context "when the --ignore-exts-like option is given" do
      let(:ext1) { '/\.htm/' }
      let(:ext2) { '/\.xml/' }
      let(:regex1)  { /\.htm/ }
      let(:regex2)  { /\.xml/ }

      before do
        subject.option_parser.parse(['--ignore-exts-like', ext1, '--ignore-exts-like', ext2])
      end

      it "must set :exts in #agent_kwargs" do
        expect(subject.agent_kwargs[:ignore_exts]).to eq([regex1, regex2])
      end
    end

    context "when the --robots option is given" do
      before do
        subject.option_parser.parse(['--robots'])
      end

      it "must set :robots in #agent_kwargs" do
        expect(subject.agent_kwargs[:robots]).to be(true)
      end
    end
  end
end
