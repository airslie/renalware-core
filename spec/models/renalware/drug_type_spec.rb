require 'rails_helper'

module Renalware
  RSpec.describe DrugType, :type => :model do

    it { should have_many(:drug_drug_types) }
    it { should have_many(:drugs).through(:drug_drug_types) }

  end
end