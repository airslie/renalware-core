require 'rails_helper'

module Renalware
  RSpec.describe ModalityCode, :type => :model do
    it { should have_many :modalities }
    it { should have_many(:patients).through(:modalities)}

    it { should validate_presence_of :name }
    it { should validate_presence_of :code }
  end
end