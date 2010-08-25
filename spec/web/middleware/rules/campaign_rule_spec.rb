require 'spec_helper'
require 'ronin/spec/database'
require 'ronin/web/middleware/rules/campaign_rule'

describe Web::Middleware::Rules::CampaignRule do
  subject { Web::Middleware::Rules::CampaignRule }

  let(:name) { 'Ronin::Web::Middleware' }
  let(:ip) { '192.168.1.42' }

  before(:all) do
    campaign = Campaign.new(
      :name => name,
      :description => 'Campaign for Ronin::Web::Middleware::Rules::CampaignRule'
    )
    campaign.addresses << IPAddress.new(:address => ip)

    campaign.save
  end

  before(:each) do
    @request = mock('request')
    @request.should_receive(:ip).and_return(ip)
  end

  it "should match requests by IP Address and targeting Campaign" do
    rule = subject.new(name)

    rule.match?(@request).should == true
  end
end
