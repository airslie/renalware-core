require 'rails_helper'

module Renalware::Events
  describe Type, type: :model do
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :name }
  end
end
