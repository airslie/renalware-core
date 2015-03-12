require 'rails_helper'

RSpec.describe Drug, :type => :model do

  it { should have_many(:medications) }
  it { should have_many(:patients).through(:medications) }
  it { should have_many(:drug_drug_types) }
  it { should have_many(:drug_types).through(:drug_drug_types) }

end
