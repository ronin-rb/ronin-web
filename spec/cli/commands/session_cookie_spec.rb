require 'spec_helper'
require 'ronin/web/cli/commands/session_cookie'
require_relative 'man_page_example'

require 'pp'
require 'json'
require 'yaml'

describe Ronin::Web::CLI::Commands::SessionCookie do
  include_examples "man_page"

  describe "#run" do
    context "when a Django session cookie is given" do
      let(:cookie) { "sessionid=eyJmb28iOiJiYXIifQ:1pQcTx:UufiSnuPIjNs7zOAJS0UpqnyvRt7KET7BVes0I8LYbA" }

      let(:params) do
        {"foo" => "bar"}
      end
      let(:salt) { 1676070425 }
      let(:hmac) do
        "R\xE7\xE2J{\x8F\"3l\xEF3\x80%-\x14\xA6\xA9\xF2\xBD\e{(D\xFB\x05W\xAC\xD0\x8F\va\xB0".b
      end

      it "must print the Django session cookie params" do
        expect {
          subject.run(cookie)
        }.to output("#{params.pretty_print_inspect}#{$/}").to_stdout
      end

      context "and when '--format json' is given" do
        before { subject.parse_options(%w[--format json]) }

        let(:json_params) { JSON.pretty_generate(params) }

        it "must print the Django session cookie params in JSON format" do
          expect {
            subject.run(cookie)
          }.to output("#{json_params}#{$/}").to_stdout
        end
      end

      context "and when '--format yaml' is given" do
        before { subject.parse_options(%w[--format yaml]) }

        let(:yaml_params) { YAML.dump(params) }

        it "must print the Django session cookie params in YAML format" do
          expect {
            subject.run(cookie)
          }.to output(yaml_params).to_stdout
        end
      end

      context "and when '--verbose' is given" do
        before { subject.parse_options(%w[--verbose]) }

        let(:pretty_printed_params) { params.pretty_print_inspect }

        let(:hex_escaped_hmac) { Ronin::Support::Encoding::Hex.quote(hmac) }

        it "must print 'Type: Django', the session cookie params, the salt, and the HMAC" do
          expect {
            subject.run(cookie)
          }.to output(
            [
              'Type: Django',
              'Params:',
              '',
              *pretty_printed_params.each_line(chomp: true).map { |line|
                "  #{line}"
              },
              '',
              "Salt: #{salt}",
              "HMAC: #{hex_escaped_hmac}",
              ''
            ].join($/)
          ).to_stdout
        end

        context "and when '--format json' is given" do
          before { subject.parse_options(%w[--verbose --format json]) }

          let(:json_params) { JSON.pretty_generate(params) }

          it "must print 'Type: Django', the JSON session cookie params, the salt, and the HMAC" do
            expect {
              subject.run(cookie)
            }.to output(
              [
                'Type: Django',
                'Params:',
                '',
                *json_params.each_line(chomp: true).map { |line|
                  "  #{line}"
                },
                '',
                "Salt: #{salt}",
                "HMAC: #{hex_escaped_hmac}",
                ''
              ].join($/)
            ).to_stdout
          end
        end

        context "and when '--format yaml' is given" do
          before { subject.parse_options(%w[--verbose --format yaml]) }

          let(:yaml_params) { YAML.dump(params) }

          it "must print 'Type: Django', the YAML session cookie params, the salt, and the HMAC" do
            expect {
              subject.run(cookie)
            }.to output(
              [
                'Type: Django',
                'Params:',
                '',
                *yaml_params.each_line(chomp: true).map { |line|
                  "  #{line}"
                },
                '',
                "Salt: #{salt}",
                "HMAC: #{hex_escaped_hmac}",
                ''
              ].join($/)
            ).to_stdout
          end
        end
      end
    end

    context "when a JWT session cookie is given" do
      let(:cookie) { 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c' }

      let(:header) do
        {"alg" => "HS256", "typ" => "JWT"}
      end
      let(:params) do
        {"sub" => "1234567890", "name" => "John Doe", "iat" => 1516239022}
      end
      let(:hmac) { "I\xF9J\xC7\x04IH\xC7\x8A(]\x90O\x87\xF0\xA4\xC7\x89\x7F~\x8F:N\xB2%V\x9DB\xCB0\xE5".b }

      it "must print the JWT session cookie params" do
        expect {
          subject.run(cookie)
        }.to output("#{params.pretty_print_inspect}#{$/}").to_stdout
      end

      context "and when '--format json' is given" do
        before { subject.parse_options(%w[--format json]) }

        let(:json_params) { JSON.pretty_generate(params) }

        it "must print the JWT session cookie params in JSON format" do
          expect {
            subject.run(cookie)
          }.to output("#{json_params}#{$/}").to_stdout
        end
      end

      context "and when '--format yaml' is given" do
        before { subject.parse_options(%w[--format yaml]) }

        let(:yaml_params) { YAML.dump(params) }

        it "must print the JWT session cookie params in YAML format" do
          expect {
            subject.run(cookie)
          }.to output(yaml_params).to_stdout
        end
      end

      context "and when '--verbose' is given" do
        before { subject.parse_options(%w[--verbose]) }

        let(:pretty_printed_header) { header.pretty_print_inspect }
        let(:pretty_printed_params) { params.pretty_print_inspect }

        let(:hex_escaped_hmac) { Ronin::Support::Encoding::Hex.quote(hmac) }

        it "must print 'Type: JWT', the header params, the session cookie params, and the HMAC" do
          expect {
            subject.run(cookie)
          }.to output(
            [
              'Type: JWT',
              'Header:',
              '',
              *pretty_printed_header.each_line(chomp: true).map { |line|
                "  #{line}"
              },
              '',
              'Params:',
              '',
              *pretty_printed_params.each_line(chomp: true).map { |line|
                "  #{line}"
              },
              '',
              "HMAC: #{hex_escaped_hmac}",
              ''
            ].join($/)
          ).to_stdout
        end

        context "and when '--format json' is given" do
          before { subject.parse_options(%w[--verbose --format json]) }

          let(:json_header) { JSON.pretty_generate(header) }
          let(:json_params) { JSON.pretty_generate(params) }

          it "must print the JWT session cookie params in JSON format" do
            expect {
              subject.run(cookie)
            }.to output(
              [
                'Type: JWT',
                'Header:',
                '',
                *json_header.each_line(chomp: true).map { |line|
                  "  #{line}"
                },
                '',
                'Params:',
                '',
                *json_params.each_line(chomp: true).map { |line|
                  "  #{line}"
                },
                '',
                "HMAC: #{hex_escaped_hmac}",
                ''
              ].join($/)
            ).to_stdout
          end
        end

        context "and when '--format yaml' is given" do
          before { subject.parse_options(%w[--verbose --format yaml]) }

          let(:yaml_header) { YAML.dump(header) }
          let(:yaml_params) { YAML.dump(params) }

          it "must print the JWT session cookie params in YAML format" do
            expect {
              subject.run(cookie)
            }.to output(
              [
                'Type: JWT',
                'Header:',
                '',
                *yaml_header.each_line(chomp: true).map { |line|
                  "  #{line}"
                },
                '',
                'Params:',
                '',
                *yaml_params.each_line(chomp: true).map { |line|
                  "  #{line}"
                },
                '',
                "HMAC: #{hex_escaped_hmac}",
                ''
              ].join($/)
            ).to_stdout
          end
        end
      end
    end

    context "when a Rack session cookie is given" do
      let(:cookie) { "BAh7CEkiD3Nlc3Npb25faWQGOgZFVG86HVJhY2s6OlNlc3Npb246OlNlc3Npb25JZAY6D0BwdWJsaWNfaWRJIkUyYWJkZTdkM2I0YTMxNDE5OThiYmMyYTE0YjFmMTZlNTNlMWMzYWJlYzhiYzc4ZjVhMGFlMGUwODJmMjJlZGIxBjsARkkiCWNzcmYGOwBGSSIxNHY1TmRCMGRVaklXdjhzR3J1b2ZhM2xwNHQyVGp5ZHptckQycjJRWXpIZz0GOwBGSSINdHJhY2tpbmcGOwBGewZJIhRIVFRQX1VTRVJfQUdFTlQGOwBUSSItOTkxNzUyMWYzN2M4ODJkNDIyMzhmYmI5Yzg4MzFmMWVmNTAwNGQyYwY7AEY=--02184e43850f38a46c8f22ffb49f7f22be58e272" }

      let(:params) do
        {
          "session_id" => Rack::Session::SessionId.new(
            "2abde7d3b4a3141998bbc2a14b1f16e53e1c3abec8bc78f5a0ae0e082f22edb1"
          ),
          "csrf"       => "4v5NdB0dUjIWv8sGruofa3lp4t2TjydzmrD2r2QYzHg=",
          "tracking"   => {
            "HTTP_USER_AGENT" => "9917521f37c882d42238fbb9c8831f1ef5004d2c"
          }
        }
      end
      let(:hmac) { '02184e43850f38a46c8f22ffb49f7f22be58e272' }

      it "must print the Rack session cookie params" do
        expect {
          subject.run(cookie)
        }.to output("#{params.pretty_print_inspect}#{$/}").to_stdout
      end

      context "and when '--format json' is given" do
        before { subject.parse_options(%w[--format json]) }

        let(:json_params) { JSON.pretty_generate(params) }

        it "must print the Rack session cookie params in JSON format" do
          expect {
            subject.run(cookie)
          }.to output("#{json_params}#{$/}").to_stdout
        end
      end

      context "and when '--format yaml' is given" do
        before { subject.parse_options(%w[--format yaml]) }

        let(:yaml_params) { YAML.dump(params) }

        it "must print the Rack session cookie params in YAML format" do
          expect {
            subject.run(cookie)
          }.to output(yaml_params).to_stdout
        end
      end

      context "and when '--verbose' is given" do
        before { subject.parse_options(%w[--verbose]) }

        let(:pretty_printed_params) { params.pretty_print_inspect }

        it "must print 'Type: Rack', the Rack session cookie params, and the HMAC" do
          expect {
            subject.run(cookie)
          }.to output(
            [
              'Type: Rack',
              'Params:',
              '',
              *pretty_printed_params.each_line(chomp: true).map { |line|
                "  #{line}"
              },
              '',
              "HMAC: #{hmac}",
              ''
            ].join($/)
          ).to_stdout
        end

        context "and when '--format json' is given" do
          before { subject.parse_options(%w[--verbose --format json]) }

          let(:json_params) { JSON.pretty_generate(params) }

          it "must print the Rack session cookie params in JSON format" do
            expect {
              subject.run(cookie)
            }.to output(
              [
                'Type: Rack',
                'Params:',
                '',
                *json_params.each_line(chomp: true).map { |line|
                  "  #{line}"
                },
                '',
                "HMAC: #{hmac}",
                ''
              ].join($/)
            ).to_stdout
          end
        end

        context "and when '--format yaml' is given" do
          before { subject.parse_options(%w[--verbose --format yaml]) }

          let(:yaml_params) { YAML.dump(params) }

          it "must print the Rack session cookie params in YAML format" do
            expect {
              subject.run(cookie)
            }.to output(
              [
                'Type: Rack',
                'Params:',
                '',
                *yaml_params.each_line(chomp: true).map { |line|
                  "  #{line}"
                },
                '',
                "HMAC: #{hmac}",
                ''
              ].join($/)
            ).to_stdout
          end
        end
      end
    end

    context "but when the session cookie could not be parsed" do
      let(:cookie) { "foo" }

      it "must print an error and exit with -1" do
        expect(subject).to receive(:print_error).with("no session cookie found")
        expect(subject).to receive(:exit).with(-1)

        subject.run(cookie)
      end
    end
  end

  describe "#print_django_session_cookie" do
    let(:params) do
      {"foo" => "bar"}
    end
    let(:salt) { 1676070425 }
    let(:hmac) do
      "R\xE7\xE2J{\x8F\"3l\xEF3\x80%-\x14\xA6\xA9\xF2\xBD\e{(D\xFB\x05W\xAC\xD0\x8F\va\xB0".b
    end

    let(:session_cookie) do
      Ronin::Web::SessionCookie::Django.new(params,salt,hmac)
    end

    it "must print the Django session cookie params" do
      expect {
        subject.print_session_cookie(session_cookie)
      }.to output("#{params.pretty_print_inspect}#{$/}").to_stdout
    end

    context "and when '--format json' is given" do
      before { subject.parse_options(%w[--format json]) }

      let(:json_params) { JSON.pretty_generate(params) }

      it "must print the Django session cookie params in JSON format" do
        expect {
          subject.print_session_cookie(session_cookie)
        }.to output("#{json_params}#{$/}").to_stdout
      end
    end

    context "and when '--format yaml' is given" do
      before { subject.parse_options(%w[--format yaml]) }

      let(:yaml_params) { YAML.dump(params) }

      it "must print the Django session cookie params in YAML format" do
        expect {
          subject.print_session_cookie(session_cookie)
        }.to output(yaml_params).to_stdout
      end
    end

    context "and when '--verbose' is given" do
      before { subject.parse_options(%w[--verbose]) }

      let(:pretty_printed_params) { params.pretty_print_inspect }

      let(:hex_escaped_hmac) { Ronin::Support::Encoding::Hex.quote(hmac) }

      it "must print 'Type: Django', the session cookie params, the salt, and the HMAC" do
        expect {
          subject.print_session_cookie(session_cookie)
        }.to output(
          [
            'Type: Django',
            'Params:',
            '',
            *pretty_printed_params.each_line(chomp: true).map { |line|
              "  #{line}"
            },
            '',
            "Salt: #{salt}",
            "HMAC: #{hex_escaped_hmac}",
            ''
          ].join($/)
        ).to_stdout
      end

      context "and when '--format json' is given" do
        before { subject.parse_options(%w[--verbose --format json]) }

        let(:json_params) { JSON.pretty_generate(params) }

        it "must print 'Type: Django', the JSON session cookie params, the salt, and the HMAC" do
          expect {
            subject.print_session_cookie(session_cookie)
          }.to output(
            [
              'Type: Django',
              'Params:',
              '',
              *json_params.each_line(chomp: true).map { |line|
                "  #{line}"
              },
              '',
              "Salt: #{salt}",
              "HMAC: #{hex_escaped_hmac}",
              ''
            ].join($/)
          ).to_stdout
        end
      end

      context "and when '--format yaml' is given" do
        before { subject.parse_options(%w[--verbose --format yaml]) }

        let(:yaml_params) { YAML.dump(params) }

        it "must print 'Type: Django', the YAML session cookie params, the salt, and the HMAC" do
          expect {
            subject.print_session_cookie(session_cookie)
          }.to output(
            [
              'Type: Django',
              'Params:',
              '',
              *yaml_params.each_line(chomp: true).map { |line|
                "  #{line}"
              },
              '',
              "Salt: #{salt}",
              "HMAC: #{hex_escaped_hmac}",
              ''
            ].join($/)
          ).to_stdout
        end
      end
    end
  end

  describe "#print_jwt_session_cookie" do
    let(:header) do
      {"alg" => "HS256", "typ" => "JWT"}
    end
    let(:params) do
      {"sub" => "1234567890", "name" => "John Doe", "iat" => 1516239022}
    end
    let(:hmac) { "I\xF9J\xC7\x04IH\xC7\x8A(]\x90O\x87\xF0\xA4\xC7\x89\x7F~\x8F:N\xB2%V\x9DB\xCB0\xE5".b }

    let(:session_cookie) do
      Ronin::Web::SessionCookie::JWT.new(header,params,hmac)
    end

    it "must print the JWT session cookie params" do
      expect {
        subject.print_jwt_session_cookie(session_cookie)
      }.to output("#{params.pretty_print_inspect}#{$/}").to_stdout
    end

    context "and when '--format json' is given" do
      before { subject.parse_options(%w[--format json]) }

      let(:json_params) { JSON.pretty_generate(params) }

      it "must print the JWT session cookie params in JSON format" do
        expect {
          subject.print_jwt_session_cookie(session_cookie)
        }.to output("#{json_params}#{$/}").to_stdout
      end
    end

    context "and when '--format yaml' is given" do
      before { subject.parse_options(%w[--format yaml]) }

      let(:yaml_params) { YAML.dump(params) }

      it "must print the JWT session cookie params in YAML format" do
        expect {
          subject.print_jwt_session_cookie(session_cookie)
        }.to output(yaml_params).to_stdout
      end
    end

    context "and when '--verbose' is given" do
      before { subject.parse_options(%w[--verbose]) }

      let(:pretty_printed_header) { header.pretty_print_inspect }
      let(:pretty_printed_params) { params.pretty_print_inspect }

      let(:hex_escaped_hmac) { Ronin::Support::Encoding::Hex.quote(hmac) }

      it "must print 'Type: JWT', the header params, the session cookie params, and the HMAC" do
        expect {
          subject.print_jwt_session_cookie(session_cookie)
        }.to output(
          [
            'Type: JWT',
            'Header:',
            '',
            *pretty_printed_header.each_line(chomp: true).map { |line|
              "  #{line}"
            },
            '',
            'Params:',
            '',
            *pretty_printed_params.each_line(chomp: true).map { |line|
              "  #{line}"
            },
            '',
            "HMAC: #{hex_escaped_hmac}",
            ''
          ].join($/)
        ).to_stdout
      end

      context "and when '--format json' is given" do
        before { subject.parse_options(%w[--verbose --format json]) }

        let(:json_header) { JSON.pretty_generate(header) }
        let(:json_params) { JSON.pretty_generate(params) }

        it "must print the JWT session cookie params in JSON format" do
          expect {
            subject.print_jwt_session_cookie(session_cookie)
          }.to output(
            [
              'Type: JWT',
              'Header:',
              '',
              *json_header.each_line(chomp: true).map { |line|
                "  #{line}"
              },
              '',
              'Params:',
              '',
              *json_params.each_line(chomp: true).map { |line|
                "  #{line}"
              },
              '',
              "HMAC: #{hex_escaped_hmac}",
              ''
            ].join($/)
          ).to_stdout
        end
      end

      context "and when '--format yaml' is given" do
        before { subject.parse_options(%w[--verbose --format yaml]) }

        let(:yaml_header) { YAML.dump(header) }
        let(:yaml_params) { YAML.dump(params) }

        it "must print the JWT session cookie params in YAML format" do
          expect {
            subject.print_jwt_session_cookie(session_cookie)
          }.to output(
            [
              'Type: JWT',
              'Header:',
              '',
              *yaml_header.each_line(chomp: true).map { |line|
                "  #{line}"
              },
              '',
              'Params:',
              '',
              *yaml_params.each_line(chomp: true).map { |line|
                "  #{line}"
              },
              '',
              "HMAC: #{hex_escaped_hmac}",
              ''
            ].join($/)
          ).to_stdout
        end
      end
    end
  end

  describe "#print_rack_session_cookie" do
    let(:params) do
      {
        "session_id" => Rack::Session::SessionId.new(
          "2abde7d3b4a3141998bbc2a14b1f16e53e1c3abec8bc78f5a0ae0e082f22edb1"
        ),
        "csrf"       => "4v5NdB0dUjIWv8sGruofa3lp4t2TjydzmrD2r2QYzHg=",
        "tracking"   => {
          "HTTP_USER_AGENT" => "9917521f37c882d42238fbb9c8831f1ef5004d2c"
        }
      }
    end
    let(:hmac) { '02184e43850f38a46c8f22ffb49f7f22be58e272' }

    let(:session_cookie) do
      Ronin::Web::SessionCookie::Rack.new(params,hmac)
    end

    it "must print the Rack session cookie params" do
      expect {
        subject.print_rack_session_cookie(session_cookie)
      }.to output("#{params.pretty_print_inspect}#{$/}").to_stdout
    end

    context "and when '--format json' is given" do
      before { subject.parse_options(%w[--format json]) }

      let(:json_params) { JSON.pretty_generate(params) }

      it "must print the Rack session cookie params in JSON format" do
        expect {
          subject.print_rack_session_cookie(session_cookie)
        }.to output("#{json_params}#{$/}").to_stdout
      end
    end

    context "and when '--format yaml' is given" do
      before { subject.parse_options(%w[--format yaml]) }

      let(:yaml_params) { YAML.dump(params) }

      it "must print the Rack session cookie params in YAML format" do
        expect {
          subject.print_rack_session_cookie(session_cookie)
        }.to output(yaml_params).to_stdout
      end
    end

    context "and when '--verbose' is given" do
      before { subject.parse_options(%w[--verbose]) }

      let(:pretty_printed_params) { params.pretty_print_inspect }

      it "must print 'Type: Rack', the Rack session cookie params, and the HMAC" do
        expect {
          subject.print_rack_session_cookie(session_cookie)
        }.to output(
          [
            'Type: Rack',
            'Params:',
            '',
            *pretty_printed_params.each_line(chomp: true).map { |line|
              "  #{line}"
            },
            '',
            "HMAC: #{hmac}",
            ''
          ].join($/)
        ).to_stdout
      end

      context "and when '--format json' is given" do
        before { subject.parse_options(%w[--verbose --format json]) }

        let(:json_params) { JSON.pretty_generate(params) }

        it "must print the Rack session cookie params in JSON format" do
          expect {
            subject.print_rack_session_cookie(session_cookie)
          }.to output(
            [
              'Type: Rack',
              'Params:',
              '',
              *json_params.each_line(chomp: true).map { |line|
                "  #{line}"
              },
              '',
              "HMAC: #{hmac}",
              ''
            ].join($/)
          ).to_stdout
        end
      end

      context "and when '--format yaml' is given" do
        before { subject.parse_options(%w[--verbose --format yaml]) }

        let(:yaml_params) { YAML.dump(params) }

        it "must print the Rack session cookie params in YAML format" do
          expect {
            subject.print_rack_session_cookie(session_cookie)
          }.to output(
            [
              'Type: Rack',
              'Params:',
              '',
              *yaml_params.each_line(chomp: true).map { |line|
                "  #{line}"
              },
              '',
              "HMAC: #{hmac}",
              ''
            ].join($/)
          ).to_stdout
        end
      end
    end
  end

  describe "#print_params" do
    let(:params) do
      {"foo" => "bar"}
    end

    it "must pretty-print the given params" do
      expect {
        subject.print_params(params)
      }.to output("#{params.pretty_print_inspect}#{$/}").to_stdout
    end

    context "and when '--format json' is given" do
      before { subject.parse_options(%w[--format json]) }

      let(:json_params) { JSON.pretty_generate(params) }

      it "must print the params in JSON format" do
        expect {
          subject.print_params(params)
        }.to output("#{json_params}#{$/}").to_stdout
      end
    end

    context "and when '--format yaml' is given" do
      before { subject.parse_options(%w[--format yaml]) }

      let(:yaml_params) { YAML.dump(params) }

      it "must print the params in YAML format" do
        expect {
          subject.print_params(params)
        }.to output(yaml_params).to_stdout
      end
    end
  end

  describe "#format_params" do
    let(:params) do
      {"foo" => "bar"}
    end

    it "must pretty-print format the given params" do
      expect(subject.format_params(params)).to eq(params.pretty_print_inspect)
    end

    context "and when '--format json' is given" do
      before { subject.parse_options(%w[--format json]) }

      let(:json_params) { JSON.pretty_generate(params) }

      it "must format the params as JSON" do
        expect(subject.format_params(params)).to eq(json_params)
      end
    end

    context "and when '--format yaml' is given" do
      before { subject.parse_options(%w[--format yaml]) }

      let(:yaml_params) { YAML.dump(params) }

      it "must format the params as YAML" do
        expect(subject.format_params(params)).to eq(yaml_params)
      end
    end
  end
end
