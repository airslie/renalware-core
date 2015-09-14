require 'rails_helper'

module Renalware
  RSpec.describe ModalityReason, :type => :model do
    it { should have_many :modalities }
  end
end