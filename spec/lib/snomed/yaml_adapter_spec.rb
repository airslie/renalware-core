require 'rails_helper'

describe Snomed::YamlAdapter do

  subject { Snomed::YamlAdapter.new }

  describe 'search' do

    before do
      Snomed::YamlAdapter.data = nil
    end

    it 'should read data from file' do
      expect(YAML).to receive(:load_file)
        .with(Rails.root.join("db", "static", "snomed.yml"))
        .and_return([{'conceptId' => 123, 'term' => 'Foo'}])

      actual = subject.search(query: 'foo')

      expect(actual).to be_a(Snomed::Response)
      expect(actual.results).to be_a(Array)
      expect(actual.results.first['term']).to eq('Foo')
    end

    it 'should only read from file once' do
      expect(YAML).to receive(:load_file)
        .with(Rails.root.join("db", "static", "snomed.yml")).once
        .and_return([{'conceptId' => 123, 'term' => 'Foo'}])

      subject.search(query: 'foo')
      subject.search(query: 'bar')
    end
  end
end
