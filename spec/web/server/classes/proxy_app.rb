require 'ronin/web/server/base'

class ProxyApp < Ronin::Web::Server::Base

  get '/' do
    proxy
  end

  get '/reddit/erlang' do
    proxy(:host => 'www.reddit.com', :path => '/r/erlang')
  end

  get '/r/erlang' do
    proxy do |body|
      for_host(/reddit\./) do
        body.gsub(/erlang/i,'Fixed Gear Bicycle')
      end
    end
  end

  get '/r/ruby' do
    proxy_doc do |response,doc|
      for_host(/reddit\.com/) do
        doc.search('div.link').each do |link|
          if link.at('a.title').inner_text =~ /rails/i
            link.remove
          end
        end
      end
    end
  end

  get '/rss.php' do
    proxy_doc do |response,doc|
      for_host('milworm.com') do
        doc.search('//item').each do |item|
          if item.inner_text =~ /(XSS|SQLi|SQL\s+Injection)/i
            item.remove
          end
        end
      end
    end
  end

end
