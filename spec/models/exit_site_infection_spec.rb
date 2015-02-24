require 'rails_helper'

RSpec.describe ExitSiteInfection, :type => :model do
  it { should belong_to :patient }
end
