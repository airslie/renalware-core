require 'rails_helper'

RSpec.describe Snomed, :type => :model do

  context "lookup" do
    before do
      allow(YAML).to receive(:load_file).and_return(
        [{'id' => 123, 'label' => 'cool beans'}])

      @results = Snomed.lookup "cool beans"
    end

    it "should give us snomed results" do
      expect(@results.is_a? Array).to be true
      expect(@results.length).to eq(1)
      expect(@results[0].values[1]).to eq("cool beans")
    end
  end

end
