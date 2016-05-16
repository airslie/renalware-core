require 'rails_helper'

module Renalware
  describe Practice, type: :model do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :code }
  end
end