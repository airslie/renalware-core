require 'rails_helper'

module Renalware
  describe Address, type: :model do
    it { should validate_presence_of :street_1 }
  end
end