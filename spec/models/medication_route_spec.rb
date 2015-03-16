require 'rails_helper'

RSpec.describe MedicationRoute, :type => :model do

  it { should have_many(:medications) }
  it { should have_many(:patients).through(:medications) }
  it { should have_many(:exit_site_infections).through(:medications).source(:treatable)  }
  it { should have_many(:peritonitis_episodes).through(:medications).source(:treatable) }

end
