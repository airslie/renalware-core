require 'rails_helper'

RSpec.describe Snomed, :type => :model do
  
  context "lookup" do
    before do
      stub_request(:get, "http://snomed.com/").
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => '[{"concept": "cool beans"}]', :headers => {})
      @results = Snomed.lookup "cool beans"
    end

    it "should give us snomed results" do
      expect(@results.is_a? Array).to be true
      expect(@results.length).to eq(1)
      expect(@results[0]["concept"]).to eq("cool beans")
    end
  end

end
