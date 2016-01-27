require 'rails_helper'

module Renalware
  RSpec.describe OrganismCode, :type => :model do

    it { should have_many(:infection_organisms) }
    it { should have_many(:peritonitis_episodes).through(:infection_organisms).source(:infectable) }
    it { should have_many(:exit_site_infections).through(:infection_organisms).source(:infectable) }

  end
end