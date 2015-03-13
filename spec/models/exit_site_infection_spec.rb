require 'rails_helper'

RSpec.describe ExitSiteInfection, :type => :model do
  it { should belong_to :patient }

  it { should have_many(:infection_organisms) }
  it { should have_many(:organism_codes).through(:infection_organisms) }

end
