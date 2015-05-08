require 'rails_helper'

describe Snomed::ApiAdapter do

  describe 'search' do
    before do
      req_url = 'http://localhost:3100/snomed/en-edition/v20150131/descriptions?query=foo'
      stub_request(:get, req_url)
        .to_return(body: {
          'details' => { 'total' => 1 },
          'filters' => { 'semTag' => { 'disorder' => 1 } },
          'matches' => [{'conceptId' => 9876, 'term' => 'API Foo'}]
        }.to_json)
    end

    subject { Snomed::ApiAdapter.new }

    it 'should make a request to the API endpoint' do

      actual = subject.search(query: 'foo')

      expect(actual).to be_a(Snomed::Response)
      expect(actual.total).to eq(1)
      expect(actual.results).to be_a(Array)
      expect(actual.results.first['term']).to eq('API Foo')
    end
  end
end
