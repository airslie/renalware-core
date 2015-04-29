require 'rails_helper'

describe Snomed do

  before(:each) do
    Object.send(:remove_const, 'Snomed')
    load 'snomed.rb'
    load 'snomed/adapter.rb'
  end

  describe 'search' do
    context 'with a YAML adapter' do
      before do
        Snomed.configure(adapter: Snomed::YamlAdapter)
      end
      it 'should read data from file' do
        expect(YAML).to receive(:load_file)
          .with(Rails.root.join('data','snomed.yml'))
          .and_return([{'id' => 123, 'label' => 'Foo'}])

        actual = Snomed.search(query: 'foo')

        expect(actual).to be_a(Snomed::Response)
        expect(actual.results).to be_a(Array)
        expect(actual.results.first['label']).to eq('Foo')
      end
      it 'should only read from file once' do
      end
    end

    context 'with an API adapter' do
      before do
        req_url = 'http://localhost:3000/snomed/en-edition/v20150131/descriptions?query=foo'
        stub_request(:get, req_url)
          .to_return(body: {
            'details' => { 'total' => 1 },
            'filters' => { 'semTag' => { 'disorder' => 1 } },
            'matches' => [{'id' => 9876, 'label' => 'API Foo'}]
          }.to_json)

        Snomed.configure(adapter: Snomed::ApiAdapter)
      end
      it 'should make a request to the API endpoint' do

        actual = Snomed.search(query: 'foo')

        expect(actual).to be_a(Snomed::Response)
        expect(actual.total).to eq(1)
        expect(actual.results).to be_a(Array)
        expect(actual.results.first['label']).to eq('API Foo')
      end
    end

    context 'with a Test adapter' do
      before do
        Snomed.configure(adapter: Snomed::TestAdapter)
      end
      it 'should return static data' do
        actual = Snomed.search(query: 'foo')

        expect(actual).to be_a(Snomed::Response)
        expect(actual.total).to eq(1)
        expect(actual.results).to be_a(Array)
        expect(actual.results.first['label']).to eq('cool beans')
      end
    end
  end

end
