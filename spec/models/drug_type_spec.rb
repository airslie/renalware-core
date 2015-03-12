require 'rails_helper'

RSpec.describe DrugType, :type => :model do

  it { should have_many(:drug_drug_types) }
  it { should have_many(:drugs).through(:drug_drug_types) }

end
