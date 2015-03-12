require 'rails_helper'

RSpec.describe MedicationRoute, :type => :model do

  it { should have_many(:medications) }
  it { should have_many(:patients).through(:medications) }

end
