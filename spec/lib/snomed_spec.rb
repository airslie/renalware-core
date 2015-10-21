require 'rails_helper'
require_dependency 'snomed'

describe Snomed do

  let(:adapter_class) { double(:adapter_class) }
  let(:adapter) { double(:adapter) }

  before do
    # Reload the module
    Object.send(:remove_const, 'Snomed')
    load 'snomed.rb'
    load 'snomed/yaml_adapter.rb'
  end

  describe 'configure' do
    it 'memoizes configuration on the module' do
      allow(adapter_class).to receive(:new).and_return(adapter)

      Snomed.configure(adapter: adapter_class)
      expect(Snomed.adapter).to eq(adapter)

      Snomed.configure(adapter: 'foo')
      expect(Snomed.adapter).to eq(adapter)
    end
  end

  describe 'adapter' do
    it 'initializes the adapter' do
      expect(adapter_class).to receive(:new).and_return(adapter)
      Snomed.configure(adapter: adapter_class)
      actual = Snomed.adapter

      expect(actual).to eq(adapter)
    end
  end

  describe 'search' do
    it 'calls the underlying adapter search' do
      allow(adapter_class).to receive(:new).and_return(adapter)

      Snomed.configure(adapter: adapter_class)
      expect(adapter).to receive(:search).with(query: 'foo')

      Snomed.search(query: 'foo')
    end
  end
end
