require 'spec_helper'
require 'ronin/web/cli/commands/user_agent'

describe Ronin::Web::CLI::Commands::UserAgent do
  describe "options" do
    context "when '--linux-distro ubuntu' is given" do
      before do
        subject.option_parser.parse(%w[--linux-distro ubuntu])
      end

      it "must set options[:linux_distro] to :ubuntu" do
        expect(subject.options[:linux_distro]).to be(:ubuntu)
      end
    end

    context "when '--linux-distro fedora' is given" do
      before do
        subject.option_parser.parse(%w[--linux-distro fedora])
      end

      it "must set options[:linux_distro] to :fedora" do
        expect(subject.options[:linux_distro]).to be(:fedora)
      end
    end

    context "when '--linux-distro arch' is given" do
      before do
        subject.option_parser.parse(%w[--linux-distro arch])
      end

      it "must set options[:linux_distro] to :arch" do
        expect(subject.options[:linux_distro]).to be(:arch)
      end
    end

    context "when '--linux-distro ...' is given" do
      let(:distro) { 'Foo Linux' }

      before do
        subject.option_parser.parse(['--linux-distro', distro])
      end

      it "must set options[:linux_distro] to the given argument" do
        expect(subject.options[:linux_distro]).to eq(distro)
      end
    end
  end

  describe "#run" do
    context "when options[:browser] is :chrome" do
      before { subject.options[:browser] = :chrome }

      it "must print a random Chrome User-Agent string" do
        expect {
          subject.run
        }.to output(
          %r{^Mozilla/5\.0 \([^\(\)]+(?:\([^\)]+\)[^\)]+)?\) AppleWebKit/537\.36 \(KHTML, like Gecko\) Chrome/\d+(\.\d+)* (?:Mobile )?Safari/537\.36$}
        ).to_stdout
      end
    end

    context "when options[:browser] is :firefox" do
      before { subject.options[:browser] = :firefox }

      it "must print a random FireFox User-Agent string" do
        expect {
          subject.run
        }.to output(
          %r{^Mozilla/5\.0 \([^\)]+\) Gecko/(?:20100101|\d+(?:\.\d+)*) Firefox/\d+(\.\d+)*$}
        ).to_stdout
      end
    end

    context "when options[:browser] is nil" do
      before { subject.options[:browser] = nil }

      it "must print a random Chrome or FireFox User-Agent string" do
        expect {
          subject.run
        }.to output(
          %r{
            ^(?:
               Mozilla/5\.0\ \([^\)]+\)\ AppleWebKit/537\.36\ \(KHTML,\ like\ Gecko\)\ Chrome/\d+(\.\d+)*\ (?:Mobile\ )?Safari/537\.36|
               Mozilla/5\.0\ \([^\)]+\)\ Gecko/(?:20100101|\d+(?:\.\d+)*)\ Firefox/\d+(\.\d+)*
             )$
            }x
        ).to_stdout
      end
    end
  end

  describe "#random_kwargs" do
    context "when options[:chrome_version] is set" do
      let(:chrome_version) { '1.2.3' }

      context "and options[:browser] is :chrome" do
        before do
          subject.options[:browser]        = :chrome
          subject.options[:chrome_version] = chrome_version
        end

        it "must set the chrome_version: keyword argument" do
          expect(subject.random_kwargs[:chrome_version]).to eq(chrome_version)
        end
      end

      context "and options[:browser] is :firefox" do
        before do
          subject.options[:browser]        = :firefox
          subject.options[:chrome_version] = chrome_version
        end

        it "must not set the chrome_version: keyword argument" do
          expect(subject.random_kwargs[:chrome_version]).to be(nil)
        end
      end
    end

    context "when options[:firefox_version] is set" do
      let(:firefox_version) { '1.2.3' }

      context "and options[:browser] is :firefox" do
        before do
          subject.options[:browser]         = :firefox
          subject.options[:firefox_version] = firefox_version
        end

        it "must set the firefox_version: keyword argument" do
          expect(subject.random_kwargs[:firefox_version]).to eq(firefox_version)
        end
      end

      context "and options[:browser] is :chrome" do
        before do
          subject.options[:browser]         = :chrome
          subject.options[:firefox_version] = firefox_version
        end

        it "must not set the firefox_version: keyword argument" do
          expect(subject.random_kwargs[:firefox_version]).to be(nil)
        end
      end
    end

    context "when options[:os] is set" do
      let(:os) { :linux }

      before { subject.options[:os] = os }

      it "must set the os: keyword argument" do
        expect(subject.random_kwargs[:os]).to eq(os)
      end
    end

    context "when options[:os_version] is set" do
      let(:os_version) { '1.2.3' }

      before { subject.options[:os_version] = os_version }

      it "must set the os_version: keyword argument" do
        expect(subject.random_kwargs[:os_version]).to eq(os_version)
      end
    end

    context "when options[:linux_distro] is set" do
      let(:linux_distro) { :ubuntu }

      before { subject.options[:linux_distro] = linux_distro }

      it "must set the linux_distro: keyword argument" do
        expect(subject.random_kwargs[:linux_distro]).to eq(linux_distro)
      end
    end

    context "when options[:arch] is set" do
      let(:arch) { :x86_64 }

      before { subject.options[:arch] = arch }

      it "must set the arch: keyword argument" do
        expect(subject.random_kwargs[:arch]).to eq(arch)
      end
    end
  end
end
