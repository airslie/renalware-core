require 'rails_helper'

describe Snomed::Response do
  describe 'results' do
    it 'returns matches' do
      expect(Snomed::Response.new(matches: [1,2,3]).results).to eq([1,2,3])
    end
  end
  describe 'total' do
    it 'returns the details[total] attribute value if present' do
      expect(Snomed::Response.new(details: {'total' => 5}).total).to eq(5)
    end
    it 'returns the size of matches if present' do
      expect(Snomed::Response.new(matches: [1,2,3]).total).to eq(3)
    end
    it 'returns zero for not total or matches attributes' do
      expect(Snomed::Response.new.total).to eq(0)
    end
  end
end
