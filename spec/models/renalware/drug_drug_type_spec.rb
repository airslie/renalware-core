require 'rails_helper'

module Renalware
  RSpec.describe DrugDrugType, :type => :model do

    it { should belong_to(:drug) }
    it { should belong_to(:drug_type) }

  end
end