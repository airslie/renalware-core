require 'rails_helper'

RSpec.describe ExitSiteInfection, :type => :model do
 
  it { should have_many(:medications) }
  it { should have_many(:medication_routes).through(:medications) }
  it { should have_many(:patients).through(:medications) }    
  it { should have_many(:infection_organisms) }
  it { should have_many(:organism_codes).through(:infection_organisms) }

end
