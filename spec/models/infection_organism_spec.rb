require 'rails_helper'

RSpec.describe InfectionOrganism, :type => :model do
  it { should belong_to(:organism_code) }
  it { should belong_to(:infectable) }
end
